#!/bin/bash

# Script para reconstrução forçada do ambiente Docker
# Uso: force_rebuild.sh [--keep-db]

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Opções
KEEP_DB=false
if [ "$1" == "--keep-db" ]; then
    KEEP_DB=true
fi

echo -e "${BLUE}🚨 Iniciando reconstrução forçada do ambiente...${NC}"
echo "📅 $(date)"

# Verificar se estamos no diretório correto (com docker-compose.yml)
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Arquivo docker-compose.yml não encontrado!${NC}"
    echo "Execute este script a partir do diretório raiz do projeto."
    exit 1
fi

# Parar todos os containers
echo -e "${YELLOW}⏹️ Parando e removendo containers...${NC}"
docker-compose down

# Criar diretório para backup de arquivos importantes
BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup de arquivos importantes
echo "📦 Fazendo backup de arquivos importantes..."
if [ -f "config/database.yml" ]; then
    cp config/database.yml "$BACKUP_DIR/"
fi
if [ -f ".env" ]; then
    cp .env "$BACKUP_DIR/"
fi

# Limpar arquivos problemáticos
echo "🧹 Limpando arquivos problemáticos..."
if [ -f "tmp/pids/server.pid" ]; then
    rm -f tmp/pids/server.pid
fi
if [ -d "tmp/miniprofiler" ]; then
    rm -rf tmp/miniprofiler/*
fi

# Desativar miniprofiler temporariamente
echo "🔧 Desativando miniprofiler temporariamente..."
chmod +x bin/disable_miniprofiler.sh
./bin/disable_miniprofiler.sh

# Corrigir permissões
echo "🔧 Corrigindo permissões de diretórios..."
chmod +x bin/fix_permissions.sh
./bin/fix_permissions.sh

# Remover volumes se não estiver preservando banco de dados
if [ "$KEEP_DB" = false ]; then
    echo "🗑️ Removendo volumes Docker..."
    docker-compose down -v
    
    echo -e "${BLUE}🔨 Reconstruindo containers e volumes...${NC}"
    docker-compose build --no-cache
    docker-compose up -d
else
    echo "💾 Preservando volume do banco de dados..."
    
    # Iniciar apenas o banco de dados primeiro
    echo "🚀 Iniciando banco de dados..."
    docker-compose up -d postgres
    sleep 5
    
    # Reconstruir e iniciar outros serviços
    echo -e "${BLUE}🔨 Reconstruindo container web...${NC}"
    docker-compose build --no-cache web
    docker-compose up -d web
fi

# Aguardar inicialização
echo -e "${YELLOW}⏳ Aguardando inicialização dos serviços...${NC}"
sleep 10

# Verificar status
echo -e "${BLUE}📊 Verificando status dos containers...${NC}"
docker-compose ps

# Verificar estado do container web
WEB_RESTARTING=$(docker inspect --format='{{.State.Restarting}}' genius360_web 2>/dev/null || echo "container_not_found")

if [ "$WEB_RESTARTING" = "true" ]; then
    echo -e "${RED}❌ Container web ainda está em loop de reinicialização!${NC}"
    echo -e "${YELLOW}📋 Verifique os logs para identificar o problema:${NC}"
    docker logs genius360_web --tail 30
    echo ""
    echo -e "${YELLOW}🔧 Solução adicional: tente executar 'make deep-fix'${NC}"
    exit 1
elif [ "$WEB_RESTARTING" = "container_not_found" ]; then
    echo -e "${RED}❌ Container web não encontrado após reconstrução!${NC}"
    echo "Verifique o nome do container nos arquivos de configuração."
    exit 1
else
    echo -e "${GREEN}✅ Reconstrução concluída com sucesso!${NC}"
    echo "🚀 Para acessar o container web, use 'make exec'"
fi
