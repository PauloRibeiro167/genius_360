#!/bin/bash

echo "🔧 Corrigindo problema de 'server already running'..."

# Executa o comando para remover o arquivo PID
docker-compose exec web bash -c "rm -f /app/tmp/pids/server.pid"

echo "✅ Arquivo PID removido"
echo "👉 Agora você pode iniciar o servidor com: rails s"
