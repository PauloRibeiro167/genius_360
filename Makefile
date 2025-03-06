# Makefile para o projeto Genius360 - Versão com indentação corrigida

.PHONY: all up down ps fix-server start exec shell logs rails-console db-console db-migrate db-reset server-status server-start server-stop server-restart help diagnose fix-container safe-exec deep-fix inspect-compose force-exec rebuild-web bundle-fix clean-gems gexec trycat check-health view-playbook fix-gems

# Valor padrão para a porta
port ?= 3000

# Docker Compose
DOCKER_COMPOSE = docker-compose

# Diretório de scripts
SCRIPTS_DIR = .scripts

all:
	@echo "Comandos disponíveis:"
	@echo "  make up           - Inicia os serviços em background"
	@echo "  make down         - Para todos os containers"
	@echo "  make ps           - Lista os containers em execução"
	@echo "  make fix-server   - Corrige problema 'server already running'"
	@echo "  make start        - Inicia o servidor Rails"
	@echo "  make exec         - Inicia os containers e abre o console web"
	@echo "  make gexec        - Inicia os containers com verificação de status"
	@echo "  make shell        - Abre o terminal no container web"
	@echo "  make logs         - Exibe os logs dos containers"
	@echo "  make rails-console- Abre o console Rails"
	@echo "  make db-console   - Abre o console PostgreSQL"
	@echo "  make db-migrate   - Executa migrações do banco de dados"
	@echo "  make db-reset     - Recria o banco de dados"
	@echo "  make help         - Exibe os comandos disponíveis"

up:
	@echo "🚀 Iniciando serviços..."
	@$(DOCKER_COMPOSE) up -d

down:
	@echo "🛑 Parando serviços..."
	@$(DOCKER_COMPOSE) down

ps:
	@$(DOCKER_COMPOSE) ps

fix-server:
	@echo "🔧 Corrigindo problema de 'server already running'..."
	@$(DOCKER_COMPOSE) exec web bash -c "rm -f /app/tmp/pids/server.pid" || echo "⚠️ Não foi possível remover o arquivo PID"
	@echo "✅ Arquivo PID removido"

start:
	@echo "🚀 Iniciando servidor Rails..."
	@make fix-server
	@$(DOCKER_COMPOSE) exec web bash -c "cd /app && bundle exec rails s -p $(port) -b '0.0.0.0' -d"
	@echo "✅ Servidor Rails iniciado na porta $(port)"
	@echo "🌐 Acesse: http://localhost:$(port)"

exec:
	@echo "🚀 Iniciando ambiente Genius360..."
	@$(DOCKER_COMPOSE) up -d
	@echo "⏳ Aguardando serviços..."
	@sleep 5
	@if docker inspect --format='{{.State.Restarting}}' genius360_web | grep -q "true"; then \
		echo "⚠️ Container web está em loop de reinicialização. Tente 'make fix-container' ou 'make diagnose'."; \
		exit 1; \
	fi
	@echo "🔍 Verificando status do container web..."
	@$(DOCKER_COMPOSE) exec web bash

gexec:
	@echo "🚀 Iniciando ambiente Genius360..."
	@$(DOCKER_COMPOSE) up -d
	@echo "⏳ Aguardando serviços..."
	@sleep 5
	@if docker inspect --format='{{.State.Restarting}}' genius360_web | grep -q "true"; then \
		echo "⚠️ Container web está em loop de reinicialização. Tente 'make fix-container' ou 'make diagnose'."; \
		exit 1; \
	fi
	@echo "🔍 Verificando status do container web..."
	@$(DOCKER_COMPOSE) exec web bash

shell:
	@echo "🐚 Abrindo terminal no container web..."
	@$(DOCKER_COMPOSE) exec web bash

logs:
	@$(DOCKER_COMPOSE) logs -f

rails-console:
	@echo "🛤️ Abrindo console Rails..."
	@$(DOCKER_COMPOSE) exec web rails console

db-console:
	@echo "🗄️ Abrindo console PostgreSQL..."
	@$(DOCKER_COMPOSE) exec postgres psql -U postgres -d genius360_development

db-migrate:
	@echo "🔄 Executando migrações do banco de dados..."
	@$(DOCKER_COMPOSE) exec web rails db:migrate

db-reset:
	@echo "⚠️ Recriando banco de dados... ⚠️"
	@$(DOCKER_COMPOSE) exec web rails db:drop db:create db:migrate db:seed

help:
	@echo "Comandos disponíveis:"
	@echo "  make start           - Inicia o servidor Rails na porta padrão (3000)"
	@echo "  make start port=3001 - Inicia o servidor Rails na porta específica indicada"
	@echo "  make up              - Inicia os serviços em background"
	@echo "  make down            - Para todos os containers"
	@echo "  make ps              - Lista os containers em execução"
	@echo "  make logs            - Exibe os logs dos containers"
	@echo "  make gexec           - Inicia ambiente com verificação segura de status"
	@echo "  make trycat cmd=\"comando\" - Executa comando com captura de erros"
	@echo "  make check-health     - Verifica saúde do container web"
	@echo "  make view-playbook    - Abre o playbook de erros no navegador"
	@echo "  make bundle-fix       - Corrige problemas com bundler"
	@echo "  make fix-gems         - Correção mais agressiva para problemas de dependências"

