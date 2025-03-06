#!/bin/bash

# Tornar os scripts executáveis
echo "🔧 Tornando scripts executáveis..."

# Lista de scripts a serem verificados
DIR_SCRIPTS=(
  # Scripts Docker
  "scripts/docker/docker-rails-server.sh"
  "scripts/docker/Dockerfile"
  
  # Scripts de Servidor
  "scripts/server/rails-server.sh"
  "scripts/server/start.sh"
  "scripts/server/start-and-shell.sh"
  "scripts/server/fix_server.sh"
  
  # Scripts de Utilidades
  "scripts/utils/chmod-scripts.sh"
  "scripts/utils/clear-makefile.sh"
  "scripts/utils/fix-makefile.sh"
  "scripts/utils/fix-permissions.sh"
  "scripts/utils/initialize.sh"
  "scripts/utils/inside-fix.sh"
  "scripts/utils/setup-scripts.sh"
  
  # Scripts existentes
  "scripts/manage_server.sh"
  "scripts/check_status.sh"
)

# Verifica e cria diretórios se necessário
for SCRIPT in "${DIR_SCRIPTS[@]}"; do
  DIR=$(dirname "$SCRIPT")
  if [ ! -d "$DIR" ]; then
    echo "📁 Criando diretório '$DIR'..."
    mkdir -p "$DIR"
  fi
done

# Move e torna executável cada script
for SCRIPT in "${DIR_SCRIPTS[@]}"; do
  FILENAME=$(basename "$SCRIPT")
  SOURCE_FILE="${FILENAME}"
  
  # Se o arquivo original existe, move para o novo local
  if [ -f "$SOURCE_FILE" ]; then
    echo "🚚 Movendo '$SOURCE_FILE' para '$SCRIPT'..."
    mv "$SOURCE_FILE" "$SCRIPT"
    echo "✅ Tornando '$SCRIPT' executável..."
    chmod +x "$SCRIPT"
  elif [ -f "$SCRIPT" ]; then
    echo "✅ Tornando '$SCRIPT' executável..."
    chmod +x "$SCRIPT"
  else
    echo "⚠️ Script '$SCRIPT' não encontrado. Pulando..."
  fi
done

echo "✅ Scripts verificados, movidos e atualizados"
