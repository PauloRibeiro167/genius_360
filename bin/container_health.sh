#!/bin/bash

# Script para verificar a saúde do container e capturar erros
# Uso: container_health.sh [nome_do_container]

CONTAINER=${1:-"genius360_web"}
LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

echo "🔍 Verificando saúde do container: $CONTAINER"
echo "📅 Data: $(date)"
echo "-------------------------------------------"

# Verificar se o container existe
if ! docker ps -a --format '{{.Names}}' | grep -q "$CONTAINER"; then
    echo "❌ Container '$CONTAINER' não encontrado!"
    echo "Containers disponíveis:"
    docker ps -a --format '{{.Names}}'
    exit 1
fi

# Verificar status do container
status=$(docker inspect --format='{{.State.Status}}' "$CONTAINER" 2>/dev/null)
restarting=$(docker inspect --format='{{.State.Restarting}}' "$CONTAINER" 2>/dev/null)
exit_code=$(docker inspect --format='{{.State.ExitCode}}' "$CONTAINER" 2>/dev/null)
started_at=$(docker inspect --format='{{.State.StartedAt}}' "$CONTAINER" 2>/dev/null)
health=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}N/A{{end}}' "$CONTAINER" 2>/dev/null)

echo "📊 Status do container: $status"
echo "🔄 Reiniciando: $restarting"
echo "🚪 Código de saída: $exit_code"
echo "🕒 Iniciado em: $started_at"
echo "💓 Saúde: $health"
echo "-------------------------------------------"

# Capturar logs recentes
echo "📜 Logs recentes:"
docker logs --tail 20 "$CONTAINER" | tee "$LOG_DIR/${CONTAINER}_recent.log"
echo "-------------------------------------------"

# Verificar uso de recursos
echo "🖥️ Uso de recursos:"
docker stats "$CONTAINER" --no-stream --format "CPU: {{.CPUPerc}}, Memória: {{.MemUsage}}"
echo "-------------------------------------------"

# Sugerir ações baseadas no status
echo "🔧 Diagnóstico:"
if [ "$restarting" = "true" ]; then
    echo "⚠️ Container está em loop de reinicialização."
    echo "  Recomendação: execute 'make fix-container' ou 'make deep-fix'"
    echo "  Verifique logs completos com: docker logs $CONTAINER"
elif [ "$status" = "running" ]; then
    if [ "$health" = "healthy" ] || [ "$health" = "N/A" ]; then
        echo "✅ Container parece estar funcionando normalmente!"
    else
        echo "⚠️ Container está rodando, mas a verificação de saúde indica problema: $health"
        echo "  Recomendação: execute 'make diagnose' para mais detalhes"
    fi
elif [ "$status" = "exited" ]; then
    echo "❌ Container não está rodando (saiu com código $exit_code)."
    echo "  Recomendação: execute 'make up' ou 'docker start $CONTAINER' para reiniciar"
    echo "  Caso persista, tente 'make rebuild-web'"
else
    echo "⚠️ Status desconhecido: $status"
    echo "  Recomendação: execute 'make ps' e 'make logs' para mais informações"
fi
