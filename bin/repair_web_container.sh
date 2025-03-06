#!/bin/bash

# Script para reparar problemas comuns no container web

echo "🔧 Iniciando reparo do container web..."

# Verificar se o container web existe
if ! docker ps -a | grep -q "genius360_web"; then
    echo "❌ Container web não encontrado!"
    exit 1
fi

# Parar o container
echo "🛑 Parando o container web..."
docker stop genius360_web

# Verificar se existe o Gemfile no projeto
if [ ! -f "Gemfile" ]; then
    echo "⚠️ Gemfile não encontrado no diretório atual."
    echo "Verificando diretórios do projeto..."
    
    # Procurar o Gemfile em subdiretórios comuns
    GEMFILE_PATH=$(find . -name "Gemfile" -not -path "*/vendor/*" -not -path "*/tmp/*" | head -1)
    
    if [ -z "$GEMFILE_PATH" ]; then
        echo "❌ Não foi possível encontrar o Gemfile no projeto."
        echo "Por favor, verifique se você está no diretório correto do projeto Rails."
        exit 1
    else
        echo "✅ Gemfile encontrado em: $GEMFILE_PATH"
        RAILS_ROOT=$(dirname "$GEMFILE_PATH")
        
        echo "🔧 Ajustando docker-compose.yml para usar o diretório correto..."
        # Criar backup do docker-compose.yml
        cp docker-compose.yml docker-compose.yml.bak
        
        # Atualizar o volume no docker-compose.yml
        sed -i "s|\.:/app|\./${RAILS_ROOT#./}:/app|g" docker-compose.yml
        
        echo "✅ docker-compose.yml ajustado. Backup salvo como docker-compose.yml.bak"
    fi
fi

# Remover o container para forçar uma recriação limpa
echo "🧹 Removendo o container web para recriação..."
docker rm genius360_web

# Criar diretórios necessários
echo "📁 Criando diretórios necessários..."
mkdir -p tmp/pids log vendor/bundle
chmod -R 777 tmp log vendor/bundle

# Recriar o container
echo "🚀 Recriando o container web..."
docker-compose up -d web

# Verificar status
echo "⏳ Aguardando inicialização..."
sleep 10

if docker ps | grep -q "genius360_web.*Up"; then
    echo "✅ Container web reiniciado com sucesso!"
    echo "💡 Dica: execute 'make shell' para abrir um terminal no container."
else
    echo "❌ Falha ao reiniciar o container web."
    echo "📋 Logs do container:"
    docker logs genius360_web
    
    echo "🔍 Verificando problema específico..."
    if docker logs genius360_web | grep -q "Could not locate Gemfile"; then
        echo "🔧 Tentando resolver problema do Gemfile..."
        echo "📝 Gerando um Gemfile básico temporário para testes..."
        
        cat > Gemfile <<EOF
source 'https://rubygems.org'
gem 'rails', '~> 6.1'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.0'
EOF
        
        echo "🔄 Tentando novamente com o Gemfile temporário..."
        docker-compose restart web
        sleep 10
        
        if docker ps | grep -q "genius360_web.*Up"; then
            echo "✅ Container web iniciado com Gemfile temporário!"
            echo "⚠️ ATENÇÃO: Este Gemfile é apenas temporário. Por favor, restaure o Gemfile original."
        else
            echo "❌ Ainda há problemas com o container web."
            echo "Por favor, verifique as configurações do Docker e do projeto."
        fi
    fi
fi

echo "✨ Processo de reparo concluído."
