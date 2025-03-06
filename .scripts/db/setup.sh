#!/bin/bash

# Script para configurar o banco de dados PostgreSQL

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Configurando banco de dados PostgreSQL...${NC}"

# Verificar se o container postgres está rodando
if ! docker ps | grep -q "genius360_postgres"; then
    echo -e "${YELLOW}⚠️ Container Postgres não está rodando. Tentando iniciar...${NC}"
    docker start genius360_postgres
    sleep 3
    
    if ! docker ps | grep -q "genius360_postgres"; then
        echo -e "${RED}❌ Não foi possível iniciar o container Postgres. Verifique o docker-compose.${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🔍 Verificando conexão com o banco de dados...${NC}"

# Verificar se já é possível conectar ao banco
if docker exec genius360_postgres psql -U postgres -c '\l' > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Conexão com PostgreSQL estabelecida!${NC}"
else
    echo -e "${YELLOW}⚠️ Aguardando PostgreSQL iniciar completamente...${NC}"
    sleep 5
fi

echo -e "${BLUE}🔧 Criando banco de dados e usuário...${NC}"

# Criar usuário se não existir
docker exec genius360_postgres psql -U postgres -c "SELECT 1 FROM pg_roles WHERE rolname='postgres'" | grep -q 1 || docker exec genius360_postgres psql -U postgres -c "CREATE USER postgres WITH SUPERUSER PASSWORD 'postgres';"

# Criar banco de dados de desenvolvimento
docker exec genius360_postgres psql -U postgres -c "SELECT 1 FROM pg_database WHERE datname='genius360_development'" | grep -q 1 || docker exec genius360_postgres psql -U postgres -c "CREATE DATABASE genius360_development OWNER postgres;"

# Criar banco de dados de teste
docker exec genius360_postgres psql -U postgres -c "SELECT 1 FROM pg_database WHERE datname='genius360_test'" | grep -q 1 || docker exec genius360_postgres psql -U postgres -c "CREATE DATABASE genius360_test OWNER postgres;"

echo -e "${BLUE}🔧 Configurando permissões...${NC}"

# Conceder todos os privilégios nos bancos para o usuário
docker exec genius360_postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE genius360_development TO postgres;"
docker exec genius360_postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE genius360_test TO postgres;"

echo -e "${GREEN}✅ Configuração do banco de dados concluída!${NC}"

# Verificar se o container web está rodando
if docker ps | grep -q "genius360_web"; then
    echo -e "${BLUE}🔧 Atualizando arquivo database.yml no container web...${NC}"
    
    # Verificar se o arquivo database.yml existe e atualizá-lo
    docker exec genius360_web bash -c "if [ -f /app/config/database.yml ]; then \
        sed -i 's/host: .*/host: postgres/' /app/config/database.yml; \
        sed -i 's/username: .*/username: postgres/' /app/config/database.yml; \
        sed -i 's/password: .*/password: postgres/' /app/config/database.yml; \
        echo '✅ Arquivo database.yml atualizado!'; \
    else \
        echo '⚠️ Arquivo database.yml não encontrado. É necessário criá-lo manualmente.'; \
    fi"
    
    # Criar o arquivo database.yml se não existir
    docker exec genius360_web bash -c "if [ ! -f /app/config/database.yml ]; then \
        mkdir -p /app/config; \
        echo 'default: &default' > /app/config/database.yml; \
        echo '  adapter: postgresql' >> /app/config/database.yml; \
        echo '  encoding: unicode' >> /app/config/database.yml; \
        echo '  pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") { 5 } %>' >> /app/config/database.yml; \
        echo '  host: postgres' >> /app/config/database.yml; \
        echo '  username: postgres' >> /app/config/database.yml; \
        echo '  password: postgres' >> /app/config/database.yml; \
        echo '' >> /app/config/database.yml; \
        echo 'development:' >> /app/config/database.yml; \
        echo '  <<: *default' >> /app/config/database.yml; \
        echo '  database: genius360_development' >> /app/config/database.yml; \
        echo '' >> /app/config/database.yml; \
        echo 'test:' >> /app/config/database.yml; \
        echo '  <<: *default' >> /app/config/database.yml; \
        echo '  database: genius360_test' >> /app/config/database.yml; \
        echo '' >> /app/config/database.yml; \
        echo 'production:' >> /app/config/database.yml; \
        echo '  <<: *default' >> /app/config/database.yml; \
        echo '  database: genius360_production' >> /app/config/database.yml; \
        echo '✅ Arquivo database.yml criado!'; \
    fi"
    
    echo -e "${GREEN}✅ Configuração do database.yml concluída!${NC}"
fi

echo -e "${GREEN}✅ Banco de dados configurado com sucesso!${NC}"
