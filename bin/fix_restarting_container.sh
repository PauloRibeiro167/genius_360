#!/bin/bash

# Definir cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONTAINER="${1:-web}"
CONTAINER_FULL="genius360_${CONTAINER}"

echo -e "${BLUE}🔧 Tentando corrigir o container ${CONTAINER_FULL} em loop de reinicialização...${NC}"

# Verificar se o container existe
if ! docker ps -a | grep -q "${CONTAINER_FULL}"; then
  echo -e "${RED}❌ Container ${CONTAINER_FULL} não existe!${NC}"
  exit 1
fi

# Parar composição Docker
echo -e "${BLUE}🛑 Parando todos os serviços...${NC}"
docker-compose down

# Verificar e corrigir problemas de volumes
echo -e "${BLUE}🔍 Verificando volumes...${NC}"
if [ -d "tmp/pids" ]; then
  echo -e "${YELLOW}⚠️ Removendo arquivos de PID antigos...${NC}"
  rm -f tmp/pids/server.pid tmp/pids/*.pid
fi

# Verificar permissões nos diretórios críticos
echo -e "${BLUE}🔍 Verificando permissões de diretórios...${NC}"
for dir in "tmp" "log" "db" "config"; do
  if [ -d "$dir" ]; then
    echo -e "${YELLOW}⚠️ Ajustando permissões para $dir...${NC}"
    chmod -R 755 "$dir"
  fi
done

# Corrigir arquivo de configuração do banco de dados
if [ -f "config/database.yml" ]; then
  echo -e "${BLUE}🔧 Verificando configuração do banco de dados...${NC}"
  if ! grep -q "host: postgres" "config/database.yml"; then
    echo -e "${YELLOW}⚠️ Atualizando host do banco de dados para 'postgres'...${NC}"
    sed -i 's/host: .*/host: postgres/' config/database.yml
  fi
fi

# Recriar os containers com build forçado
echo -e "${BLUE}🔄 Recriando containers com build forçado...${NC}"
docker-compose build --no-cache
docker-compose up -d

# Aguardar inicialização
echo -e "${BLUE}⏳ Aguardando inicialização dos serviços...${NC}"
sleep 10

# Verificar status dos containers
echo -e "${BLUE}🔍 Verificando status dos containers...${NC}"
CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' "${CONTAINER_FULL}" 2>/dev/null)
RESTARTING=$(docker inspect --format='{{.State.Restarting}}' "${CONTAINER_FULL}" 2>/dev/null)

if [ "${RESTARTING}" = "true" ]; then
  echo -e "${RED}❌ Container ${CONTAINER_FULL} ainda está em loop de reinicialização.${NC}"
  
  # Solução mais drástica: remover todos os volumes e recriar
  echo -e "${YELLOW}⚠️ Aplicando solução mais drástica: removendo volumes...${NC}"
  docker-compose down -v
  
  echo -e "${BLUE}🔧 Recriando ambiente do zero...${NC}"
  docker-compose up -d --build
  
  sleep 15
  
  # Verificar status novamente
  RESTARTING=$(docker inspect --format='{{.State.Restarting}}' "${CONTAINER_FULL}" 2>/dev/null)
  
  if [ "${RESTARTING}" = "true" ]; then
    echo -e "${RED}❌ Falha na recuperação automática do container.${NC}"
    echo -e "${RED}   Consulte os logs para mais detalhes: docker logs ${CONTAINER_FULL}${NC}"
    exit 1
  else
    echo -e "${GREEN}✅ Container ${CONTAINER_FULL} agora está ${CONTAINER_STATUS}!${NC}"
  fi
else
  echo -e "${GREEN}✅ Container ${CONTAINER_FULL} agora está ${CONTAINER_STATUS}!${NC}"
fi

# Configurar banco de dados se o container web estiver rodando
if [ "${CONTAINER}" = "web" ] && [ "${CONTAINER_STATUS}" = "running" ]; then
  echo -e "${BLUE}🗄️ Configurando banco de dados...${NC}"
  docker-compose exec -T web bash -c "
    rm -f /app/tmp/pids/server.pid
    if [ -f /app/bin/setup ]; then
      /app/bin/setup
    else
      bundle install
      bundle exec rails db:create db:migrate
    fi
  " || echo -e "${YELLOW}⚠️ Não foi possível configurar o banco de dados automaticamente.${NC}"
fi

echo -e "${GREEN}✅ Processo de correção concluído!${NC}"
echo -e "${BLUE}💡 Tente executar 'make exec' novamente para acessar o container.${NC}"
echo -e "${BLUE}   Se o problema persistir, execute './bin/diagnose_container.sh' para diagnóstico detalhado.${NC}"

#!/bin/bash

# Script para corrigir container em loop de reinicialização
# Uso: fix_restarting_container.sh [nome_container]

# Definição de variáveis
CONTAINER=${1:-"genius360_web"}
DOCKER_COMPOSE="docker-compose"
LOG_FILE="./logs/fix_container_$(date +%Y%m%d_%H%M%S).log"

# Criar diretório de logs se não existir
mkdir -p ./logs

# Funções de exibição
print_header() {
    echo "=============================================="
    echo "🔧 Correção de Container em Reinicialização 🔧"
    echo "=============================================="
    echo "📦 Container: $CONTAINER"
    echo "📅 Data: $(date)"
    echo "📝 Log: $LOG_FILE"
    echo "=============================================="
}