# Adicionando comandos para diagnóstico e recuperação
diagnose:
	@echo "🔍 Iniciando diagnóstico do container..."
	@./bin/diagnose_container.sh web

fix-container:
	@echo "🔧 Tentando corrigir o container em reinicialização..."
	@./bin/fix_restarting_container.sh web

safe-exec:
	@echo "🚀 Iniciando ambiente Genius360 com verificação de segurança..."
	@$(DOCKER_COMPOSE) up -d
	@echo "⏳ Aguardando serviços..."
	@sleep 5
	@echo "🔍 Verificando status do container web..."
	@if docker inspect --format='{{.State.Restarting}}' genius360_web | grep -q "true"; then \
		echo "⚠️ Container web está em loop de reinicialização. Tentando corrigir..."; \
		./bin/fix_restarting_container.sh web; \
		echo "⏳ Tentando iniciar o shell novamente..."; \
		$(DOCKER_COMPOSE) exec web bash || echo "❌ Ainda não foi possível acessar o shell. Execute 'make diagnose' para mais detalhes."; \
	else \
		$(DOCKER_COMPOSE) exec web bash || echo "❌ Não foi possível acessar o shell. Execute 'make diagnose' para mais detalhes."; \
	fi

# Adicionando comandos para resolver problemas de bundle
bundle-fix:
	@echo "🔧 Corrigindo problemas com bundler..."
	@chmod +x bin/bundle_fix.sh
	@./bin/bundle_fix.sh

fix-gems:
	@echo "🔧 Executando correção agressiva de dependências..."
	@chmod +x bin/bundle_fix.sh
	@docker-compose down
	@docker volume rm genius360_bundle_cache 2>/dev/null || true
	@rm -rf vendor/bundle .bundle/cache tmp/cache/bootsnap* 2>/dev/null || true
	@./bin/bundle_fix.sh
	@echo "✅ Processo de correção de gems concluído. Verifique o status com 'make ps'."

clean-gems:
	@echo "🧹 Limpando cache de gems..."
	@$(DOCKER_COMPOSE) exec web bash -c "rm -rf /usr/local/bundle/* && rm -rf vendor/bundle"
	@echo "✅ Cache de gems limpo. Execute 'make bundle-fix' para reinstalar."

# Adicionando comandos para recuperação profunda
deep-fix:
	@echo "🔧 Iniciando reparo profundo do ambiente..."
	@chmod +x bin/deep_fix.sh
	@./bin/deep_fix.sh

inspect-compose:
	@echo "🔍 Analisando arquivo docker-compose.yml..."
	@chmod +x bin/inspect_docker_compose.sh
	@./bin/inspect_docker_compose.sh

force-exec:
	@echo "🚀 Forçando acesso ao container web (ignora status)..."
	@docker start genius360_web || true
	@sleep 5
	@docker exec -it genius360_web bash || echo "❌ Não foi possível acessar o container"

rebuild-web:
	@echo "🔨 Reconstruindo apenas o container web..."
	@docker-compose build --no-cache web
	@docker-compose up -d web
	@echo "⏳ Aguardando inicialização..."
	@sleep 10
	@docker ps | grep genius360_web

# Adicionando comando para reiniciar com bundle fix
restart-with-bundle-fix:
	@echo "🔄 Reiniciando com correção de bundler..."
	@$(DOCKER_COMPOSE) down
	@$(DOCKER_COMPOSE) up -d
	@sleep 5
	@chmod +x bin/bundle_fix.sh
	@./bin/bundle_fix.sh
	@echo "✅ Reinicialização com correção de bundler concluída."

# Adicionando comandos para DeepSeeker
deepseeker-install:
	@echo "🔧 Instalando DeepSeeker..."
	@chmod +x bin/deepseeker.sh bin/inspect_dockerfile.sh
	@echo "✅ DeepSeeker instalado com sucesso"
	@echo "📚 Comandos disponíveis:"
	@echo "  - make deepseeker-monitor   - Monitora e repara o ambiente uma vez"
	@echo "  - make deepseeker-analyze   - Analisa e identifica problemas"
	@echo "  - make deepseeker-repair    - Reparo completo do ambiente"
	@echo "  - make inspect-dockerfile   - Analisa o Dockerfile em busca de problemas"

deepseeker-monitor:
	@chmod +x bin/deepseeker.sh
	@./bin/deepseeker.sh monitor

deepseeker-analyze:
	@chmod +x bin/deepseeker.sh
	@./bin/deepseeker.sh analyze

deepseeker-repair:
	@chmod +x bin/deepseeker.sh
	@./bin/deepseeker.sh full-repair

