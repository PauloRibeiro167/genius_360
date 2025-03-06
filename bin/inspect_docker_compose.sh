#!/bin/bash

# Definir cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOCKER_COMPOSE_FILE="${1:-docker-compose.yml}"

echo -e "${BLUE}🔍 Analisando arquivo ${DOCKER_COMPOSE_FILE}...${NC}"

# Verificar se o arquivo existe
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
    echo -e "${RED}❌ Arquivo $DOCKER_COMPOSE_FILE não encontrado!${NC}"
    exit 1
fi

# Verificar se há erros de sintaxe no arquivo
echo -e "${BLUE}🔍 Verificando sintaxe...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" config >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro de sintaxe encontrado no arquivo!${NC}"
    docker-compose -f "$DOCKER_COMPOSE_FILE" config
    exit 1
else
    echo -e "${GREEN}✅ Sintaxe do arquivo parece correta${NC}"
fi

# Analisar warnings sobre versão obsoleta
echo -e "${BLUE}🔍 Verificando uso de versão...${NC}"
if grep -q "version:" "$DOCKER_COMPOSE_FILE"; then
    echo -e "${YELLOW}⚠️ Atributo 'version' está obsoleto no Docker Compose V2+${NC}"
    echo -e "${YELLOW}⚠️ Considere remover a linha de versão do arquivo${NC}"
    
    # Sugerir correção
    echo -e "${BLUE}💡 Deseja remover o atributo 'version' automaticamente? (s/n)${NC}"
    read -r response
    if [[ "$response" =~ ^([sS]|[sS][iI][mM])$ ]]; then
        # Fazer backup do arquivo
        cp "$DOCKER_COMPOSE_FILE" "${DOCKER_COMPOSE_FILE}.bak"
        echo -e "${GREEN}✅ Backup criado em ${DOCKER_COMPOSE_FILE}.bak${NC}"
        
        # Remover a linha de versão
        sed -i '/version:/d' "$DOCKER_COMPOSE_FILE"
        echo -e "${GREEN}✅ Atributo 'version' removido com sucesso${NC}"
    fi
else
    echo -e "${GREEN}✅ O arquivo não contém o atributo 'version' obsoleto${NC}"
fi

# Verificar serviços definidos
echo -e "${BLUE}🔍 Analisando serviços definidos...${NC}"
docker-compose -f "$DOCKER_COMPOSE_FILE" config --services | while read -r service; do
    echo -e "${BLUE}📦 Serviço encontrado: ${service}${NC}"
    
    # Verificar imagem ou build para o serviço
    if docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -q "image:"; then
        image=$(docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep "image:" | head -1 | awk '{print $2}')
        echo -e "  ${GREEN}✅ Usa imagem: ${image}${NC}"
    elif docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -q "build:"; then
        echo -e "  ${GREEN}✅ Usa build personalizado${NC}"
        
        # Verificar se o Dockerfile existe caso use build
        build_context=$(docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -A 5 "build:" | grep "context:" | head -1 | awk '{print $2}')
        dockerfile=$(docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -A 5 "build:" | grep "dockerfile:" | head -1 | awk '{print $2}')
        
        if [ -z "$build_context" ]; then
            build_context="."
        fi
        
        if [ -z "$dockerfile" ]; then
            dockerfile="Dockerfile"
        fi
        
        dockerfile_path="${build_context}/${dockerfile}"
        
        if [ -f "$dockerfile_path" ]; then
            echo -e "  ${GREEN}✅ Dockerfile encontrado em ${dockerfile_path}${NC}"
        else
            echo -e "  ${RED}❌ Dockerfile não encontrado em ${dockerfile_path}${NC}"
        fi
    else
        echo -e "  ${RED}❌ Nem imagem nem build definidos${NC}"
    fi
    
    # Verificar portas expostas
    if docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -q "ports:"; then
        ports=$(docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -A 5 "ports:" | grep -v "ports:")
        echo -e "  ${BLUE}🔌 Portas expostas: ${ports}${NC}"
    else
        echo -e "  ${YELLOW}⚠️ Nenhuma porta exposta${NC}"
    fi
    
    # Verificar volumes
    if docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 30 "^  ${service}:" | grep -q "volumes:"; then
        echo -e "  ${BLUE}💾 Volumes configurados${NC}"
    else
        echo -e "  ${YELLOW}⚠️ Nenhum volume configurado${NC}"
    fi
    
    # Verificar dependências
    if docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -q "depends_on:"; then
        depends=$(docker-compose -f "$DOCKER_COMPOSE_FILE" config | grep -A 20 "^  ${service}:" | grep -A 5 "depends_on:" | grep -v "depends_on:")
        echo -e "  ${BLUE}🔗 Dependências: ${depends}${NC}"
    fi
    
    echo ""
done

echo -e "${GREEN}✅ Análise do arquivo Docker Compose concluída!${NC}"
