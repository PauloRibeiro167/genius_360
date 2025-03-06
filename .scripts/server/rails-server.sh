#!/bin/bash

# Script simplificado para gerenciar o servidor Rails

# Função para verificar status
status() {
  echo "🔍 Verificando status do servidor Rails..."
  if docker-compose exec -T web bash -c "[ -f /app/tmp/pids/server.pid ]"; then
    PID=$(docker-compose exec -T web bash -c "cat /app/tmp/pids/server.pid")
    echo "✅ Servidor Rails está em execução (PID: $PID)"
  else
    echo "❌ Servidor Rails não está em execução"
  fi
}

# Função para iniciar o servidor
start() {
  PORT=${1:-3001}
  echo "🚀 Iniciando servidor Rails na porta $PORT..."
  docker-compose exec -T web bash -c "rm -f /app/tmp/pids/server.pid"
  docker-compose exec -T web bash -c "cd /app && bundle exec rails s -p $PORT -b '0.0.0.0' -d"
  sleep 2
  
  # Verificar se iniciou corretamente
  if docker-compose exec -T web bash -c "[ -f /app/tmp/pids/server.pid ]"; then
    echo "✅ Servidor Rails iniciado com sucesso"
    echo "🌐 Acesse: http://localhost:$PORT"
  else
    echo "❌ Falha ao iniciar o servidor"
  fi
}

# Função para parar o servidor
stop() {
  echo "🛑 Parando servidor Rails..."
  docker-compose exec -T web bash -c "if [ -f /app/tmp/pids/server.pid ]; then kill -9 \$(cat /app/tmp/pids/server.pid) 2>/dev/null; rm -f /app/tmp/pids/server.pid; echo '✅ Servidor parado'; else echo '⚠️ Nenhum servidor em execução'; fi"
}

# Função para reiniciar o servidor
restart() {
  PORT=${1:-3001}
  stop
  sleep 2
  start $PORT
}

# Verificar argumento
case "$1" in
  start)
    start $2
    ;;
  stop)
    stop
    ;;
  restart)
    restart $2
    ;;
  status)
    status
    ;;
  *)
    echo "Uso: $0 {start|stop|restart|status} [porta]"
    echo "Exemplos:"
    echo "  $0 start 3001    - Inicia o servidor na porta 3001"
    echo "  $0 stop          - Para o servidor"
    echo "  $0 restart 3001  - Reinicia o servidor na porta 3001"
    echo "  $0 status        - Verifica o status do servidor"
    exit 1
    ;;
esac

exit 0
