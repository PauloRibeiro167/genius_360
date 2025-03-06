#!/bin/bash

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para verificar se o servidor está em execução
check_server() {
  if [ -f tmp/pids/server.pid ]; then
    PID=$(cat tmp/pids/server.pid)
    if ps -p $PID > /dev/null; then
      echo -e "${GREEN}✅ Servidor Rails está em execução (PID: $PID)${NC}"
      return 0
    else
      echo -e "${YELLOW}⚠️ Arquivo PID existe, mas processo não está em execução${NC}"
      rm -f tmp/pids/server.pid
      return 1
    fi
  else
    echo -e "${YELLOW}⚠️ Servidor Rails não está em execução (PID não encontrado)${NC}"
    return 1
  fi
}

# Função para parar o servidor
stop_server() {
  if [ -f tmp/pids/server.pid ]; then
    PID=$(cat tmp/pids/server.pid)
    echo -e "${YELLOW}🛑 Parando servidor Rails (PID: $PID)...${NC}"
    kill -9 $PID 2>/dev/null
    rm -f tmp/pids/server.pid
    echo -e "${GREEN}✅ Servidor Rails parado com sucesso${NC}"
  else
    echo -e "${YELLOW}ℹ️ Nenhum servidor em execução (PID não encontrado)${NC}"
  fi
}

# Função para iniciar o servidor em uma porta específica
start_server() {
  PORT=${1:-3001}
  
  if [ -f tmp/pids/server.pid ]; then
    echo -e "${YELLOW}⚠️ Servidor já em execução. Parando primeiro...${NC}"
    stop_server
    sleep 2
  fi
  
  echo -e "${GREEN}🚀 Iniciando servidor Rails na porta $PORT...${NC}"
  bin/rails server -p $PORT -b '0.0.0.0' -d
  sleep 2
  
  if [ -f tmp/pids/server.pid ]; then
    PID=$(cat tmp/pids/server.pid)
    echo -e "${GREEN}✅ Servidor Rails iniciado com sucesso (PID: $PID)${NC}"
    echo -e "${GREEN}🌐 Acesse: http://localhost:$PORT${NC}"
  else
    echo -e "${RED}❌ Falha ao iniciar o servidor Rails${NC}"
  fi
}

# Função para reiniciar o servidor
restart_server() {
  PORT=${1:-3001}
  stop_server
  sleep 2
  start_server $PORT
}

# Função para mostrar o uso do script
show_usage() {
  echo -e "${YELLOW}Uso: $0 {start|stop|restart|status|custom} [porta]${NC}"
  echo "  start [porta]   - Inicia o servidor na porta especificada (padrão: 3001)"
  echo "  stop            - Para o servidor"
  echo "  restart [porta] - Reinicia o servidor na porta especificada (padrão: 3001)"
  echo "  status          - Verifica o status do servidor"
  echo "  custom          - Modo customizado para rodar servidor com opções adicionais"
  echo ""
  echo "Exemplos:"
  echo "  $0 start 3001   - Inicia o servidor na porta 3001"
  echo "  $0 restart 3002 - Reinicia o servidor na porta 3002"
  echo "  $0 custom       - Executa no modo interativo"
}

# Modo customizado interativo
custom_mode() {
  echo -e "${YELLOW}🛠️ Modo customizado para servidor Rails${NC}"
  echo "Escolha a operação:"
  echo "1) Iniciar servidor"
  echo "2) Parar servidor"
  echo "3) Reiniciar servidor"
  echo "4) Verificar status"
  echo "5) Voltar"
  
  read -p "Opção: " option
  
  case $option in
    1)
      read -p "Porta (padrão: 3001): " custom_port
      custom_port=${custom_port:-3001}
      start_server $custom_port
      ;;
    2)
      stop_server
      ;;
    3)
      read -p "Porta (padrão: 3001): " custom_port
      custom_port=${custom_port:-3001}
      restart_server $custom_port
      ;;
    4)
      check_server
      ;;
    5)
      return
      ;;
    *)
      echo -e "${RED}❌ Opção inválida${NC}"
      ;;
  esac
}

# Principal
case "$1" in
  start)
    start_server ${2:-3001}
    ;;
  stop)
    stop_server
    ;;
  restart)
    restart_server ${2:-3001}
    ;;
  status)
    check_server
    ;;
  custom)
    custom_mode
    ;;
  *)
    show_usage
    exit 1
    ;;
esac

exit 0
