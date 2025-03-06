#!/bin/bash

# Verifica se uma porta está em uso e opcionalmente tenta liberá-la
check_and_free_port() {
  local port=$1
  local force=$2
  
  echo "🔍 Verificando se a porta $port está em uso..."
  
  if lsof -i ":$port" >/dev/null 2>&1; then
    local pid=$(lsof -t -i ":$port")
    local process=$(ps -p $pid -o comm=)
    
    echo "⚠️ Porta $port está em uso pelo processo $process (PID: $pid)"
    
    if [ "$force" = "true" ]; then
      echo "🛑 Finalizando processo $pid para liberar a porta $port..."
      kill -9 $pid
      echo "✅ Porta $port liberada!"
    else
      echo "💡 Para liberar esta porta, você pode executar: make kill-port port=$port"
      return 1
    fi
  else
    echo "✅ Porta $port está livre"
  fi
  
  return 0
}

# Se o script for executado diretamente
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
  if [ -z "$1" ]; then
    echo "⚠️ Por favor, especifique uma porta: $0 5432 [--force]"
    exit 1
  fi
  
  port=$1
  force="false"
  
  if [ "$2" = "--force" ]; then
    force="true"
  fi
  
  check_and_free_port $port $force
fi
