#!/bin/bash

# Definir cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Iniciando reparo profundo do ambiente Genius360...${NC}"

# Função para criar log de diagnóstico
create_diagnostic_log() {
    echo -e "${BLUE}📊 Criando log de diagnóstico...${NC}"
    
    # Criar diretório para logs se não existir
    mkdir -p logs
    
    LOG_FILE="logs/diagnostic_$(date +%Y%m%d_%H%M%S).log"
    
    {
        echo "=== Diagnóstico Genius360 $(date) ==="
        echo ""
        echo "=== Versão do Docker ==="
        docker --version
        echo ""
        echo "=== Versão do Docker Compose ==="
        docker-compose --version
        echo ""
        echo "=== Status dos Containers ==="
        docker ps -a
        echo ""
        echo "=== Logs do Container Web ==="
        docker logs genius360_web 2>&1 || echo "Container web não disponível"
        echo ""
        echo "=== Logs do Container Postgres ==="
        docker logs genius360_postgres 2>&1 || echo "Container postgres não disponível"
        echo ""
        echo "=== Arquitetura do Projeto ==="
        find . -type f -name "Gemfile" -o -name "Gemfile.lock" -o -name "config.ru" -o -name "database.yml" | sort
        echo ""
        echo "=== Conteúdo do docker-compose.yml ==="
        cat docker-compose.yml 2>/dev/null || echo "Arquivo não encontrado"
        echo ""
        echo "=== Volumes Docker ==="
        docker volume ls | grep genius360
        echo ""
        echo "=== Redes Docker ==="
        docker network ls | grep genius360
        echo ""
        echo "=== Configuração do Banco de Dados ==="
        cat config/database.yml 2>/dev/null || echo "Arquivo não encontrado"
        echo ""
    } > "$LOG_FILE"
    
    echo -e "${GREEN}✅ Log de diagnóstico criado em ${LOG_FILE}${NC}"
    return 0
}

# Parar todos os containers
echo -e "${BLUE}🛑 Parando todos os containers do projeto...${NC}"
docker-compose down || true

# Criar log de diagnóstico antes de prosseguir
create_diagnostic_log

# Remover volumes Docker para começar com ambiente limpo
echo -e "${YELLOW}⚠️ Removendo volumes Docker do projeto para começar limpo...${NC}"
docker volume rm $(docker volume ls -q | grep genius360) 2>/dev/null || echo -e "${YELLOW}⚠️ Não foi possível remover volumes ou nenhum volume encontrado${NC}"

# Remover containers antigos se existirem
echo -e "${YELLOW}⚠️ Removendo containers antigos...${NC}"
docker rm -f genius360_web genius360_postgres 2>/dev/null || echo -e "${YELLOW}⚠️ Não foi possível remover containers ou nenhum container encontrado${NC}"

# Verificar se existem portas em uso que poderiam causar conflitos
echo -e "${BLUE}🔍 Verificando portas em conflito...${NC}"
for port in 3000 3001 5432; do
    if lsof -i :$port >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ Porta $port já está em uso. Tentando liberar...${NC}"
        pid=$(lsof -t -i :$port)
        if [ -n "$pid" ]; then
            echo -e "${YELLOW}⚠️ Tentando matar processo $pid usando a porta $port...${NC}"
            kill -9 $pid 2>/dev/null || echo -e "${RED}❌ Não foi possível matar o processo. Pode precisar de permissões de sudo.${NC}"
        fi
    else
        echo -e "${GREEN}✅ Porta $port está livre${NC}"
    fi
done

# Garantir que o diretório de configuração existe
mkdir -p config

# Criar arquivo database.yml básico
echo -e "${BLUE}🔧 Criando arquivo de configuração do banco de dados mínimo...${NC}"
cat > config/database.yml << EOL
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: postgres
  username: postgres
  password: postgres

development:
  <<: *default
  database: genius360_development

test:
  <<: *default
  database: genius360_test

production:
  <<: *default
  database: genius360_production
EOL

# Limpar arquivos temporários que podem causar problemas
echo -e "${BLUE}🧹 Limpando arquivos temporários...${NC}"
rm -rf tmp/pids/* tmp/cache/* log/*.log 2>/dev/null || mkdir -p tmp/pids tmp/cache log

# Ajustar permissões
echo -e "${BLUE}🔧 Ajustando permissões...${NC}"
chmod -R 755 . 2>/dev/null || echo -e "${YELLOW}⚠️ Não foi possível ajustar todas as permissões${NC}"

# Reconstruir e iniciar os containers
echo -e "${BLUE}🏗️ Reconstruindo containers...${NC}"
docker-compose build --no-cache

echo -e "${BLUE}🚀 Iniciando serviços...${NC}"
docker-compose up -d

# Esperar inicialização
echo -e "${BLUE}⏳ Aguardando inicialização dos serviços...${NC}"
sleep 15

# Verificar se o banco de dados está acessível e criar se necessário
echo -e "${BLUE}🗄️ Configurando banco de dados...${NC}"
if docker ps | grep -q genius360_postgres; then
    echo -e "${BLUE}🔧 PostgreSQL está rodando. Configurando bancos de dados...${NC}"
    
    # Esperar o PostgreSQL inicializar completamente
    sleep 5
    
    # Criar usuário e bancos de dados
    docker exec -i genius360_postgres psql -U postgres << EOL
CREATE USER postgres WITH SUPERUSER PASSWORD 'postgres';
CREATE DATABASE genius360_development OWNER postgres;
CREATE DATABASE genius360_test OWNER postgres;
GRANT ALL PRIVILEGES ON DATABASE genius360_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE genius360_test TO postgres;
EOL
    
    echo -e "${GREEN}✅ Banco de dados configurado${NC}"
else
    echo -e "${RED}❌ Container PostgreSQL não está rodando${NC}"
fi

# Verificar status final
echo -e "${BLUE}🔍 Verificando status final...${NC}"
docker ps -a | grep genius360

# Verificar logs para diagnóstico
echo -e "${BLUE}📋 Verificando logs do container web...${NC}"
docker logs genius360_web 2>&1 | tail -n 20 || echo -e "${RED}❌ Não foi possível acessar logs do container web${NC}"

# Tentar resolver problemas de dependências se o container estiver rodando
if docker ps | grep -q genius360_web; then
    echo -e "${BLUE}📦 Instalando dependências no container web...${NC}"
    docker exec -i genius360_web bash -c "
        cd /app
        bundle install || gem install bundler && bundle install
        if [ -f bin/setup ]; then 
            bin/setup || echo 'Falha ao executar bin/setup'
        else 
            bundle exec rake db:create db:migrate || echo 'Falha ao configurar banco de dados'
        fi
    " || echo -e "${RED}❌ Falha ao instalar dependências${NC}"
fi

# Verificar se o container ainda está reiniciando
if docker inspect --format='{{.State.Restarting}}' genius360_web 2>/dev/null | grep -q "true"; then
    echo -e "${RED}❌ O container web ainda está em loop de reinicialização${NC}"
    echo -e "${YELLOW}⚠️ Verifique os logs completos para identificar o problema: docker logs genius360_web${NC}"
    echo -e "${YELLOW}⚠️ Você pode precisar ajustar o Dockerfile ou docker-compose.yml para resolver o problema${NC}"
else
    echo -e "${GREEN}✅ O container web parece estar estável agora!${NC}"
    echo -e "${GREEN}✅ Tente 'docker exec -it genius360_web bash' para acessar o container${NC}"
fi

echo -e "${GREEN}✅ Processo de reparo profundo concluído!${NC}"
