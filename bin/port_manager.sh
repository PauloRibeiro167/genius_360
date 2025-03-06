#!/bin/bash

# Define uma faixa de portas preferidas para o servidor Rails
PREFERRED_PORTS=(3000 3001 3002 3003 3004 3005)

# Função para verificar se uma porta está disponível
check_port() {
  local port=$1
  if lsof -i :"$port" &>/dev/null; then
    return 1  # Porta em uso
  else
    return 0  # Porta livre
  fi
}

# Função para liberar uma porta
free_port() {
  local port=$1
  local force=$2
  
  echo "🔍 Verificando processos na porta $port..."
  
  # Obter PIDs usando a porta
  local pids=$(lsof -t -i:"$port" 2>/dev/null)
  
  if [ -z "$pids" ]; then
    echo "✅ Nenhum processo encontrado usando a porta $port"
    return 0
  fi
  
  echo "⚠️ Processos encontrados usando a porta $port: $pids"
  
  if [ "$force" = "true" ] || [[ "$REPLY" =~ ^[Ss]$ ]]; then
    echo "🛑 Encerrando processos..."
    
    for pid in $pids; do
      echo "   Encerrando PID $pid..."
      kill -9 "$pid" 2>/dev/null
    done
    
    # Verificar novamente após tentar encerrar
    if check_port "$port"; then
      echo "✅ Porta $port liberada com sucesso!"
      return 0
    else
      echo "❌ Não foi possível liberar a porta $port completamente."
      return 1
    fi
  else
    echo "❓ Operação cancelada pelo usuário."
    return 1
  fi
}

# Função para encontrar uma porta disponível
find_available_port() {
  local start_port=${1:-3000}
  local end_port=${2:-3010}
  
  echo "🔍 Procurando por portas disponíveis entre $start_port e $end_port..."
  
  for ((port=start_port; port<=end_port; port++)); do
    if check_port "$port"; then
      echo "✅ Porta $port está disponível!"
      echo "$port"
      return 0
    fi
  done
  
  echo "❌ Nenhuma porta disponível encontrada no intervalo $start_port-$end_port."
  return 1
}

# Função para iniciar o servidor na porta especificada
start_server() {
  local port=$1
  
  echo "🚀 Iniciando servidor Rails na porta $port..."
  
  # Verificar se o container web existe e está rodando
  if ! docker-compose ps web | grep -q "Up"; then
    echo "⚠️ O container web não está rodando. Iniciando serviços..."
    docker-compose up -d
  fi
  
  # Remover qualquer arquivo PID existente
  docker-compose exec web bash -c "rm -f /app/tmp/pids/server.pid" || true
  
  # Iniciar o servidor Rails
  docker-compose exec web bash -c "cd /app && bundle exec rails s -p $port -b '0.0.0.0' -d"
  
  if [ $? -eq 0 ]; then
    echo "✅ Servidor Rails iniciado na porta $port"
    echo "🌐 Acesse: http://localhost:$port"
    return 0
  else
    echo "❌ Falha ao iniciar o servidor Rails."
    return 1
  fi
}

# Função principal
main() {
  local requested_port=${1:-3000}
  local force=${2:-false}
  
  # Verificar porta solicitada
  if check_port "$requested_port"; then
    echo "✅ Porta $requested_port está disponível!"
    start_server "$requested_port"
    return $?
  fi
  
  echo "⚠️ Porta $requested_port já está em uso."
  
  if [ "$force" != "true" ]; then
    read -p "Deseja tentar liberar a porta $requested_port? (s/n): " -n 1 -r
    echo
  fi
  
  if [ "$force" = "true" ] || [[ "$REPLY" =~ ^[Ss]$ ]]; then
    if free_port "$requested_port" "true"; then
      start_server "$requested_port"
      return $?
    fi
  fi
  
  # Se não conseguir liberar a porta solicitada, procurar por uma alternativa
  echo "🔄 Procurando por uma porta alternativa..."
  
  # Tente as portas preferidas primeiro
  for port in "${PREFERRED_PORTS[@]}"; do
    if [ "$port" != "$requested_port" ] && check_port "$port"; then
      echo "🌟 Encontrada porta alternativa: $port"
      read -p "Deseja iniciar o servidor na porta $port? (s/n): " -n 1 -r
      echo
      
      if [[ "$REPLY" =~ ^[Ss]$ ]]; then
        start_server "$port"
        return $?
      fi
    fi
  done
  
  # Se nenhuma porta preferida estiver disponível, procure qualquer porta disponível
  available_port=$(find_available_port 3000 3020)
  
  if [ -n "$available_port" ]; then
    read -p "Deseja iniciar o servidor na porta $available_port? (s/n): " -n 1 -r
    echo
    
    if [[ "$REPLY" =~ ^[Ss]$ ]]; then
      start_server "$available_port"
      return $?
    fi
  fi
  
  echo "❌ Falha ao encontrar ou liberar uma porta adequada."
  return 1
}

# Execute a função principal com os argumentos fornecidos
main "$@"
exit $?
