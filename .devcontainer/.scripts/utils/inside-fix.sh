#!/bin/bash

echo "🔧 Corrigindo problema de 'server already running' dentro do container..."

if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
  echo "✅ Arquivo PID removido"
else
  echo "ℹ️ Arquivo PID não encontrado"
fi

echo "👉 Agora você pode iniciar o servidor com: rails s"
