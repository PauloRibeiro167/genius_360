#!/bin/bash

echo "🔍 Verificando conexão com o banco de dados PostgreSQL..."

# Tenta conectar ao PostgreSQL
if docker-compose exec postgres pg_isready -U postgres > /dev/null 2>&1; then
  echo "✅ Servidor PostgreSQL está rodando e aceitando conexões"
else
  echo "❌ Não foi possível conectar ao servidor PostgreSQL"
  echo "🔄 Reiniciando o container do PostgreSQL..."
  docker-compose restart postgres
  sleep 5
  echo "⏳ Aguardando o PostgreSQL iniciar..."
  
  # Verifica se está pronto após reiniciar
  if docker-compose exec postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo "✅ PostgreSQL reiniciado com sucesso"
  else
    echo "❌ PostgreSQL ainda não está disponível. Verifique os logs com 'make logs'"
    exit 1
  fi
fi

# Verifica se as credenciais estão corretas
echo "🔑 Verificando credenciais do banco de dados..."
if docker-compose exec postgres psql -U postgres -c "SELECT 1;" > /dev/null 2>&1; then
  echo "✅ Credenciais corretas para o usuário postgres"
else
  echo "❌ Problema com autenticação. Configurando senha para o usuário postgres..."
  docker-compose exec postgres psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
  echo "✅ Senha do usuário postgres redefinida"
fi

# Verifica a resolução de nomes na rede Docker
echo "🔍 Verificando resolução de nomes na rede Docker..."
docker-compose exec web bash -c "ping -c 1 postgres" > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "✅ Resolução de nomes OK"
else
  echo "❌ Falha na resolução do nome 'postgres'"
  echo "⚠️  Problema identificado: o container web não consegue resolver o nome 'postgres'."
  echo "🔧 Tentando corrigir o problema..."
  docker-compose down
  docker-compose up -d
  sleep 5
  echo "✅ Containers reiniciados. Tentando novamente..."
  
  docker-compose exec web bash -c "ping -c 1 postgres" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "✅ Resolução de nomes corrigida!"
  else
    echo "❌ Problema persistente. Tente usar o IP do container PostgreSQL no arquivo database.yml"
    echo "   Execute 'docker inspect genius360_postgres | grep IPAddress' para obter o IP"
  fi
fi

echo "✨ Verificação de conexão com o banco de dados concluída"
