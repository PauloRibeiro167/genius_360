#!/bin/bash

# Script para desativar temporariamente o rack-mini-profiler
# Uso: disable_miniprofiler.sh

GEMFILE="Gemfile"
GEMFILE_LOCK="Gemfile.lock"
CONFIG_DIR="config/initializers"
CONFIG_FILE="$CONFIG_DIR/rack_mini_profiler.rb"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

echo "🔧 Desabilitando temporariamente o rack-mini-profiler..."

# Verificar se estamos no diretório de um projeto Rails
if [ ! -f "$GEMFILE" ] || [ ! -d "$CONFIG_DIR" ]; then
    echo "❌ Este não parece ser um diretório de projeto Rails válido!"
    echo "Por favor, execute este script a partir do diretório raiz do projeto."
    exit 1
fi

# Função para fazer backup de um arquivo
backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1$BACKUP_SUFFIX"
        echo "📦 Backup criado: $1$BACKUP_SUFFIX"
    fi
}

# 1. Criar arquivo de inicialização para desabilitar o mini-profiler
create_initializer() {
    mkdir -p "$CONFIG_DIR"
    
    if [ -f "$CONFIG_FILE" ]; then
        backup_file "$CONFIG_FILE"
    fi
    
    cat > "$CONFIG_FILE" << 'EOF'
# Desabilitando temporariamente o rack-mini-profiler para resolver problemas
# Criado automaticamente por script de manutenção

if defined?(Rack::MiniProfiler)
  Rack::MiniProfiler.config.enabled = false
  
  # Caso acima não funcione, tentar método alternativo
  Rails.application.middleware.delete(Rack::MiniProfiler) if Rails.application.middleware.include?(Rack::MiniProfiler)
end
EOF
    
    echo "✅ Criado inicializador para desabilitar rack-mini-profiler"
}

# 2. Limpar o diretório tmp/miniprofiler
clean_tmp_files() {
    if [ -d "tmp/miniprofiler" ]; then
        echo "🧹 Limpando arquivos temporários do mini-profiler..."
        rm -rf tmp/miniprofiler/* 2>/dev/null || sudo rm -rf tmp/miniprofiler/* 2>/dev/null
        echo "✅ Diretório tmp/miniprofiler limpo"
    else
        echo "📂 Diretório tmp/miniprofiler não encontrado"
    fi
}

# Executar as ações
create_initializer
clean_tmp_files

echo "✅ O rack-mini-profiler foi desabilitado com sucesso!"
echo "🔄 Reinicie o servidor Rails para aplicar as alterações."
echo "📝 Para reativar, remova ou edite o arquivo: $CONFIG_FILE"
