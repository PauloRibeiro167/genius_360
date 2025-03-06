# Makefile para o ambiente de desenvolvimento (.devcontainer)
.PHONY: all run dev stop down logs ps build clean restart status shell

# Variáveis
PROJECT_NAME = genius360
DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = compose.yaml
PARENT_DIR = ..

# Redirecionamento para comandos na raiz do projeto
all:
	@echo "Redirecionando para o Makefile na raiz..."
	cd $(PARENT_DIR) && make all

# Comandos específicos para o ambiente .devcontainer
run:
	@echo "Iniciando containers de desenvolvimento (.devcontainer)..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

dev:
	@echo "Iniciando ambiente de desenvolvimento interativo..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up

stop:
	@echo "Parando containers..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) stop

down:
	@echo "Parando e removendo containers..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

logs:
	@echo "Exibindo logs..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f

ps:
	@echo "Status dos containers..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

build:
	@echo "Construindo containers de desenvolvimento..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build

clean:
	@echo "Limpando ambiente de desenvolvimento..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans

restart:
	@echo "Reiniciando containers de desenvolvimento..."
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) restart

status:
	@echo "Verificando status dos serviços em .devcontainer..."
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

shell:
	@echo "Abrindo shell no container principal..."
	@container_id=$$($(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps -q | head -n1); \
	if [ -n "$$container_id" ]; then \
		docker exec -it $$container_id bash; \
	else \
		echo "Nenhum container em execução. Inicie com 'make run' primeiro."; \
	fi

# Ajuda
help:
	@echo "Comandos disponíveis no ambiente .devcontainer:"
	@echo "  run      - Inicia os containers em background"
	@echo "  dev      - Inicia os containers em modo interativo"
	@echo "  stop     - Para os containers"
	@echo "  down     - Para e remove os containers"
	@echo "  logs     - Exibe logs dos containers"
	@echo "  ps       - Exibe status dos containers"
	@echo "  build    - Constrói as imagens dos containers"
	@echo "  clean    - Remove containers, imagens e volumes"
	@echo "  restart  - Reinicia serviços"
	@echo "  status   - Mostra status detalhado"
	@echo "  shell    - Abre shell no container principal"
	@echo "  help     - Exibe esta ajuda"
