#!/bin/bash

# Função para limpar terminal quando necessário
clear_terminal() {
  if [ "$1" == "clear" ]; then
    clear
  fi
}

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

# Verifica se o servidor Rails está respondendo
echo "🌐 Verificando servidor Rails..."
if ! curl -s http://localhost:3000 -o /dev/null 2>&1; then
  echo "⚠️ Servidor Rails não está respondendo. Corrigindo problema do PID..."
  docker-compose exec -T web bash -c "rm -f /app/tmp/pids/server.pid"
  echo "🔄 Reiniciando o container web..."
  docker-compose restart web
  echo "⏳ Aguardando servidor Rails iniciar..."
  sleep 5
fi

echo "✅ Sistema Genius360 está pronto!"
echo "🌐 Acesse: http://localhost:3000"
echo "🐚 Abrindo terminal no container web..."
echo ""
echo "====================== CONTAINER WEB TERMINAL ======================"
clear_terminal "clear"
# Abre shell interativo no container web
docker-compose exec web bash

echo "❌ Terminal do container web encerrado"
