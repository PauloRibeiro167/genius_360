#!/bin/bash

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Encontrar o Dockerfile
if [ -f "./Dockerfile" ]; then
  DOCKERFILE="./Dockerfile"
elif [ -f "./docker/Dockerfile" ]; then
  DOCKERFILE="./docker/Dockerfile"
else
  echo -e "${RED}❌ Dockerfile não encontrado!${NC}"
  exit 1
fi

echo -e "${BLUE}🔍 Inspecionando Dockerfile: ${DOCKERFILE}${NC}\n"

# Validar sintaxe do Dockerfile
echo -e "${BLUE}🧪 Verificando sintaxe...${NC}"
if ! docker run --rm -i hadolint/hadolint < "$DOCKERFILE" 2>/dev/null; then
  echo -e "${YELLOW}⚠️ Aviso: Possíveis problemas de sintaxe encontrados no Dockerfile${NC}"
else
  echo -e "${GREEN}✅ Sintaxe do Dockerfile válida${NC}"
fi

# Extrair e verificar a imagem base
BASE_IMAGE=$(grep -m 1 "^FROM" "$DOCKERFILE" | sed 's/FROM //')
echo -e "\n${BLUE}📦 Imagem base:${NC} $BASE_IMAGE"

# Verificar versão do Ruby
RUBY_VERSION=$(echo "$BASE_IMAGE" | grep -oP 'ruby:\K[0-9]+\.[0-9]+(\.[0-9]+)?')
if [ -n "$RUBY_VERSION" ]; then
  echo -e "${BLUE}💎 Versão do Ruby:${NC} $RUBY_VERSION"
  
  # Comparar com o Gemfile
  if [ -f "./Gemfile" ]; then
    GEMFILE_RUBY=$(grep -oP 'ruby ["\047]\K[0-9]+\.[0-9]+(\.[0-9]+)?' "./Gemfile" || echo "não especificado")
    echo -e "${BLUE}📄 Versão do Ruby no Gemfile:${NC} $GEMFILE_RUBY"
    
    if [ "$GEMFILE_RUBY" != "não especificado" ] && [ "$RUBY_VERSION" != "$GEMFILE_RUBY" ]; then
      echo -e "${RED}❌ PROBLEMA: Incompatibilidade na versão do Ruby!${NC}"
      echo -e "${YELLOW}   Dockerfile: ${RUBY_VERSION} | Gemfile: ${GEMFILE_RUBY}${NC}"
      echo -e "${YELLOW}   Sugestão: Atualize o Dockerfile para usar ruby:${GEMFILE_RUBY}${NC}"
    elif [ "$GEMFILE_RUBY" != "não especificado" ]; then
      echo -e "${GREEN}✅ Versões do Ruby compatíveis${NC}"
    fi
  fi
fi

# Verificar instalação de dependências do sistema
echo -e "\n${BLUE}🔧 Analisando instalação de dependências...${NC}"
if grep -q "apt-get install" "$DOCKERFILE"; then
  APT_UPDATE=$(grep -q "apt-get update" "$DOCKERFILE" && echo "sim" || echo "não")
  APT_CLEANUP=$(grep -q "apt-get clean\|rm -rf /var/lib/apt" "$DOCKERFILE" && echo "sim" || echo "não")
  
  if [ "$APT_UPDATE" = "não" ]; then
    echo -e "${YELLOW}⚠️ apt-get update não encontrado antes de instalar pacotes${NC}"
  fi
  
  if [ "$APT_CLEANUP" = "não" ]; then
    echo -e "${YELLOW}⚠️ Limpeza do cache apt não encontrada${NC}"
  fi
fi

# Verificar instalação do Bundler
BUNDLER_INSTALL=$(grep -q "gem install bundler" "$DOCKERFILE" && echo "sim" || echo "não")
if [ "$BUNDLER_INSTALL" = "não" ]; then
  echo -e "${YELLOW}⚠️ Instalação explícita do Bundler não encontrada${NC}"
fi

# Verificar comando de cópia de Gemfile e instalação de gems
COPY_GEMFILE=$(grep -q "COPY.*Gemfile" "$DOCKERFILE" && echo "sim" || echo "não")
BUNDLE_INSTALL=$(grep -q "bundle install" "$DOCKERFILE" && echo "sim" || echo "não")

if [ "$COPY_GEMFILE" = "sim" ] && [ "$BUNDLE_INSTALL" = "sim" ]; then
  echo -e "${GREEN}✅ Gemfile copiado e bundle install presente${NC}"
else
  echo -e "${RED}❌ PROBLEMA: Configuração incompleta para gems!${NC}"
  [ "$COPY_GEMFILE" = "não" ] && echo -e "${YELLOW}   - Cópia do Gemfile não encontrada${NC}"
  [ "$BUNDLE_INSTALL" = "não" ] && echo -e "${YELLOW}   - bundle install não encontrado${NC}"
fi

# Verificar uso de multi-stage ou copy-all
MULTI_STAGE=$(grep -q "FROM.*AS" "$DOCKERFILE" && echo "sim" || echo "não")
COPY_ALL=$(grep -q "COPY \." "$DOCKERFILE" && echo "sim" || echo "não")

if [ "$MULTI_STAGE" = "sim" ]; then
  echo -e "${GREEN}✅ Build multi-stage detectado${NC}"
elif [ "$COPY_ALL" = "sim" ]; then
  echo -e "${YELLOW}⚠️ Cópia de todos os arquivos detectada. Considere otimizar.${NC}"
fi

# Verificar usuário não-root
USER_DEFINED=$(grep -q "^USER" "$DOCKERFILE" && echo "sim" || echo "não")
if [ "$USER_DEFINED" = "não" ]; then
  echo -e "${YELLOW}⚠️ Usuário não-root não definido${NC}"
else
  USER=$(grep "^USER" "$DOCKERFILE" | tail -1 | awk '{print $2}')
  echo -e "${GREEN}✅ Container configurado para executar como usuário: ${USER}${NC}"
fi

echo -e "\n${BLUE}📝 Recomendações:${NC}"
if [ "$RUBY_VERSION" != "$GEMFILE_RUBY" ] && [ -n "$GEMFILE_RUBY" ] && [ "$GEMFILE_RUBY" != "não especificado" ]; then
  echo -e "1. ${YELLOW}Atualize a versão do Ruby para ${GEMFILE_RUBY} no Dockerfile${NC}"
  echo -e "   Exemplo: FROM ruby:${GEMFILE_RUBY}"
fi

echo -e "2. ${YELLOW}Certifique-se de instalar uma versão específica do Bundler:${NC}"
echo -e "   RUN gem install bundler -v '~> 2.6.0'"

echo -e "3. ${YELLOW}Certifique-se de usar flags de otimização no bundle install:${NC}"
echo -e "   RUN bundle install --jobs=4 --without=development:test"

echo -e "4. ${YELLOW}Após resolver os problemas, reconstrua a imagem:${NC}"
echo -e "   docker-compose build --no-cache web"
