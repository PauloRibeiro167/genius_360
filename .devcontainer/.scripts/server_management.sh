#!/bin/bash

# Funções para gerenciar o servidor Rails
start_server() {
  echo "🚀 Iniciando servidor Rails..."
  if [ -f tmp/pids/server.pid ]; then
    echo "⚠️ Arquivo PID encontrado. Removendo..."
    rm -f tmp/pids/server.pid
  fi
  bin/rails server -p 3000 -b '0.0.0.0' -d
  echo "✅ Servidor iniciado em background"
}

stop_server() {
  echo "🛑 Parando servidor Rails..."
  if [ -f tmp/pids/server.pid ]; then
    PID=$(cat tmp/pids/server.pid)
    echo "🔍 Servidor encontrado com PID: $PID"
    kill -9 $PID 2>/dev/null || true
    rm -f tmp/pids/server.pid
    echo "✅ Servidor parado com sucesso"
  else
    echo "ℹ️ Nenhum servidor em execução (arquivo PID não encontrado)"
  fi
}

restart_server() {
  echo "🔄 Reiniciando servidor Rails..."
  stop_server
  sleep 2
  start_server
}

server_status() {
  if [ -f tmp/pids/server.pid ]; then
    PID=$(cat tmp/pids/server.pid)
    if ps -p $PID > /dev/null; then
      echo "✅ Servidor Rails está em execução (PID: $PID)"
    else
      echo "⚠️ Arquivo PID existe, mas o processo não está em execução"
      echo "   Executando limpeza..."
      rm -f tmp/pids/server.pid
    fi
  else
    echo "❌ Servidor Rails não está em execução"
  fi
}

# Executa a função com base no argumento passado
case "$1" in
  start)
    start_server
    ;;
  stop)
    stop_server
    ;;
  restart)
    restart_server
    ;;
  status)
    server_status
    ;;
  *)
    echo "Uso: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
