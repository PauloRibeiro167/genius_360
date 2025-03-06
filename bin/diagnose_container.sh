#!/bin/bash

# Script para diagnóstico detalhado de problemas do container
# Uso: diagnose_container.sh [nome_container]

# Definição de variáveis
CONTAINER=${1:-"genius360_web"}
DOCKER_COMPOSE="docker-compose"
LOG_FILE="./logs/diagnose_$(date +%Y%m%d_%H%M%S).log"
REPORT_FILE="./logs/report_$(date +%Y%m%d_%H%M%S).txt"

# Criar diretório de logs se não existir
mkdir -p ./logs

# Funções de exibição
print_header() {
    echo "=============================================="
    echo "🔍 Diagnóstico de Container 🔍"
    echo "=============================================="
    echo "📦 Container: $CONTAINER"
    echo "📅 Data: $(date)"
    echo "📝 Log: $LOG_FILE"
    echo "📊 Relatório: $REPORT_FILE"
    echo "=============================================="
}

log_cmd() {
    echo -e "\n> Executando: $@" | tee -a "$LOG_FILE"
    "$@" 2>&1 | tee -a "$LOG_FILE"
    return ${PIPESTATUS[0]}
}

print_section() {
    echo -e "\n📌 $1" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "----------------------------------------------" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
}

print_header | tee -a "$LOG_FILE"
echo "# Relatório de Diagnóstico - $CONTAINER" > "$REPORT_FILE"
echo "Data: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Verifica se o container existe
if ! docker ps -a | grep -q "$CONTAINER"; then
    echo "❌ Container $CONTAINER não encontrado!" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "Containers disponíveis:" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    docker ps -a | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    exit 1
fi

# 1. Verificar status do container
print_section "1. Status do Container"
container_status=$(docker inspect --format='{{.State.Status}}' "$CONTAINER")
is_restarting=$(docker inspect --format='{{.State.Restarting}}' "$CONTAINER")
exit_code=$(docker inspect --format='{{.State.ExitCode}}' "$CONTAINER")
health_status=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}N/A{{end}}' "$CONTAINER")
started_at=$(docker inspect --format='{{.State.StartedAt}}' "$CONTAINER")
pid=$(docker inspect --format='{{.State.Pid}}' "$CONTAINER")

echo "Status: $container_status" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
echo "Reiniciando: $is_restarting" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
echo "Código de saída: $exit_code" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
echo "Status de saúde: $health_status" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
echo "Iniciado em: $started_at" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
echo "PID: $pid" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"

# 2. Verificar comandos e configuração do container
print_section "2. Configuração do Container"
log_cmd docker inspect "$CONTAINER" | grep -A 5 -E "Cmd|Entrypoint|WorkingDir|User|Image"  | tee -a "$REPORT_FILE"

# 3. Verificar logs recentes
print_section "3. Logs Recentes (últimas 30 linhas)"
log_cmd docker logs --tail 30 "$CONTAINER" | tee -a "$REPORT_FILE"

# 4. Verificar uso de recursos
print_section "4. Uso de Recursos"
log_cmd docker stats --no-stream "$CONTAINER" | tee -a "$REPORT_FILE"

# 5. Verificar rede
print_section "5. Configuração de Rede"
log_cmd docker inspect "$CONTAINER" | grep -A 15 "Networks" | tee -a "$REPORT_FILE"

# 6. Verificar volumes
print_section "6. Volumes"
log_cmd docker inspect "$CONTAINER" | grep -A 15 "Mounts" | tee -a "$REPORT_FILE"

# 7. Verificar variáveis de ambiente
print_section "7. Variáveis de Ambiente"
log_cmd docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' "$CONTAINER" | grep -v "PASSWORD\|SECRET\|KEY" | tee -a "$REPORT_FILE"

# 8. Verificar arquivo de composição
print_section "8. Arquivo de Composição"
if [ -f "docker-compose.yml" ]; then
    echo "Encontrado docker-compose.yml" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    grep -A 10 "$CONTAINER" docker-compose.yml | grep -v "PASSWORD\|SECRET\|KEY" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
else
    echo "❌ Arquivo docker-compose.yml não encontrado" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

# 9. Verificar problemas comuns de Rails
print_section "9. Problemas Comuns de Rails"
if docker exec "$CONTAINER" bash -c "ls -la /app/tmp/pids/server.pid 2>/dev/null"; then
    echo "⚠️ Arquivo server.pid encontrado. Pode ser necessário remover." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
else
    echo "✅ Arquivo server.pid não encontrado." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

if docker exec "$CONTAINER" bash -c "bundle check 2>/dev/null"; then
    echo "✅ Bundle está OK" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
else
    echo "⚠️ Possível problema com bundler. Considere 'make bundle-fix'" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

# 10. Análise de problemas
print_section "10. Análise de Problemas"

# Analisa os logs em busca de padrões de erro comuns
errors=$(docker logs "$CONTAINER" 2>&1 | grep -i -E 'error|exception|fail|fatal|could not' | tail -10)
if [ -n "$errors" ]; then
    echo "⚠️ Erros encontrados nos logs:" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "$errors" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
else
    echo "✅ Nenhum erro óbvio encontrado nos logs." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

# Verifica permissões
if docker exec "$CONTAINER" bash -c "ls -la /app 2>/dev/null | grep -E 'tmp|log|public'"; then
    echo "✅ Diretórios principais acessíveis" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
else
    echo "⚠️ Possível problema de permissão nos diretórios" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

# 11. Conclusão
print_section "11. Conclusão e Recomendações"

if [ "$is_restarting" = "true" ]; then
    echo "❌ Container está em loop de reinicialização." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "Recomendações:" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "1. Execute 'make fix-container' para tentativa de reparo automático" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "2. Execute 'make force-rebuild' para reconstruir o container" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "3. Confira o relatório completo para mais detalhes: $REPORT_FILE" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
elif [ "$container_status" = "running" ]; then
    if grep -q "error\|exception\|fail\|fatal" "$LOG_FILE"; then
        echo "⚠️ Container está rodando, mas foram encontrados erros nos logs." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
        echo "Recomendação: verifique o relatório completo para mais detalhes." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    else
        echo "✅ Container parece estar funcionando corretamente!" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    fi
else
    echo "⚠️ Container não está rodando (status: $container_status)." | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "Recomendações:" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "1. Execute 'make up' para iniciar os containers" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
    echo "2. Execute 'make logs' para verificar logs detalhados" | tee -a "$LOG_FILE" | tee -a "$REPORT_FILE"
fi

echo -e "\n📊 Relatório de diagnóstico salvo em: $REPORT_FILE" | tee -a "$LOG_FILE"
echo -e "📝 Log detalhado salvo em: $LOG_FILE" | tee -a "$LOG_FILE"
