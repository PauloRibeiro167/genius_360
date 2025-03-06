# Genius360 - Playbook de Erros

Este documento lista erros comuns encontrados durante o trabalho com o ambiente Docker do Genius360 e suas soluções.

## Container em Loop de Reinicialização

### Sintomas:
- Comando `make exec` ou `make shell` falha
- Mensagem de erro: `Container X is restarting, wait until the container is running`
- Container web está constantemente reiniciando

### Diagnóstico:
```bash
docker ps  # Verificar se o status está "Restarting"
docker logs genius360_web  # Ver logs para identificar o problema
```

### Soluções:
1. **Fix Container Básico**:
   ```bash
   make fix-container
   ```

2. **Reparo Profundo**:
   ```bash
   make deep-fix
   ```

3. **Reconstruir Container**:
   ```bash
   make rebuild-web
   ```

## Problemas com Bundler

### Sintomas:
- Erros relacionados a gems
- `Could not find X in any of the sources`
- Container não inicia corretamente após atualização do Gemfile

### Diagnóstico:
```bash
make logs  # Ver erros relacionados ao bundler
```

### Soluções:
1. **Corrigir Bundler**:
   ```bash
   make bundle-fix
   ```

2. **Limpar Cache e Reinstalar**:
   ```bash
   make clean-gems
   make bundle-fix
   ```

## Servidor Rails Já em Execução

### Sintomas:
- Erro ao iniciar o servidor: `A server is already running`
- Mensagens sobre arquivo `server.pid`

### Soluções:
```bash
make fix-server
make start
```

## Problemas de Permissão

### Sintomas:
- Erros de permissão ao criar/modificar arquivos
- `Permission denied` em logs

### Soluções:
1. **Corrigir permissões**:
   ```bash
   sudo chown -R $USER:$USER .
   ```

2. **Usar shell com privilégios**:
   ```bash
   make force-exec
   ```

## Banco de Dados

### Sintomas:
- Erros de conexão com o banco
- Tabelas não encontradas
- Erro: `PG::UndefinedTable`

### Soluções:
1. **Verificar se o PostgreSQL está rodando**:
   ```bash
   docker ps | grep postgres
   ```

2. **Resetar banco de dados**:
   ```bash
   make db-reset
   ```

3. **Executar migrações**:
   ```bash
   make db-migrate
   ```

## Usando o TryCat para Diagnóstico

O script `trycat.sh` foi criado para capturar saídas e erros de comandos:

```bash
./bin/trycat.sh make exec
./bin/trycat.sh docker logs genius360_web
```

Os logs são salvos em `./logs/trycat/` para análise posterior.

## Comandos Úteis para Diagnóstico

| Comando | Descrição |
|---------|-----------|
| `make diagnose` | Executa diagnóstico básico do ambiente |
| `make logs` | Exibe logs dos containers |
| `make ps` | Lista status dos containers |
| `docker inspect genius360_web` | Exibe informações detalhadas do container web |
| `docker stats` | Monitora uso de recursos dos containers |
| `./bin/trycat.sh <comando>` | Executa comando e registra saída para diagnóstico |

## Script de Diagnóstico One-Line

```bash
echo "== STATUS DOS CONTAINERS ==" && docker ps && echo -e "\n== LOGS DO CONTAINER WEB ==" && docker logs --tail 20 genius360_web && echo -e "\n== DETALHES DO CONTAINER ==" && docker inspect -f '{{.State.Status}} / {{.State.Health.Status}} / {{index .Config.Labels "com.docker.compose.service"}}' genius360_web
```
