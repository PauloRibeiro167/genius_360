#!/bin/bash

# Script para corrigir problemas de bundler e instalação de gems
# Uso: bundle_fix.sh

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📦 Iniciando correção de bundler...${NC}"
echo -e "📅 Data: $(date)"

# Verificar presença do docker-compose.yml
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Arquivo docker-compose.yml não encontrado!${NC}"
    echo "Execute este script a partir do diretório raiz do projeto."
    exit 1
fi

# Verificar se o container web existe
if ! docker ps -a | grep -q "genius360_web"; then
    echo -e "${YELLOW}⚠️ Container web não encontrado, criando...${NC}"
    docker-compose up -d
    sleep 5
fi

# Verificar status do container
CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' genius360_web 2>/dev/null || echo "not_found")
IS_RESTARTING=$(docker inspect --format='{{.State.Restarting}}' genius360_web 2>/dev/null || echo "false")

if [ "$CONTAINER_STATUS" = "not_found" ]; then
    echo -e "${RED}❌ Container web não encontrado mesmo após tentativa de criação!${NC}"
    echo -e "${YELLOW}⚠️ Tentando criar novamente...${NC}"
    docker-compose up -d
    sleep 5
    CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' genius360_web 2>/dev/null || echo "not_found")
    if [ "$CONTAINER_STATUS" = "not_found" ]; then
        echo -e "${RED}❌ Falha ao criar container web!${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🔍 Status atual do container web: $CONTAINER_STATUS (Reiniciando: $IS_RESTARTING)${NC}"

if [ "$IS_RESTARTING" = "true" ]; then
    echo -e "${YELLOW}⚠️ Container está em loop de reinicialização. Parando primeiro...${NC}"
    docker-compose down
fi

# Backups
echo -e "${BLUE}📂 Criando backups de arquivos importantes...${NC}"
BACKUP_DIR="./backups/bundler_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f "Gemfile.lock" ]; then
    cp Gemfile.lock "$BACKUP_DIR/Gemfile.lock.bak"
    echo "✅ Backup de Gemfile.lock criado"
fi

# Verificar se estamos usando vendor/bundle
USES_VENDOR=$(grep -c "vendor/bundle" .bundle/config 2>/dev/null || echo "0")

if [ "$USES_VENDOR" != "0" ]; then
    echo -e "${BLUE}📂 Projeto usa vendor/bundle para gemas${NC}"
    mkdir -p vendor/bundle
    chmod -R 777 vendor/bundle
else
    echo -e "${BLUE}📂 Projeto usa bundle global${NC}"
fi

echo -e "\n${BLUE}==== ETAPA 1: Limpeza ====${NC}"
echo -e "${YELLOW}🧹 Removendo arquivos temporários e caches...${NC}"
rm -rf .bundle/cache tmp/cache/bootsnap* 2>/dev/null
echo "✅ Caches limpos"

echo -e "\n${BLUE}==== ETAPA 2: Correção do ambiente ====${NC}"

# Verificar se a imagem Docker tem o bundle
echo -e "${YELLOW}🔍 Verificando ambiente Docker...${NC}"

# Executar em container temporário para instalar bundler
echo -e "${BLUE}📦 Instalando bundler atualizado...${NC}"
docker run --rm \
    -v "$(pwd):/app" \
    -w /app \
    ruby:3.2.2 bash -c "
        gem update --system && 
        gem install bundler:2.6.2 && 
        bundle config set --local path 'vendor/bundle' && 
        echo '✅ Bundler instalado no container temporário'
    "

echo -e "\n${BLUE}==== ETAPA 3: Instalando dependências ====${NC}"
echo -e "${YELLOW}📦 Executando 'bundle install' no container...${NC}"

