# Ambiente de Desenvolvimento (.devcontainer)

Este diretório contém configurações para o ambiente de desenvolvimento integrado do projeto Genius360, utilizando a tecnologia DevContainers.

## Estrutura de Arquivos

```
.devcontainer/
├── .scripts/           # Scripts utilitários para o ambiente
├── compose.yaml        # Configuração Docker Compose para dev containers
├── devcontainer.json   # Configuração do VSCode Dev Containers
├── Dockerfile          # Dockerfile para ambiente de desenvolvimento
├── Makefile            # Comandos para facilitar o desenvolvimento
└── README.md           # Esta documentação
```

## Uso Rápido

Para iniciar o ambiente de desenvolvimento, você tem várias opções:

### Dentro do diretório .devcontainer

```bash
# Inicia os containers em background
make run

# Inicia os containers em modo interativo
make dev

# Para os containers
make stop

# Para e remove os containers
make down
```

### Na raiz do projeto

```bash
# Script interativo que permite escolher entre ambientes
./dev-start.sh

# Iniciar diretamente o ambiente .devcontainer
./dev-start.sh --devcontainer
```

## Comandos Disponíveis (Makefile)

- `make run` - Inicia os containers em background
- `make dev` - Inicia os containers em modo interativo
- `make stop` - Para os containers
- `make down` - Para e remove os containers
- `make logs` - Exibe logs dos containers
- `make ps` - Exibe status dos containers
- `make build` - Constrói as imagens dos containers
- `make clean` - Remove containers, imagens e volumes
- `make restart` - Reinicia serviços
- `make status` - Mostra status detalhado
- `make shell` - Abre shell no container principal
- `make help` - Exibe ajuda sobre os comandos disponíveis

## Script Interativo

Para uma experiência mais amigável, você pode usar o script interativo:

```bash
# Torna o script executável
chmod +x run_devcontainer.sh

# Executa o script
./run_devcontainer.sh
```

Este script oferece um menu com opções para gerenciar o ambiente de desenvolvimento de forma intuitiva.

## Diferenças entre .devcontainer e docker-compose.yml Principal

O ambiente `.devcontainer` é otimizado para desenvolvimento e inclui:

1. Ferramentas adicionais para desenvolvimento
2. Volumes configurados para uma experiência de desenvolvimento mais fluida
3. Configurações específicas para IDEs (VSCode)
4. Scripts de diagnóstico e utilitários

Enquanto o `docker-compose.yml` na raiz do projeto é voltado para a execução padrão da aplicação, com menor sobrecarga e configurações mais orientadas à produção.
