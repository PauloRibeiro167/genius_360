#!/bin/bash

# Definir cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONTAINER=$1

if [ -z "$CONTAINER" ]; then
    echo -e "${RED}⚠️ Uso: $0 <nome-do-container>${NC}"
    echo -e "${YELLOW}Exemplo: $0 web${NC}"
    exit 1
fi

CONTAINER_FULL="genius360_${CONTAINER}"

echo -e "${BLUE}🔍 Diagnosticando o container ${CONTAINER_FULL}...${NC}"

# Verificar se o container existe
if ! docker ps -a | grep -q "${CONTAINER_FULL}"; then
  echo -e "${RED}❌ Container ${CONTAINER_FULL} não existe!${NC}"
  exit 1
fi

# Verificar status do container
CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' "${CONTAINER_FULL}" 2>/dev/null)
RESTARTING=$(docker inspect --format='{{.State.Restarting}}' "${CONTAINER_FULL}" 2>/dev/null)
RESTART_COUNT=$(docker inspect --format='{{.RestartCount}}' "${CONTAINER_FULL}" 2>/dev/null)
EXIT_CODE=$(docker inspect --format='{{.State.ExitCode}}' "${CONTAINER_FULL}" 2>/dev/null)
HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "${CONTAINER_FULL}" 2>/dev/null || echo "health check not configured")

echo -e "${BLUE}📊 Informações do Container:${NC}"
echo -e "  Status: ${YELLOW}${CONTAINER_STATUS}${NC}"
echo -e "  Reiniciando: ${YELLOW}${RESTARTING}${NC}"
echo -e "  Contagem de Reinicializações: ${YELLOW}${RESTART_COUNT}${NC}"
echo -e "  Código de Saída: ${YELLOW}${EXIT_CODE}${NC}"
echo -e "  Status de Saúde: ${YELLOW}${HEALTH_STATUS}${NC}"

# Verificar logs recentes
echo -e "\n${BLUE}📋 Últimas 50 linhas de logs:${NC}"
docker logs --tail 50 "${CONTAINER_FULL}"

# Verificar detalhes do container
echo -e "\n${BLUE}ℹ️ Informações detalhadas:${NC}"
docker inspect "${CONTAINER_FULL}" | jq -r '.[] | {State: .State, Mounts: .Mounts}'

# Verificar problemas comuns baseados nos logs
echo -e "\n${BLUE}🔍 Analisando logs em busca de problemas conhecidos...${NC}"

if docker logs "${CONTAINER_FULL}" 2>&1 | grep -q "database.*exist"; then
  echo -e "${RED}❌ Problema detectado: Falha na conexão com o banco de dados.${NC}"
  echo -e "${YELLOW}💡 Sugestão: Verifique se o banco de dados está rodando e configurado corretamente.${NC}"
  echo -e "${YELLOW}   Tente executar: make db-setup${NC}"
fi

if docker logs "${CONTAINER_FULL}" 2>&1 | grep -q "Could not find|Gem::LoadError"; then
  echo -e "${RED}❌ Problema detectado: Dependências Ruby não instaladas.${NC}"
  echo -e "${YELLOW}💡 Sugestão: Tente executar bundle install dentro do container.${NC}"
  echo -e "${YELLOW}   Tente executar: make bundle-install${NC}"
fi

if docker logs "${CONTAINER_FULL}" 2>&1 | grep -q "Address already in use"; then
  echo -e "${RED}❌ Problema detectado: Porta já está em uso.${NC}"
  echo -e "${YELLOW}💡 Sugestão: Mate o processo usando a porta ou use uma porta alternativa.${NC}"
  echo -e "${YELLOW}   Tente executar: make start port=3002${NC}"
fi

if docker logs "${CONTAINER_FULL}" 2>&1 | grep -q "Permission denied"; then
  echo -e "${RED}❌ Problema detectado: Problemas de permissão.${NC}"
  echo -e "${YELLOW}💡 Sugestão: Verifique as permissões dos volumes montados.${NC}"
  echo -e "${YELLOW}   Tente executar: sudo chown -R $USER:$USER .${NC}"
fi

# Se for o container web, verificar problemas comuns do Rails
if [ "$CONTAINER" = "web" ]; then
    echo -e "\n${BLUE}🔍 Verificando ambiente Rails...${NC}"
    
    # Verificar se o PID do servidor já existe
    echo -e "${BLUE}🔄 Verificando PIDs do servidor...${NC}"
    docker exec -i "${CONTAINER_FULL}" bash -c "ls -la /app/tmp/pids/ 2>/dev/null || echo 'Diretório de PIDs não encontrado'"
    
    # Verificar problemas com bundler
    echo -e "${BLUE}📦 Verificando bundler...${NC}"
    docker exec -i "${CONTAINER_FULL}" bash -c "cd /app && bundle check" || echo -e "${RED}❌ Problemas com as dependências Ruby detectados${NC}"
    
    # Verificar status do banco de dados
    echo -e "${BLUE}🗄️ Verificando conexão com banco de dados...${NC}"
    docker exec -i "${CONTAINER_FULL}" bash -c "cd /app && rails runner 'begin; puts ActiveRecord::Base.connection.execute(\"SELECT 1\"); rescue => e; puts \"Erro: \#{e.message}\"; end'" || echo -e "${RED}❌ Não foi possível verificar o banco de dados${NC}"
fi

# Sugerir próximos passos
echo -e "\n${BLUE}📝 Próximos passos sugeridos:${NC}"

if [ "${RESTARTING}" = "true" ]; then
  echo -e "${YELLOW}1. Pare e remova o container: docker stop ${CONTAINER_FULL} && docker rm ${CONTAINER_FULL}${NC}"
  echo -e "${YELLOW}2. Recrie o container: docker-compose up -d${NC}"
  echo -e "${YELLOW}3. Se o problema persistir, verifique os logs completos: docker logs ${CONTAINER_FULL}${NC}"
  echo -e "${YELLOW}4. Ou tente nossa ferramenta automática: ./bin/fix_restarting_container.sh ${CONTAINER}${NC}"
else
  echo -e "${YELLOW}1. Verifique os logs completos: docker logs ${CONTAINER_FULL}${NC}"
  echo -e "${YELLOW}2. Entre no container para investigação: docker exec -it ${CONTAINER_FULL} bash${NC}"
  echo -e "${YELLOW}3. Reinicie o container: docker restart ${CONTAINER_FULL}${NC}"
fi

echo -e "\n${GREEN}✅ Diagnóstico concluído!${NC}"
