#!/bin/bash

echo "🔍 Verificando se o servidor Rails precisa ser parado..."
if docker-compose exec -T web bash -c "[ -f /app/tmp/pids/server.pid ]"; then
  echo "🛑 Parando servidor Rails..."
  docker-compose exec -T web bash -c "cd /app && bash scripts/server_management.sh stop"
fi

echo "🛑 Parando todos os serviços..."
docker-compose down

echo "🧹 Limpando volumes temporários (mantendo dados do PostgreSQL)..."
docker-compose run --rm web bash -c "rm -rf tmp/cache"
docker-compose run --rm web bash -c "rm -f tmp/pids/server.pid"

echo "🚀 Reiniciando serviços..."
docker-compose up -d

echo "⏳ Aguardando serviços iniciarem..."
sleep 5

echo "📊 Status dos serviços:"
docker-compose ps

echo "🔍 Verificando logs da aplicação web:"
docker-compose logs --tail=10 web

echo "✨ Serviços reiniciados com sucesso!"
echo "🌐 Acesse: http://localhost:3000"