#!/bin/bash

echo "🔧 Inicializando ambiente Genius360..."

# Cria diretório scripts se não existir
if [ ! -d "scripts" ]; then
  echo "📁 Criando diretório scripts..."
  mkdir -p scripts
fi

# Garante que os scripts existam e sejam executáveis
echo "📝 Verificando scripts necessários..."

# Lista de scripts para verificar/criar
SCRIPTS=("start.sh" "fix_server.sh" "inside-fix.sh" "setup-scripts.sh")
SCRIPT_DIRS=("scripts/check_status.sh" "scripts/debug.sh")

# Verifica cada script
for SCRIPT in "${SCRIPTS[@]}" "${SCRIPT_DIRS[@]}"; do
  if [ -f "$SCRIPT" ]; then
    echo "✓ $SCRIPT já existe, tornando executável..."
    chmod +x "$SCRIPT"
    # Corrige possíveis problemas com quebras de linha
    sed -i 's/\r$//' "$SCRIPT"
  else
    echo "⚠️ $SCRIPT não encontrado. Pulando..."
  fi
done

# Verifica se o Makefile simples existe
if [ -f "Makefile" ]; then
  echo "✓ Makefile já existe."
else
  echo "📝 Criando Makefile..."
  cat > Makefile << 'EOL'
# Makefile para o projeto Genius360
.PHONY: all up down ps fix-server start exec shell logs rails-console db-console db-migrate db-reset

all:
	@echo "Comandos disponíveis:"
	@echo "  make up           - Inicia os serviços em background"
	@echo "  make down         - Para todos os containers"
	@echo "  make ps           - Lista os containers em execução"
	@echo "  make fix-server   - Corrige problema 'server already running'"
	@echo "  make start        - Inicia todos os serviços e verifica funcionamento"
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
	@bash start.sh

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
fi

echo "✨ Inicialização concluída!"
echo "👉 Para começar, execute: make up"
echo "👉 Para iniciar e verificar tudo: make start"
echo "👉 Para acessar o container: make shell"
echo "👉 Para ver todos os comandos: make"
