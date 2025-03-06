#!/bin/bash

echo "🚀 Iniciando Genius360..."

# Verifica se containers estão rodando
if ! docker-compose ps | grep "Up" > /dev/null; then
  echo "📦 Iniciando containers..."
  docker-compose up -d
  echo "⏳ Aguardando serviços iniciarem..."
  sleep 5
else
  echo "✅ Containers já estão em execução"
fi

# Verifica se o banco de dados está pronto
echo "🔍 Verificando conexão com o banco de dados..."
if ! docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
  echo "⚠️ Esperando banco de dados iniciar..."
  for i in {1..10}; do
    sleep 3
    echo -n "."
    if docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
      echo " ✅"
      break
    fi
    if [ $i -eq 10 ]; then
      echo " ❌"
      echo "❌ Banco de dados não respondeu no tempo esperado"
      exit 1
    fi
  done
fi

# Inicializa o banco de dados se necessário
if ! docker-compose exec -T web rails db:version > /dev/null 2>&1; then
  echo "🗄️ Inicializando banco de dados..."
  docker-compose exec -T web rails db:create db:migrate db:seed
fi

# Verifica se o servidor Rails está respondendo
echo "🌐 Verificando servidor Rails..."
if curl -s http://localhost:3000 -o /dev/null 2>&1; then
  echo "✅ Servidor Rails está respondendo!"
else
  echo "⚠️ Servidor Rails não está respondendo. Corrigindo problema do PID..."
  docker-compose exec -T web bash -c "rm -f /app/tmp/pids/server.pid"
  echo "🔄 Reiniciando o container web..."
  docker-compose restart web
  echo "⏳ Aguardando servidor Rails iniciar..."
  sleep 5
  
  # Verifica novamente
  if curl -s http://localhost:3000 -o /dev/null 2>&1; then
    echo "✅ Servidor Rails está respondendo após correção!"
  else
    echo "⚠️ Servidor Rails ainda não está respondendo. Verifique os logs: make logs"
  fi
fi

echo "✅ Sistema Genius360 está pronto!"
echo "🌐 Acesse: http://localhost:3000"
echo "📋 Para ver todos os comandos disponíveis: make help"
