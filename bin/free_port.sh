#!/bin/bash

# Script para liberar uma porta TCP específica
# Uso: ./free_port.sh <porta> [--force]

PORT=$1
FORCE=$2

if [ -z "$PORT" ]; then
  echo "❌ Erro: Porta não especificada."
  echo "Uso: $0 <porta> [--force]"
  echo "Exemplo: $0 3000 --force"
  exit 1
fi

echo "🔍 Verificando processos usando a porta $PORT..."

# Obter PIDs usando a porta
PIDS=$(lsof -t -i:$PORT 2>/dev/null)
PROCESS_INFO=$(lsof -i:$PORT -sTCP:LISTEN 2>/dev/null | tail -n +2)

if [ -z "$PIDS" ]; then
  echo "✅ Nenhum processo encontrado usando a porta $PORT."
  exit 0
fi

echo "⚠️ Os seguintes processos estão usando a porta $PORT:"
echo "$PROCESS_INFO"

if [ "$FORCE" != "--force" ]; then
  read -p "Deseja encerrar estes processos? (s/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❓ Operação cancelada pelo usuário."
    exit 1
  fi
fi

echo "🛑 Encerrando processos..."
for PID in $PIDS; do
  PROCESS_NAME=$(ps -p $PID -o comm= 2>/dev/null || echo "Processo desconhecido")
  echo "   Encerrando $PROCESS_NAME (PID: $PID)..."
  kill -15 $PID 2>/dev/null || true
  
  # Aguarde até 2 segundos para ver se o processo termina normalmente
  for i in {1..4}; do
    if ! ps -p $PID > /dev/null 2>&1; then
      break
    fi
    sleep 0.5
  done
  
  # Se o processo ainda estiver rodando, use kill -9
  if ps -p $PID > /dev/null 2>&1; then
    echo "   Processo $PID não respondeu, forçando encerramento..."
    kill -9 $PID 2>/dev/null || true
  fi
done

# Verificar se a porta foi realmente liberada
sleep 0.5
if lsof -i:$PORT >/dev/null 2>&1; then
  echo "⚠️ Aviso: A porta $PORT ainda parece estar em uso."
  echo "   Tentando um último método de liberação..."
  
  # Em sistemas Linux, podemos tentar usar o seguinte método
  if command -v fuser >/dev/null 2>&1; then
    fuser -k $PORT/tcp >/dev/null 2>&1
    sleep 0.5
  fi
  
  if lsof -i:$PORT >/dev/null 2>&1; then
    echo "❌ Não foi possível liberar completamente a porta $PORT."
    exit 1
  else
    echo "✅ Porta $PORT liberada com sucesso!"
  fi
else
  echo "✅ Porta $PORT liberada com sucesso!"
fi

exit 0