inspect-dockerfile:
	@chmod +x bin/inspect_dockerfile.sh
	@./bin/inspect_dockerfile.sh

# Adicionando comando para monitorar-e-reparar continuamente
deepseeker-watch:
	@echo "🔍 Iniciando monitoramento contínuo com DeepSeeker..."
	@chmod +x bin/deepseeker.sh
	@while true; do \
		./bin/deepseeker.sh monitor; \
		echo "Aguardando 60 segundos antes da próxima verificação..."; \
		sleep 60; \
	done

# Adicionando comandos para DeepSeeker Rails
deepseeker-rails-install:
	@echo "📦 Instalando deepseek-rails no projeto..."
	@$(DOCKER_COMPOSE) run --rm web bundle exec rails deepseeker:install || \
		echo "⚠️ Não foi possível instalar via container, tentando adicionar ao Gemfile..." && \
		(grep -q "deepseek-rails" Gemfile || echo "gem 'deepseek-rails', '~> 0.3.0'" >> Gemfile) && \
		echo "✅ Gem adicionada ao Gemfile. Execute 'bundle install' manualmente."

deepseeker-rails-diagnose:
	@echo "🔍 Executando diagnóstico com deepseek-rails..."
	@$(DOCKER_COMPOSE) run --rm web bundle exec rails deepseeker:diagnose || \
		echo "⚠️ Não foi possível executar diagnóstico via container. Tente reparar o Dockerfile primeiro."

deepseeker-rails-repair:
	@echo "🔧 Executando reparo com deepseek-rails..."
	@$(DOCKER_COMPOSE) run --rm web bundle exec rails deepseeker:repair || \
		echo "⚠️ Não foi possível executar reparo via container. Tente reparar o Dockerfile primeiro."

# Comando para reparar o Dockerfile
fix-dockerfile:
	@echo "🔧 Reparando Dockerfile..."
	@chmod +x bin/fix_dockerfile.sh
	@./bin/fix_dockerfile.sh

# Comando para reconstruir após corrigir o Dockerfile
rebuild-after-fix:
	@echo "🔨 Reconstruindo após correção do Dockerfile..."
	@make fix-dockerfile
	@docker-compose build --no-cache web
	@docker-compose up -d
	@echo "⏳ Aguardando inicialização..."
	@sleep 10
	@docker-compose ps | grep web

# Adicionando comandos específicos para Dockerfile em locais não padrão
find-dockerfile:
	@echo "🔍 Procurando Dockerfile no projeto..."
	@DOCKERFILE=$$(find . -name "Dockerfile" -type f | head -n 1); \
	if [ -n "$$DOCKERFILE" ]; then \
		echo "✅ Dockerfile encontrado em: $$DOCKERFILE"; \
	else \
		echo "❌ Nenhum Dockerfile encontrado!"; \
	fi

force-rebuild:
	@echo "🚨 Iniciando reconstrução forçada do ambiente..."
	@chmod +x bin/force_rebuild.sh
	@./bin/force_rebuild.sh

force-bundle-install:
	@echo "📦 Forçando instalação de dependências..."
	@docker run --rm -v "$$(pwd):/app" -w /app ruby:3.2.2 bash -c "\
		gem update --system && \
		gem install bundler -v 2.4.22 && \
		bundle config set --local path 'vendor/bundle' && \
		bundle install --jobs=4"
	@echo "✅ Dependências instaladas com sucesso!"

# Comando completo para resolver problema do container em reinicialização
fix-container-full:
	@echo "🔄 Iniciando processo completo de correção..."
	@make find-dockerfile
	@make fix-dockerfile || echo "⚠️ Falha ao corrigir Dockerfile"
	@make force-rebuild

# Comandos de diagnóstico e rastreamento de erros
trycat:
	@chmod +x bin/trycat.sh
	@if [ -z "$(cmd)" ]; then \
		echo "⚠️ Erro: Especifique um comando com cmd=\"seu comando\""; \
		echo "Exemplo: make trycat cmd=\"docker logs genius360_web\""; \
		exit 1; \
	fi
	@./bin/trycat.sh $(cmd)

check-health:
	@chmod +x bin/container_health.sh
	@./bin/container_health.sh $(container)

view-playbook:
	@echo "🔍 Abrindo playbook de erros..."
	@if [ -f "docs/playbooks/error_handling.md" ]; then \
		if command -v xdg-open > /dev/null; then \
			xdg-open docs/playbooks/error_handling.md; \
		elif command -v open > /dev/null; then \
			open docs/playbooks/error_handling.md; \
		else \
			echo "⚠️ Não foi possível abrir automaticamente. Arquivo em: docs/playbooks/error_handling.md"; \
		fi; \
	else \
		echo "❌ Playbook não encontrado. Criando diretório..."; \
		mkdir -p docs/playbooks; \
		echo "# Playbook de Erros\n\nDocumentação ainda não criada." > docs/playbooks/error_handling.md; \
		echo "✅ Arquivo de playbook criado. Execute novamente para abrir."; \
	fi
