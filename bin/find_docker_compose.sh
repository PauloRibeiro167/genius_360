#!/bin/bash

# Script para encontrar o arquivo docker-compose.yml

# Locais possíveis para o arquivo docker-compose.yml
POSSIBLE_LOCATIONS=(
  "docker-compose.yml"
  ".docker/docker-compose.yml"
  "docker/docker-compose.yml"
  "config/docker-compose.yml"
)

# Verifica cada local possível
for location in "${POSSIBLE_LOCATIONS[@]}"; do
  if [ -f "$location" ]; then
    echo "$location"
    exit 0
  fi
done

# Se chegou aqui, não encontrou o arquivo
echo "Erro: Não foi possível encontrar o arquivo docker-compose.yml"
echo "Por favor, especifique o caminho correto para o arquivo docker-compose.yml no Makefile."
exit 1
