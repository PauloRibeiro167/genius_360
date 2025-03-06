#!/bin/bash

# Script para gerenciar o servidor Rails dentro do container Docker
# Uso: ./rails_server_manager.sh [start|stop|restart|status|fix] [port]

# Cores para melhor legibilidade
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Diretório da aplicação
APP_DIR="/app"
PID_FILE="${APP_DIR}/tmp/pids/server.pid"
DEFAULT_PORT=3001

# Função para exibir o uso do script
usage() {
  echo -e "${YELLOW}Uso: $0 [comando] [porta]${RESET}"
  echo "Comandos:"
  echo "  start   - Inicia o servidor Rails"
  echo "  stop    - Para o servidor Rails"
  echo "  restart - Reinicia o servidor Rails"
  echo "  status  - Verifica o status do servidor Rails"
  echo "  fix     - Corrige problemas do servidor (remove PID, etc)"
  echo "  clean   - Limpa arquivos temporários"
  echo "Exemplos:"
  echo "  $0 start 3002  - Inicia o servidor na porta 3002"
  echo "  $0 restart     - Reinicia o servidor na porta padrão (${DEFAULT_PORT})"
}

# Função para verificar se o servidor está rodando
is_server_running() {
  if [ -f "$PID_FILE" ]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" > /dev/null; then
      return 0  # servidor está rodando
    fi
  fi
  # Verificar se há processos Rails/Puma em execução
  if pgrep -f "rails server|puma" > /dev/null; then
    return 0  # servidor está rodando
  fi
  return 1  # servidor não está rodando
}

# Função para parar o servidor
stop_server() {
  echo -e "${BLUE}🛑 Parando o servidor Rails...${RESET}"
  
  if [ -f "$PID_FILE" ]; then
    local pid=$(cat "$PID_FILE")
    if ps -p "$pid" > /dev/null; then
      echo -e "${YELLOW}📝 Enviando sinal TERM para o processo $pid...${RESET}"
      kill -15 "$pid" 2>/dev/null || true
      
      # Aguardar até 5 segundos para o servidor parar
      for i in {1..10}; do
        if ! ps -p "$pid" > /dev/null; then
          break
        fi
        echo -n "."
        sleep 0.5
      done
      echo ""
      
      # Se ainda estiver rodando, usar KILL
      if ps -p "$pid" > /dev/null; then
        echo -e "${RED}⚠️ Servidor não respondeu, forçando encerramento...${RESET}"
        kill -9 "$pid" 2>/dev/null || true
      fi
    fi
    rm -f "$PID_FILE"
    echo -e "${GREEN}✅ Arquivo PID removido${RESET}"
  else
    echo -e "${YELLOW}⚠️ Arquivo PID não encontrado${RESET}"
  fi
  
  # Verificar por processos Puma/Rails e parar
  local puma_pids=$(pgrep -f "rails server|puma" 2>/dev/null)
  if [ -n "$puma_pids" ]; then
    echo -e "${YELLOW}📝 Encerrando processos Puma/Rails adicionais: $puma_pids${RESET}"
    pkill -f "rails server|puma" 2>/dev/null || true
    sleep 1
    
    # Verificar novamente e usar força se necessário
    puma_pids=$(pgrep -f "rails server|puma" 2>/dev/null)
    if [ -n "$puma_pids" ]; then
      echo -e "${RED}⚠️ Forçando encerramento de processos restantes...${RESET}"
      pkill -9 -f "rails server|puma" 2>/dev/null || true
    fi
  fi
  
  echo -e "${GREEN}✅ Servidor Rails parado${RESET}"
}

# Função para iniciar o servidor
start_server() {
  local port="${1:-$DEFAULT_PORT}"
  
  echo -e "${BLUE}🚀 Iniciando servidor Rails na porta $port...${RESET}"
  
  # Verificar se o servidor já está rodando
  if is_server_running; then
    echo -e "${YELLOW}⚠️ O servidor já está rodando!${RESET}"
    echo -e "${YELLOW}⚠️ Use '$0 restart $port' para reiniciar${RESET}"
    return 1
  fi
  
  # Verificar se o diretório tmp/pids existe
  mkdir -p "${APP_DIR}/tmp/pids"
  
  # Iniciar o servidor em segundo plano
  cd "$APP_DIR"
  echo -e "${BLUE}📝 Executando: bundle exec rails server -p $port -b 0.0.0.0 -d${RESET}"
  bundle exec rails server -p "$port" -b "0.0.0.0" -d
  
  # Verificar se o servidor iniciou
  sleep 2
  if is_server_running; then
    echo -e "${GREEN}✅ Servidor Rails iniciado na porta $port${RESET}"
    echo -e "${GREEN}🌐 Acesse: http://localhost:$port${RESET}"
    return 0
  else
    echo -e "${RED}❌ Falha ao iniciar o servidor Rails${RESET}"
    echo -e "${YELLOW}📝 Verificando logs:${RESET}"
    tail -n 20 "${APP_DIR}/log/development.log"
    return 1
  fi
}