log_cmd() {
    echo -e "\n> Executando: $@" | tee -a "$LOG_FILE"
    "$@" 2>&1 | tee -a "$LOG_FILE"
    return ${PIPESTATUS[0]}
}

print_section() {
    echo -e "\n🔄 $1" | tee -a "$LOG_FILE"
    echo "----------------------------------------------" | tee -a "$LOG_FILE"
}

print_header | tee -a "$LOG_FILE"

# Verifica se o container existe
if ! docker ps -a | grep -q "$CONTAINER"; then
    echo "❌ Container $CONTAINER não encontrado!" | tee -a "$LOG_FILE"
    echo "Containers disponíveis:" | tee -a "$LOG_FILE"
    docker ps -a | tee -a "$LOG_FILE"
    exit 1
fi

# Parar todos os serviços
print_section "🛑 Parando todos os serviços..."
log_cmd $DOCKER_COMPOSE down

# Verificar volumes
print_section "🔍 Verificando volumes..."
log_cmd docker volume ls | grep genius360

# Remover arquivos de PID
print_section "⚠️ Removendo arquivos de PID antigos..."
if [ -f "./tmp/pids/server.pid" ]; then
    log_cmd rm -f ./tmp/pids/server.pid
fi

# Verificar permissões
print_section "🔍 Verificando permissões de diretórios..."

# Corrigir permissões de diretórios essenciais
print_section "⚠️ Ajustando permissões para tmp..."
if [ -d "./tmp" ]; then
    log_cmd chmod -R 777 ./tmp
fi

print_section "⚠️ Ajustando permissões para log..."
if [ -d "./log" ]; then
    log_cmd chmod -R 777 ./log
fi

print_section "⚠️ Ajustando permissões para db..."
if [ -d "./db" ]; then
    log_cmd chmod -R 777 ./db
fi

print_section "⚠️ Ajustando permissões para config..."
if [ -d "./config" ]; then
    log_cmd chmod -R 777 ./config
fi

# Verificar configuração de banco de dados
print_section "🔧 Verificando configuração do banco de dados..."
if [ -f "config/database.yml" ]; then
    grep -v "password" config/database.yml | tee -a "$LOG_FILE"
fi

# Desabilitar miniprofiler que pode estar causando o problema
print_section "🔧 Desabilitando temporariamente o miniprofiler..."
if [ -x "./bin/disable_miniprofiler.sh" ]; then
    log_cmd ./bin/disable_miniprofiler.sh
else
    echo "Script disable_miniprofiler.sh não encontrado ou não executável" | tee -a "$LOG_FILE"
    log_cmd chmod +x ./bin/disable_miniprofiler.sh 2>/dev/null || echo "Não foi possível tornar o script executável" | tee -a "$LOG_FILE"
    log_cmd ./bin/disable_miniprofiler.sh 2>/dev/null || echo "Não foi possível executar o script" | tee -a "$LOG_FILE"
fi

# Corrigir permissões completas
print_section "🔧 Ajustando permissões de forma abrangente..."
if [ -x "./bin/fix_permissions.sh" ]; then
    log_cmd ./bin/fix_permissions.sh
else
    echo "Script fix_permissions.sh não encontrado ou não executável" | tee -a "$LOG_FILE"
    log_cmd chmod +x ./bin/fix_permissions.sh 2>/dev/null || echo "Não foi possível tornar o script executável" | tee -a "$LOG_FILE"
    log_cmd ./bin/fix_permissions.sh 2>/dev/null || echo "Não foi possível executar o script" | tee -a "$LOG_FILE"
fi

# Recriar containers
print_section "🔄 Recriando containers com build forçado..."
log_cmd $DOCKER_COMPOSE up -d

# Verificar status após recriação
print_section "⏳ Aguardando inicialização dos serviços..."
sleep 10

print_section "🔍 Verificando status dos containers..."
log_cmd $DOCKER_COMPOSE ps

# Verificar se ainda está reiniciando
is_restarting=$(docker inspect --format='{{.State.Restarting}}' "$CONTAINER" 2>/dev/null || echo "false")
if [ "$is_restarting" = "true" ]; then
    print_section "❌ Container $CONTAINER ainda está em loop de reinicialização."
    print_section "⚠️ Aplicando solução mais drástica: removendo volumes..."
    
    # Solução mais drástica: remover volumes e recriar
    log_cmd $DOCKER_COMPOSE down -v
    
    print_section "🔧 Recriando ambiente do zero..."
    log_cmd $DOCKER_COMPOSE up -d
    
    # Verificar status novamente
    sleep 15
    is_restarting_again=$(docker inspect --format='{{.State.Restarting}}' "$CONTAINER" 2>/dev/null || echo "false")
    
    if [ "$is_restarting_again" = "true" ]; then
        print_section "❌ Container ainda está em loop após solução drástica!"
        print_section "📋 Recomendações finais:"
        echo "1. Execute 'make force-rebuild' para uma reconstrução completa." | tee -a "$LOG_FILE"
        echo "2. Se o problema persistir, verifique o Dockerfile e docker-compose.yml." | tee -a "$LOG_FILE"
        echo "3. Confira os logs para identificar o erro específico: 'docker logs $CONTAINER'" | tee -a "$LOG_FILE"
        
        # Exibir as últimas linhas do log
        print_section "📜 Últimas linhas de log do container:"
        log_cmd docker logs --tail 20 "$CONTAINER"
        
        exit 1
    else
        print_section "✅ Container iniciado com sucesso após remoção de volumes!"
        exit 0
    fi
else
    print_section "✅ Container iniciado com sucesso!"
    exit 0
fi
