#!/bin/bash

echo "=== Status dos contêineres ==="
docker-compose ps

echo -e "\n=== Logs do PostgreSQL ==="
docker-compose logs postgres | tail -n 20

echo -e "\n=== Logs da aplicação Web ==="
docker-compose logs web | tail -n 20

echo -e "\n=== Verificação da conexão com o banco de dados ==="
docker-compose exec web bash -c "bundle exec rails runner 'puts ActiveRecord::Base.connection.active?'"

echo -e "\n=== Verificação de portas ativas ==="
echo "Porta 5433 (PostgreSQL):"
ss -tulpn | grep 5433
echo "Porta 3000 (Rails):"
ss -tulpn | grep 3000
