#!/bin/bash

# Script para corrigir problemas de permissão em diretórios específicos
# Uso: fix_permissions.sh [diretório_base]

BASE_DIR=${1:-.}
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "🔧 Corrigindo permissões de arquivos..."
echo "📂 Diretório base: $BASE_DIR"
echo "👤 UID: $USER_ID, GID: $GROUP_ID"

# Função para corrigir permissões com sudo
fix_with_sudo() {
    echo "⚠️ Tentando com sudo (pode solicitar sua senha)..."
    if [ -d "$1" ]; then
        sudo chown -R $USER_ID:$GROUP_ID "$1" && echo "✅ Permissões corrigidas: $1" || echo "❌ Falha ao corrigir: $1"
        
        # Definir permissões específicas para diretórios e arquivos
        sudo find "$1" -type d -exec chmod 755 {} \; 2>/dev/null || true
        sudo find "$1" -type f -exec chmod 644 {} \; 2>/dev/null || true
    else
        echo "⚠️ Diretório não encontrado: $1"
    fi
}

# Função para tentar corrigir permissões sem sudo
attempt_fix() {
    local dir="$1"
    echo "🔍 Verificando permissões para $dir..."
    
    if [ -d "$dir" ]; then
        # Tenta correção sem sudo primeiro
        chown -R $USER_ID:$GROUP_ID "$dir" 2>/dev/null && \
            echo "✅ Permissões corrigidas: $dir" || \
            fix_with_sudo "$dir"
    else
        echo "⚠️ Diretório não encontrado: $dir"
    fi
}

# Diretórios importantes do Rails
DIRS_TO_FIX=(
    "$BASE_DIR/tmp"
    "$BASE_DIR/log"
    "$BASE_DIR/storage"
    "$BASE_DIR/public/assets"
    "$BASE_DIR/public/uploads"
    "$BASE_DIR/tmp/pids"
    "$BASE_DIR/tmp/cache"
    "$BASE_DIR/tmp/miniprofiler"
)

# Criar diretórios se não existirem
for dir in "${DIRS_TO_FIX[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "📁 Criando diretório: $dir"
        mkdir -p "$dir" 2>/dev/null || sudo mkdir -p "$dir"
    fi
done

# Processando cada diretório para corrigir permissões
for dir in "${DIRS_TO_FIX[@]}"; do
    attempt_fix "$dir"
done

# Remover arquivos problemáticos específicos
echo "🧹 Removendo arquivos problemáticos conhecidos..."

# Remover arquivos pid
if [ -f "$BASE_DIR/tmp/pids/server.pid" ]; then
    rm -f "$BASE_DIR/tmp/pids/server.pid" 2>/dev/null || sudo rm -f "$BASE_DIR/tmp/pids/server.pid"
    echo "✅ Arquivo PID removido"
fi

# Limpar miniprofiler
if [ -d "$BASE_DIR/tmp/miniprofiler" ]; then
    echo "🧹 Limpando arquivos do miniprofiler..."
    rm -rf "$BASE_DIR/tmp/miniprofiler/*" 2>/dev/null || sudo rm -rf "$BASE_DIR/tmp/miniprofiler/*"
    echo "✅ Miniprofiler limpo"
fi

echo "✅ Processo de correção de permissões concluído!"