# Executar bundle install no container temporário
docker run --rm \
    -v "$(pwd):/app" \
    -w /app \
    ruby:3.2.2 bash -c "
        export BUNDLE_PATH=vendor/bundle && 
        gem install bundler:2.6.2 && 
        bundle config set --local path 'vendor/bundle' && 
        bundle config set --local without 'production staging' && 
        bundle install --jobs=4 --retry=3
    "

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Bundle install executado com sucesso!${NC}"
else
    echo -e "${RED}❌ Erro durante bundle install. Tentando método alternativo...${NC}"
    
    # Tentar resolver problemas com a plataforma
    docker run --rm \
        -v "$(pwd):/app" \
        -w /app \
        ruby:3.2.2 bash -c "
            export BUNDLE_PATH=vendor/bundle && 
            bundle config set --local path 'vendor/bundle' && 
            bundle config set --local force_ruby_platform true && 
            bundle install --jobs=4 --retry=3
        "
    
    RESULT=$?
    
    if [ $RESULT -eq 0 ]; then
        echo -e "${GREEN}✅ Bundle install com force_ruby_platform executado com sucesso!${NC}"
    else
        echo -e "${RED}❌ Todos os métodos de bundle install falharam.${NC}"
        echo -e "${YELLOW}⚠️ Considerando uma abordagem mais drástica - removendo Gemfile.lock${NC}"
        
        if [ -f "Gemfile.lock" ]; then
            cp Gemfile.lock "$BACKUP_DIR/Gemfile.lock.before_removal"
            rm -f Gemfile.lock
            echo "🗑️ Gemfile.lock removido"
            
            # Executar bundle install novamente sem o Gemfile.lock
            docker run --rm \
                -v "$(pwd):/app" \
                -w /app \
                ruby:3.2.2 bash -c "
                    export BUNDLE_PATH=vendor/bundle && 
                    bundle config set --local path 'vendor/bundle' && 
                    bundle install --jobs=4 --retry=3
                "
            
            RESULT=$?
            
            if [ $RESULT -eq 0 ]; then
                echo -e "${GREEN}✅ Bundle install sem Gemfile.lock executado com sucesso!${NC}"
            else
                echo -e "${RED}❌ Todos os métodos de bundle install falharam.${NC}"
                exit 1
            fi
        fi
    fi
fi

echo -e "\n${BLUE}==== ETAPA 4: Definindo permissões ====${NC}"
echo -e "${YELLOW}🔒 Ajustando permissões...${NC}"

# Corrigir permissões
if [ -d "vendor/bundle" ]; then
    chmod -R 777 vendor/bundle
    echo "✅ Permissões de vendor/bundle ajustadas"
fi

chmod -R 777 tmp 2>/dev/null || true
chmod -R 777 log 2>/dev/null || true
echo "✅ Permissões de tmp e log ajustadas"

echo -e "\n${BLUE}==== ETAPA 5: Reiniciando container web ====${NC}"
echo -e "${YELLOW}🔄 Reiniciando container...${NC}"
docker-compose down
docker-compose up -d
sleep 5

# Verificar status final
CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' genius360_web 2>/dev/null || echo "not_found")
IS_RESTARTING=$(docker inspect --format='{{.State.Restarting}}' genius360_web 2>/dev/null || echo "false")

echo -e "${BLUE}🔍 Status final do container web: $CONTAINER_STATUS (Reiniciando: $IS_RESTARTING)${NC}"

if [ "$IS_RESTARTING" = "true" ]; then
    echo -e "${RED}❌ O container ainda está em loop de reinicialização.${NC}"
    echo -e "${YELLOW}Verifique os logs para mais detalhes:${NC}"
    docker logs --tail 30 genius360_web
    echo -e "\n${YELLOW}⚠️ Você pode tentar 'make fix-container-full' para uma abordagem mais drástica.${NC}"
    exit 1
elif [ "$CONTAINER_STATUS" = "running" ]; then
    echo -e "${GREEN}✅ Correção de bundler concluída com sucesso!${NC}"
    echo -e "${GREEN}🚀 Container web está rodando.${NC}"
else
    echo -e "${RED}❌ Container web não está rodando! Status: $CONTAINER_STATUS${NC}"
    echo -e "${YELLOW}Verifique os logs para mais detalhes:${NC}"
    docker logs --tail 30 genius360_web
    exit 1
fi
