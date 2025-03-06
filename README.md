# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

# Genius360

Sistema de gestão integrada para empresas.

## Requisitos

- Docker
- Docker Compose

## Instalação e Execução Rápida

Para iniciar rapidamente, execute:

```bash
# Torna os scripts executáveis
chmod +x run.sh setup.sh

# Executa o script de execução rápida
./run.sh
```

Este script interativo:
1. Verifica o status atual dos containers
2. Oferece opções adequadas ao estado atual (iniciar/parar/reiniciar/logs)
3. Executa as ações necessárias com base na escolha do usuário

## Configuração Inicial (Primeira Vez)

Para configurar o ambiente completo, execute:

```bash
# Torna o script de setup executável
chmod +x setup.sh

# Executa o setup
./setup.sh
```

## Comandos Disponíveis

O projeto utiliza Makefile para facilitar a execução de tarefas comuns:

### Docker e Containers

- `make build` - Constrói as imagens dos containers
- `make run` - Inicia os containers em background
- `make dev` - Inicia os containers em modo de desenvolvimento
- `make stop` - Para os containers
- `make down` - Para e remove os containers
- `make clean` - Remove containers, imagens e volumes
- `make logs` - Exibe logs dos containers
- `make ps` - Exibe status dos containers

### Comandos de Desenvolvimento

- `make start` - Inicia os containers e verifica se a aplicação está respondendo
- `make shell` - Abre um shell no container web
- `make exec` - Inicia os containers e abre um shell no container web
- `make status` - Mostra o status detalhado dos serviços

### Comandos Rails e Banco de Dados

- `make rails-console` - Abre o console Rails
- `make db-console` - Abre o console PostgreSQL
- `make db-migrate` - Executa migrações do banco de dados
- `make db-reset` - Recria o banco de dados (drop, create, migrate, seed)
- `make routes` - Lista todas as rotas da aplicação
- `make test` - Executa os testes da aplicação
- `make update` - Atualiza dependências (bundle update)

### Utilitários e Diagnóstico

- `make dev-setup` - Configura ambiente de desenvolvimento
- `make backup` - Realiza backup do sistema
- `make check-status` - Verifica status do servidor
- `make debug` - Inicia depuração
- `make fix-server` - Corrige problemas do servidor
- `make restart` - Reinicia serviços
- `make performance` - Verifica performance do sistema
- `make diagnostico` - Executa diagnóstico Docker

## Estrutura de Arquivos

```
genius360/
├── .devcontainer/       # Configuração do ambiente de desenvolvimento
│   ├── .scripts/        # Scripts utilitários
│   ├── compose.yaml     # Configuração Docker Compose para dev containers
│   ├── devcontainer.json # Configuração do VSCode Dev Containers
│   └── Dockerfile       # Dockerfile para ambiente de desenvolvimento
├── app/                 # Código fonte da aplicação
├── config/              # Arquivos de configuração
├── db/                  # Migrações e seeds do banco de dados
├── docker-compose.yml   # Configuração Docker Compose para execução
├── Makefile             # Comandos para facilitar o desenvolvimento
├── run.sh               # Script de execução rápida
├── setup.sh             # Script de configuração inicial
└── ...
```

## Solucionando problemas comuns
## Comandos Básicos

| Comando | Descrição |
|---------|-----------|
| `make start` | Inicia todos os serviços e verifica o funcionamento |
| `make shell` | Abre um terminal bash no container web |
| `make exec` | Inicia os serviços e abre um terminal no container web |
| `make down` | Para todos os containers |
| `make status` | Verifica o status dos serviços |
| `make logs` | Exibe os logs dos containers em tempo real |
| `make ps` | Lista os containers em execução |

## Comandos para Desenvolvimento

| Comando | Descrição |
|---------|-----------|
| `make rails-console` | Abre o console Rails |
| `make db-console` | Abre o console PostgreSQL |
| `make db-migrate` | Executa migrações do banco de dados |
| `make db-reset` | Recria o banco de dados (drop, create, migrate, seed) |
| `make routes` | Lista todas as rotas da aplicação |
| `make test` | Executa os testes da aplicação |

## Comandos de Manutenção

| Comando | Descrição |
|---------|-----------|
| `make restart` | Reinicia todos os serviços |
| `make build` | Rebuilda os containers |
| `make clean` | Para os containers e remove volumes/imagens |
| `make update` | Atualiza as dependências (bundle update) |
| `make debug` | Executa diagnóstico completo do ambiente |
| `make performance` | Verifica a performance do sistema |

## Fluxo de Trabalho Típico

1. Iniciar o sistema: `make start`
2. Abrir um terminal no container: `make shell`
3. Fazer alterações no código
4. Verificar o status dos serviços: `make status`
5. Executar migrações (se necessário): `make db-migrate`
6. Verificar rotas: `make routes`
7. Executar testes: `make test`
8. Encerrar o ambiente: `make down`

## Resolvendo Problemas

Se encontrar problemas:

1. Verifique o status com `make status`
2. Confira os logs com `make logs`
3. Execute o diagnóstico com `make debug`
4. Tente reiniciar com `make restart`
5. Em último caso, reconstrua tudo: `make clean && make build && make start`
