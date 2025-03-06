#!/bin/bash

# Script para resolver problemas com o bundler no container
echo "🔧 Iniciando reparos no bundler..."

# Verificando se o container está em execução
if ! docker ps | grep -q genius360_web; then
  echo "🚀 Iniciando container web..."
  docker-compose up -d web
  sleep 5
fi

# Parando o container se estiver em reinicialização
if docker ps | grep -q "genius360_web.*Restarting"; then
  echo "⚠️ Container em loop de reinicialização. Parando..."
  docker stop genius360_web
  sleep 2
fi

echo "🧹 Limpando cache e instalando gems..."
docker start genius360_web || true
sleep 3

# Comandos para resolver problemas com o bundler
docker exec -i genius360_web bash <<'EOF'
cd /app
echo "📦 Removendo Gemfile.lock e reinstalando dependências..."
rm -f Gemfile.lock
bundle config set --local without 'development test'
bundle install --jobs=4
echo "🧪 Verificando instalação..."
bundle check
EOF

# Verificar se o container está funcionando corretamente
if [ $? -eq 0 ]; then
  echo "✅ Bundler reparado com sucesso!"
  echo "🔄 Reiniciando container web..."
  docker restart genius360_web
else
  echo "❌ Falha ao reparar bundler. Tentando método alternativo..."
  
  docker exec -i genius360_web bash <<'EOF'
  cd /app
  echo "📦 Removendo cache de gems..."
  rm -rf /usr/local/bundle/*
  rm -rf vendor/bundle
  bundle config set --local path 'vendor/bundle'
  bundle install --jobs=4
EOF
  
  echo "🔄 Reiniciando container web..."
  docker restart genius360_web
  sleep 5
  
  # Verificação final
  if docker ps | grep -q "genius360_web.*Up"; then
    echo "✅ Container web recuperado com sucesso!"
  else
    echo "❌ Container web ainda está com problemas."
    echo "⚠️ Verifique se a versão do Ruby no Dockerfile corresponde às gems no Gemfile."
  fi
fi
