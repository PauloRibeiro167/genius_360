#!/bin/bash

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Encontrar o Dockerfile em locais padrão e não padrão
DOCKERFILE=""

# Verificar locais comuns
if [ -f "./Dockerfile" ]; then
  DOCKERFILE="./Dockerfile"
elif [ -f "./docker/Dockerfile" ]; then
  DOCKERFILE="./docker/Dockerfile"
elif [ -f "./.scripts/docker/Dockerfile" ]; then  # Local específico do projeto
  DOCKERFILE="./.scripts/docker/Dockerfile"
else
  echo -e "${YELLOW}Procurando o Dockerfile em todo o projeto...${NC}"
  
  DOCKERFILE=$(find . -name "Dockerfile" -type f | head -n 1)
  
  if [ -z "$DOCKERFILE" ]; then
    echo -e "${RED}❌ Nenhum Dockerfile encontrado no projeto.${NC}"
    exit 1
  fi
fi

echo -e "${BLUE}🔍 Analisando Dockerfile: ${DOCKERFILE}${NC}"

# Backup do arquivo
cp "${DOCKERFILE}" "${DOCKERFILE}.bak"
echo -e "${GREEN}✅ Backup criado em ${DOCKERFILE}.bak${NC}"

# Detectar versão do Ruby no Gemfile
if [ -f "./Gemfile" ]; then
  GEMFILE_RUBY=$(grep -oP 'ruby ["\047]\K[0-9]+\.[0-9]+(\.[0-9]+)?' "./Gemfile" || echo "")
  
  if [ -n "$GEMFILE_RUBY" ]; then
    echo -e "${BLUE}💎 Versão do Ruby no Gemfile: ${GEMFILE_RUBY}${NC}"
    
    # Verificar e atualizar a versão do Ruby no Dockerfile
    DOCKERFILE_RUBY=$(grep -oP 'FROM ruby:\K[0-9]+\.[0-9]+(\.[0-9]+)?' "${DOCKERFILE}" || echo "")
    
    if [ -n "$DOCKERFILE_RUBY" ] && [ "$DOCKERFILE_RUBY" != "$GEMFILE_RUBY" ]; then
      echo -e "${YELLOW}⚠️ Versão do Ruby no Dockerfile (${DOCKERFILE_RUBY}) diferente do Gemfile (${GEMFILE_RUBY})${NC}"
      echo -e "${BLUE}🔧 Atualizando versão do Ruby no Dockerfile...${NC}"
      
      sed -i "s/FROM ruby:${DOCKERFILE_RUBY}/FROM ruby:${GEMFILE_RUBY}/" "${DOCKERFILE}"
      echo -e "${GREEN}✅ Versão do Ruby atualizada no Dockerfile${NC}"
    fi
  fi
fi

# Adicionar instalação do Bundler se não existir
if ! grep -q "gem install bundler" "${DOCKERFILE}"; then
  echo -e "${YELLOW}⚠️ Instalação do Bundler não encontrada no Dockerfile${NC}"
  echo -e "${BLUE}🔧 Adicionando instalação do Bundler...${NC}"
  
  # Adicionar após a linha FROM
  sed -i "/^FROM ruby/a RUN gem update --system && gem install bundler -v 2.4.22" "${DOCKERFILE}"
  echo -e "${GREEN}✅ Instalação do Bundler adicionada ao Dockerfile${NC}"
fi

# Verificar comando ENTRYPOINT/CMD
if ! grep -q "ENTRYPOINT\|CMD" "${DOCKERFILE}"; then
  echo -e "${YELLOW}⚠️ ENTRYPOINT ou CMD não encontrados no Dockerfile${NC}"
  echo -e "${BLUE}🔧 Adicionando CMD padrão...${NC}"
  
  echo 'CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]' >> "${DOCKERFILE}"
  echo -e "${GREEN}✅ CMD padrão adicionado ao Dockerfile${NC}"
fi

# Otimizar bundle install
if grep -q "bundle install" "${DOCKERFILE}" && ! grep -q "bundle install.*--jobs" "${DOCKERFILE}"; then
  echo -e "${BLUE}🔧 Otimizando comando bundle install...${NC}"
  sed -i 's/bundle install/bundle install --jobs=4 --retry=3/' "${DOCKERFILE}"
  echo -e "${GREEN}✅ Comando bundle install otimizado${NC}"
fi

echo -e "\n${GREEN}✅ Dockerfile atualizado com sucesso!${NC}"
echo -e "${BLUE}📋 Dockerfile Path: ${DOCKERFILE}${NC}"

# Informações adicionais para o docker-compose.yml
if [ -f "docker-compose.yml" ]; then
  DOCKER_COMPOSE_DOCKERFILE=$(grep -oP 'dockerfile:.*\K[^\s]+' docker-compose.yml || echo "")
  
  if [ -n "$DOCKER_COMPOSE_DOCKERFILE" ] && [ "$DOCKER_COMPOSE_DOCKERFILE" != "$DOCKERFILE" ]; then
    echo -e "${YELLOW}⚠️ Atenção: O docker-compose.yml pode estar usando um Dockerfile diferente.${NC}"
    echo -e "${YELLOW}   docker-compose.yml: ${DOCKER_COMPOSE_DOCKERFILE}${NC}"
    echo -e "${YELLOW}   Dockerfile atual: ${DOCKERFILE}${NC}"
  fi
fi

echo -e "${YELLOW}⚠️ Para aplicar as alterações, reconstrua a imagem com:${NC}"
echo -e "${BLUE}   docker-compose build --no-cache web${NC}"
