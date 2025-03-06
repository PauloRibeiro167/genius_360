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

## Solucionando problemas comuns

### Porta 3000 em uso

Se ao tentar iniciar o servidor Rails você receber o erro "Address already in use - bind(2) for "0" port 3000", significa que a porta 3000 já está sendo utilizada por outro processo. Você tem as seguintes opções:

1. **Usar outra porta para o servidor Rails**:
   ```bash
   rails s -b 0 -p 3001
   ```

2. **Verificar e encerrar o processo que está usando a porta 3000**:
   ```bash
   # Encontrar o PID do processo
   lsof -i :3000

   # Encerrar o processo (substitua {PID} pelo número do processo)
   kill -9 {PID}
   ```

3. **Usar o script auxiliar port_manager.sh**:
   ```bash
   bin/port_manager.sh 3000
   ```

4. **Usar o comando make**:
   ```bash
   # Iniciar na porta padrão (3000)
   make start
   
   # Iniciar em uma porta específica
   make start port=3001
   ```


# Genius360 - Guia de Comandos

Este documento contém um guia rápido dos principais comandos para gerenciar o ambiente Docker do Genius360.

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
