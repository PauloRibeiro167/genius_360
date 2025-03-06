#!/bin/bash

# Este script permite gerenciar o servidor Rails dentro do container Docker
# Ele repassa comandos para o script manage_server.sh dentro do container

# Verifique se o container web está em execução
if ! docker-compose ps | grep -q "web.*Up"; then
  echo "⚠️ O container web não está em execução. Iniciando..."
  docker-compose up -d web
  sleep 5
fi

# Função para exibir uso
show_usage() {
  echo "Uso: $0 {start|stop|restart|status|custom} [porta]"
  echo ""
  echo "Gerencia o servidor Rails dentro do container Docker:"
  echo "  start [porta]   - Inicia o servidor na porta especificada (padrão: 3001)"
  echo "  stop            - Para o servidor"
  echo "  restart [porta] - Reinicia o servidor na porta especificada (padrão: 3001)"
  echo "  status          - Verifica o status do servidor"
  echo "  custom          - Modo customizado para rodar servidor com opções adicionais"
}

# Verificar se scripts/manage_server.sh existe no container
docker-compose exec -T web bash -c "if [ ! -f /app/scripts/manage_server.sh ]; then mkdir -p /app/scripts; exit 1; fi" >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "🔄 Script de gerenciamento não encontrado no container. Copiando..."
  docker-compose cp scripts/manage_server.sh web:/app/scripts/
  docker-compose exec -T web bash -c "chmod +x /app/scripts/manage_server.sh"
fi

# Repassar argumentos para o script dentro do container
if [ -z "$1" ]; then
  show_usage
else
  echo "🚀 Executando comando no container web..."
  docker-compose exec web bash -c "cd /app && scripts/manage_server.sh $1 $2"
fi
