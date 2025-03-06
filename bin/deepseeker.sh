#!/bin/bash

# DeepSeeker - Monitor de Auto-Recuperação para Genius360
# =======================================================

# Definir cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 DeepSeeker - Ferramenta de diagnóstico e reparo para Genius360${NC}"

# Verificando o Dockerfile
if [ -f "./Dockerfile" ]; then
  DOCKERFILE="./Dockerfile"
elif [ -f "./docker/Dockerfile" ]; then
  DOCKERFILE="./docker/Dockerfile"
else
  echo -e "${RED}❌ Dockerfile não encontrado!${NC}"
  echo -e "${YELLOW}Procurando em diretórios alternativos...${NC}"
  
  DOCKERFILE=$(find . -name "Dockerfile" -type f | head -n 1)
  
  if [ -z "$DOCKERFILE" ]; then
    echo -e "${RED}❌ Nenhum Dockerfile encontrado no projeto.${NC}"
    echo -e "${YELLOW}Você precisa ter um Dockerfile válido para continuar.${NC}"
    exit 1
  else
    echo -e "${GREEN}✅ Dockerfile encontrado em: $DOCKERFILE${NC}"
  fi
fi

# Verificando o status do container web
echo -e "${BLUE}🔍 Verificando status do container web...${NC}"
WEB_STATUS=$(docker ps -a | grep genius360_web || echo "não encontrado")

if echo "$WEB_STATUS" | grep -q "Restarting"; then
  echo -e "${RED}❌ Container web está em loop de reinicialização.${NC}"
  
  # Parar container para investigação
  echo -e "${YELLOW}⏹️ Parando container web para diagnóstico...${NC}"
  docker stop genius360_web >/dev/null 2>&1 || true
  
  # Tentar reparar o container
  echo -e "${YELLOW}🔧 Tentando reparar ambiente...${NC}"
  
  # Preparando para solução com gem deepseek-rails
  echo -e "${BLUE}📦 Preparando solução com deepseek-rails...${NC}"
  
  # Verificar se já existe Gemfile.rails
  if [ ! -f "./Gemfile.rails" ] && [ -f "./Gemfile" ]; then
    echo -e "${YELLOW}📝 Criando Gemfile temporário para diagnóstico...${NC}"
    cp ./Gemfile ./Gemfile.rails
    echo "gem 'deepseek-rails', '~> 0.3.0'" >> ./Gemfile.rails
  fi
  
  # Modificar Dockerfile temporariamente
  if [ -f "$DOCKERFILE" ]; then
    echo -e "${YELLOW}📝 Criando Dockerfile temporário para diagnóstico...${NC}"
    cp "$DOCKERFILE" "${DOCKERFILE}.bak"
    
    # Extrair a versão do Ruby do Dockerfile
    RUBY_VERSION=$(grep -oP 'FROM ruby:\K[0-9]+\.[0-9]+(\.[0-9]+)?' "$DOCKERFILE" || echo "3.2.2")
    echo -e "${BLUE}💎 Versão do Ruby detectada: ${RUBY_VERSION}${NC}"
    
    # Criar Dockerfile temporário para diagnóstico
    cat > ./Dockerfile.deepseeker << EOF
FROM ruby:${RUBY_VERSION}
WORKDIR /app
COPY Gemfile.rails /app/Gemfile
RUN gem update --system && gem install bundler -v 2.4.22
RUN bundle install
COPY . /app
CMD ["bundle", "exec", "rails", "deepseeker:diagnose"]
EOF
  fi
  
  # Construir imagem de diagnóstico
  echo -e "${BLUE}🔨 Construindo imagem de diagnóstico...${NC}"
  docker build -t genius360-deepseeker -f Dockerfile.deepseeker .
  
  # Executar diagnóstico
  echo -e "${BLUE}🔍 Executando diagnóstico com deepseek-rails...${NC}"
  docker run --rm -v "$(pwd):/app" genius360-deepseeker bundle exec rails deepseeker:diagnose || {
    echo -e "${RED}❌ Falha ao executar diagnóstico.${NC}"
    echo -e "${YELLOW}🔄 Tentando abordagem alternativa...${NC}"
    
    # Script para recuperação básica
    echo -e "${YELLOW}🔧 Executando recuperação básica...${NC}"
    docker-compose down
    docker-compose build --no-cache web
    docker-compose up -d
    
    echo -e "${GREEN}✅ Ambiente reconstruído. Verifique o status com 'docker-compose ps'.${NC}"
    exit 0
  }
else
  echo -e "${GREEN}✅ Container web não está em loop de reinicialização.${NC}"
  
  if echo "$WEB_STATUS" | grep -q "Up"; then
    echo -e "${GREEN}✅ Container web está funcionando normalmente.${NC}"
  else
    echo -e "${YELLOW}⚠️ Container web não está em execução.${NC}"
    echo -e "${BLUE}🔄 Iniciando serviços...${NC}"
    docker-compose up -d
  fi
fi

echo -e "${GREEN}✅ Processo concluído!${NC}"
exit 0
