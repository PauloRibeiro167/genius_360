#!/bin/bash

echo "🔧 Corrigindo problemas do Makefile..."

# Backup do arquivo original
if [ -f "Makefile" ]; then
  echo "📁 Criando backup do Makefile atual..."
  cp Makefile Makefile.bak.$(date +%s)
fi

# Criação de um novo Makefile correto
cat > Makefile << 'EOL'
# Makefile para o projeto Genius360
.PHONY: all up down ps fix-server start exec shell logs rails-console db-console db-migrate db-reset

all:
	@echo "Comandos disponíveis:"
	@echo "  make up           - Inicia os serviços em background"
	@echo "  make down         - Para todos os containers"
	@echo "  make ps           - Lista os containers em execução"
	@echo "  make fix-server   - Corrige problema 'server already running'"
	@echo "  make start        - Inicia todos os serviços e abre shell no container"
	@echo "  make exec         - Inicia os containers e abre o console web"
	@echo "  make shell        - Abre o terminal no container web"
	@echo "  make logs         - Exibe os logs dos containers"
	@echo "  make rails-console- Abre o console Rails"
	@echo "  make db-console   - Abre o console PostgreSQL"
	@echo "  make db-migrate   - Executa migrações do banco de dados"
	@echo "  make db-reset     - Recria o banco de dados"

up:
	@echo "🚀 Iniciando serviços..."
	@docker-compose up -d
	@echo "✨ Serviços iniciados"

down:
	@echo "🛑 Parando serviços..."
	@docker-compose down
	@echo "✨ Serviços parados"

ps:
	@docker-compose ps

fix-server:
	@echo "🔧 Corrigindo problema de 'server already running'..."
	@docker-compose exec web bash -c "rm -f /app/tmp/pids/server.pid"
	@echo "✅ Arquivo PID removido"

start:
	@echo "🚀 Iniciando ambiente Genius360 completo..."
	@bash start.sh
	@echo "⏳ Abrindo terminal no container web..."
	@docker-compose exec web bash

exec:
	@echo "🚀 Iniciando ambiente Genius360..."
	@docker-compose up -d
	@echo "⏳ Aguardando serviços..."
	@sleep 5
	@docker-compose exec web bash

shell:
	@echo "🐚 Abrindo terminal no container web..."
	@docker-compose exec web bash

logs:
	@docker-compose logs -f

rails-console:
	@echo "🛤️ Abrindo console Rails..."
	@docker-compose exec web rails console

db-console:
	@echo "🗄️ Abrindo console PostgreSQL..."
	@docker-compose exec postgres psql -U postgres -d genius360_development

db-migrate:
	@echo "🔄 Executando migrações do banco de dados..."
	@docker-compose exec web rails db:migrate

db-reset:
	@echo "⚠️ Recriando banco de dados... ⚠️"
	@docker-compose exec web rails db:drop db:create db:migrate db:seed
EOL

echo "✅ Makefile corrigido com sucesso!"
echo "👉 Você pode agora executar: make start"
