#!/bin/bash

# Script para capturar saídas de comandos e registrar erros
# Uso: trycat.sh <comando> [argumentos]

LOG_DIR="./logs/trycat"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGS_TO_KEEP=50

# Criar diretório de logs se não existir
mkdir -p "$LOG_DIR"

# Limpar logs antigos (manter apenas os N mais recentes)
find "$LOG_DIR" -type f -name "*.log" | sort | head -n -$LOGS_TO_KEEP | xargs rm -f 2>/dev/null

# Nome do arquivo de log baseado no comando
CMD_NAME=$(echo "$1" | sed 's/[^a-zA-Z0-9]/_/g')
LOG_FILE="${LOG_DIR}/${TIMESTAMP}_${CMD_NAME}.log"

echo "🔍 Executando: $*" | tee -a "$LOG_FILE"
echo "📅 Data: $(date)" >> "$LOG_FILE"
echo "📂 Log em: $LOG_FILE"
echo "-------------------------------------------" >> "$LOG_FILE"

# Executar o comando e capturar saída e erros
output=$("$@" 2>&1)
exit_code=$?

# Registrar saída
echo "$output" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "-------------------------------------------" >> "$LOG_FILE"
echo "Código de saída: $exit_code" >> "$LOG_FILE"

# Exibir saída no terminal
echo "$output"

# Se houve erro, exibir informações adicionais
if [ $exit_code -ne 0 ]; then
    echo -e "\n❌ ERRO: Comando retornou código $exit_code"
    echo -e "📝 Log completo salvo em: $LOG_FILE"
    
    # Extrair mensagens de erro comuns
    if echo "$output" | grep -q "is restarting, wait until"; then
        echo "🔄 Container em reinicialização. Tente: make fix-container"
    elif echo "$output" | grep -q "No such container"; then
        echo "🔍 Container não encontrado. Tente: make up"
    elif echo "$output" | grep -q "bind: address already in use"; then
        echo "🔌 Porta já em uso. Tente: make fix-server"
    fi
fi

exit $exit_code
