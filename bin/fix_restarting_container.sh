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
