#!/bin/bash

echo "🔍 Iniciando diagnóstico do Genius360..."

echo -e "\n📊 Status dos containers Docker:"
docker-compose ps

echo -e "\n🧪 Verificando configuração do Docker:"
docker info | grep -E "Server Version|OS|Architecture|CPUs|Total Memory"

echo -e "\n🗄️ Verificando PostgreSQL:"
if docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
  echo "✅ PostgreSQL está respondendo"
  docker-compose exec -T postgres psql -U postgres -c "SELECT version();"
  docker-compose exec -T postgres psql -U postgres -c "SELECT current_database(), pg_size_pretty(pg_database_size(current_database()));"
else
  echo "❌ PostgreSQL não está respondendo"
  echo "🔍 Logs do PostgreSQL:"
  docker-compose logs postgres | tail -n 20
fi

echo -e "\n🛤️ Verificando aplicação Rails:"
if docker-compose exec -T web bash -c "which rails" > /dev/null 2>&1; then
  echo "✅ Rails está instalado"
  docker-compose exec -T web rails -v
  echo "📦 Gems instaladas:"
  docker-compose exec -T web bash -c "bundle list | grep -E 'rails|pg|puma|websocket|sprockets|turbo'"
else
  echo "❌ Rails não está instalado ou container não está respondendo"
fi

echo -e "\n📁 Verificando arquivos importantes:"
docker-compose exec -T web bash -c "ls -la config/database.yml && echo '✅ database.yml existe' || echo '❌ database.yml não encontrado'"
docker-compose exec -T web bash -c "ls -la config/master.key && echo '✅ master.key existe' || echo '❌ master.key não encontrado'"
docker-compose exec -T web bash -c "ls -la config/credentials.yml.enc && echo '✅ credentials.yml.enc existe' || echo '❌ credentials.yml.enc não encontrado'"

echo -e "\n🗒️ Verificando logs da aplicação:"
docker-compose exec -T web bash -c "cat log/development.log | tail -n 50"

echo -e "\n✨ Diagnóstico concluído. Se os problemas persistirem:"
echo "1. Tente 'make restart' para reiniciar os serviços"
echo "2. Tente 'make clean' seguido de 'make build' e 'make start' para reconstruir tudo"
echo "3. Verifique o arquivo docker-compose.yml e o Dockerfile por possíveis problemas"