# Função para limpar arquivos temporários
clean_temp_files() {
  echo -e "${BLUE}🧹 Limpando arquivos temporários...${RESET}"
  
  rm -rf "${APP_DIR}/tmp/cache" "${APP_DIR}/tmp/pids" "${APP_DIR}/tmp/sockets"
  mkdir -p "${APP_DIR}/tmp/cache" "${APP_DIR}/tmp/pids" "${APP_DIR}/tmp/sockets"
  
  echo -e "${GREEN}✅ Arquivos temporários limpos${RESET}"
}

# Função para corrigir problemas do servidor
fix_server() {
  echo -e "${BLUE}🔧 Corrigindo problemas do servidor...${RESET}"
  
  # Remover arquivo PID
  if [ -f "$PID_FILE" ]; then
    rm -f "$PID_FILE"
    echo -e "${GREEN}✅ Arquivo PID removido${RESET}"
  else
    echo -e "${YELLOW}📝 Arquivo PID não encontrado${RESET}"
  fi
  
  # Verificar e encerrar processos Rails/Puma
  local puma_pids=$(pgrep -f "rails server|puma" 2>/dev/null)
  if [ -n "$puma_pids" ]; then
    echo -e "${YELLOW}📝 Encerrando processos Puma/Rails: $puma_pids${RESET}"
    pkill -f "rails server|puma" 2>/dev/null || true
    sleep 1
    
    # Verificar novamente e usar força se necessário
    puma_pids=$(pgrep -f "rails server|puma" 2>/dev/null)
    if [ -n "$puma_pids" ]; then
      echo -e "${RED}⚠️ Forçando encerramento de processos restantes...${RESET}"
      pkill -9 -f "rails server|puma" 2>/dev/null || true
    fi
  else
    echo -e "${GREEN}✅ Nenhum processo Rails/Puma encontrado${RESET}"
  fi
  
  echo -e "${GREEN}✅ Correção concluída${RESET}"
}

# Função para verificar o status do servidor
check_status() {
  echo -e "${BLUE}🔍 Verificando status do servidor Rails...${RESET}"
  
  if [ -f "$PID_FILE" ]; then
    local pid=$(cat "$PID_FILE")
    echo -e "${YELLOW}📝 Arquivo PID encontrado: $pid${RESET}"
    
    if ps -p "$pid" > /dev/null; then
      echo -e "${GREEN}✅ Servidor está em execução (PID: $pid)${RESET}"
    else
      echo -e "${RED}❌ Arquivo PID existe, mas o processo não está rodando${RESET}"
    fi
  else
    echo -e "${YELLOW}📝 Arquivo PID não encontrado${RESET}"
  fi
  
  # Verificar por processos Rails/Puma
  local puma_pids=$(pgrep -f "rails server|puma" 2>/dev/null)
  if [ -n "$puma_pids" ]; then
    echo -e "${GREEN}✅ Processos Rails/Puma em execução: $puma_pids${RESET}"
    ps -p $puma_pids -o pid,ppid,cmd
  else
    echo -e "${RED}❌ Nenhum processo Rails/Puma encontrado${RESET}"
  fi
  
  # Verificar portas em uso
  echo -e "${YELLOW}📝 Verificando portas em uso:${RESET}"
  netstat -tulpn 2>/dev/null | grep -E ':(3000|3001|3002)' || echo -e "${YELLOW}📝 Nenhuma das portas 3000/3001/3002 em uso${RESET}"
}

# Verificar se um comando foi fornecido
if [ -z "$1" ]; then
  usage
  exit 1
fi

# Processar o comando
case "$1" in
  start)
    start_server "$2"
    ;;
  stop)
    stop_server
    ;;
  restart)
    stop_server
    sleep 2
    start_server "$2"
    ;;
  status)
    check_status
    ;;
  fix)
    fix_server
    ;;
  clean)
    clean_temp_files
    ;;
  *)
    echo -e "${RED}❌ Comando desconhecido: $1${RESET}"
    usage
    exit 1
    ;;
esac

exit 0
