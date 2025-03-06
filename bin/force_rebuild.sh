#!/bin/bash

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚨 Iniciando reconstrução forçada do ambiente...${NC}"

# Verificar Docker Compose
if [ ! -f "docker-compose.yml" ]; then
  echo -e "${RED}❌ Arquivo docker-compose.yml não encontrado!${NC}"
  exit 1
fi

# Parar e remover containers
echo -e "${YELLOW}⏹️ Parando e removendo containers...${NC}"
docker-compose down

# Localizar o Dockerfile
DOCKERFILE=""
if [ -f "./Dockerfile" ]; then
  DOCKERFILE="./Dockerfile"
elif [ -f "./docker/Dockerfile" ]; then
  DOCKERFILE="./docker/Dockerfile"
elif [ -f "./.scripts/docker/Dockerfile" ]; then
  DOCKERFILE="./.scripts/docker/Dockerfile"
else
  DOCKERFILE=$(find . -name "Dockerfile" -type f | head -n 1)
  
  if [ -z "$DOCKERFILE" ]; then
    echo -e "${RED}❌ Dockerfile não encontrado!${NC}"
    exit 1
  fi
fi

echo -e "${BLUE}📋 Usando Dockerfile: ${DOCKERFILE}${NC}"

# Análise do docker-compose.yml
echo -e "${BLUE}🔍 Analisando docker-compose.yml...${NC}"
WEB_SERVICE=$(grep -A 20 "web:" docker-compose.yml)

if [ -z "$WEB_SERVICE" ]; then
  echo -e "${RED}❌ Serviço 'web' não encontrado no docker-compose.yml!${NC}"
  exit 1
fi

# Verificar volume do bundle para evitar reinstalações constantes
if ! echo "$WEB_SERVICE" | grep -q "- bundle:/usr/local/bundle"; then
  echo -e "${YELLOW}⚠️ Volume para bundle não encontrado. Recomendado para melhor performance.${NC}"
fi

# Forçar reconstrução do container web
echo -e "${BLUE}🔨 Reconstruindo o container web...${NC}"
docker-compose build --no-cache web

# Iniciar ambiente
echo -e "${GREEN}🚀 Iniciando ambiente...${NC}"
docker-compose up -d

echo -e "${YELLOW}⏳ Aguardando inicialização (30s)...${NC}"
sleep 30

# Verificar status do container web
WEB_STATUS=$(docker ps | grep genius360_web || echo "não encontrado")

if echo "$WEB_STATUS" | grep -q "Restarting"; then
  echo -e "${RED}❌ Container web ainda está em loop de reinicialização.${NC}"
  echo -e "${YELLOW}📋 Verificando logs do container:${NC}"
  docker logs --tail 50 genius360_web
  
  echo -e "\n${YELLOW}🔧 Tentando solução alternativa...${NC}"
  
  # Parando container web para evitar loop
  docker stop genius360_web
  
  # Criar um container temporário que apenas instala as dependências
  echo -e "${BLUE}📦 Criando container temporário para instalar dependências...${NC}"
  
  docker run --rm -v "$(pwd):/app" -w /app ruby:3.2.2 bash -c "
    gem update --system && 
    gem install bundler -v 2.4.22 && 
    bundle config set --local path 'vendor/bundle' && 
    bundle install --jobs=4
  "
  
  # Iniciar novamente
  echo -e "${GREEN}🚀 Reiniciando container com dependências atualizadas...${NC}"
  docker-compose up -d
  
  sleep 20
  
  if docker ps | grep -q "genius360_web.*Restarting"; then
    echo -e "${RED}❌ O container ainda está com problemas. Situação de erro persistente.${NC}"
    echo -e "${YELLOW}💡 Sugestões:${NC}"
    echo -e "  1. Verifique o Dockerfile e ajuste a versão do Ruby para corresponder ao Gemfile."
    echo -e "  2. Verifique se há gems incompatíveis com a versão do Ruby."
    echo -e "  3. Execute 'docker logs genius360_web' para mais detalhes sobre o erro."
  else
    echo -e "${GREEN}✅ Container web iniciado com sucesso!${NC}"
  fi
else
  echo -e "${GREEN}✅ Container web iniciado com sucesso!${NC}"
fi

echo -e "${BLUE}📊 Status atual dos containers:${NC}"
docker-compose ps
