#!/bin/bash

echo "===== 🔍 VERIFICAÇÃO DE STATUS DOS SERVIÇOS ====="

# Verifica status dos containers
echo -e "\n📊 STATUS DOS CONTAINERS:"
docker-compose ps

# Verifica se o banco de dados está acessível
echo -e "\n🗄️ VERIFICAÇÃO DO BANCO DE DADOS:"
docker-compose exec -T postgres pg_isready -U postgres || echo "❌ Falha na conexão com o PostgreSQL"

# Verifica se o Rails está respondendo
echo -e "\n🌐 VERIFICAÇÃO DO SERVIDOR WEB:"
if curl -s http://localhost:3000 -o /dev/null; then
  echo "✅ Servidor Rails está respondendo na porta 3000"
else
  echo "❌ Servidor Rails não está respondendo na porta 3000"
  echo -e "\n🔍 Verificando logs do servidor web:"
  docker-compose logs --tail=20 web
fi

# Verifica logs recentes
echo -e "\n📝 LOGS RECENTES:"
echo "=== POSTGRES ==="
docker-compose logs --tail=5 postgres
echo -e "\n=== WEB ==="
docker-compose logs --tail=5 web

echo -e "\n✨ Verificação concluída!"
