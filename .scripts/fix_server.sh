#!/bin/bash

echo "🔧 Corrigindo problema de 'server already running'..."

# Verifica se está dentro do container
if [ -f /app/tmp/pids/server.pid ]; then
  echo "🗑️ Removendo arquivo PID..."
  rm -f /app/tmp/pids/server.pid
  echo "✅ Arquivo PID removido com sucesso!"
  
  echo "👉 Agora você pode iniciar o servidor com: rails s"
  exit 0
fi

# Se executando fora do container
echo "🔍 Tentando remover o arquivo PID pelo Docker..."
docker-compose exec -T web bash -c "if [ -f /app/tmp/pids/server.pid ]; then rm -f /app/tmp/pids/server.pid && echo '✅ Arquivo PID removido'; else echo '❓ Arquivo PID não encontrado'; fi"

echo "✨ Correção aplicada!"
echo "👉 Agora você pode iniciar o servidor novamente"
