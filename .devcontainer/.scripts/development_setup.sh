#!/bin/bash

echo "🛠️ Configurando ambiente de desenvolvimento do Genius360..."

# Verifica se os containers estão rodando
if ! docker-compose ps | grep -q "Up"; then
  echo "📦 Iniciando containers..."
  docker-compose up -d
  sleep 5
else
  echo "✅ Containers já estão em execução"
fi

# Prepara o banco de dados
echo "🗄️ Configurando banco de dados..."
docker-compose exec -T web rails db:create db:migrate db:seed 2>/dev/null || {
  echo "⚠️ Banco de dados já existe, executando apenas migrações..."
  docker-compose exec -T web rails db:migrate
}

# Instala dependências JavaScript (se estiver usando)
echo "📦 Instalando dependências JavaScript..."
docker-compose exec -T web yarn install 2>/dev/null || echo "ℹ️ Sem yarn no projeto"

echo "📝 Configurando git hooks..."
cat > .git/hooks/pre-commit <<EOL
#!/bin/bash
echo "🧪 Executando testes antes do commit..."
docker-compose exec -T web rails test
if [ \$? -ne 0 ]; then
  echo "❌ Testes falharam. Commit abortado."
  exit 1
fi
exit 0
EOL
chmod +x .git/hooks/pre-commit 2>/dev/null || echo "⚠️ Não foi possível configurar git hooks (diretório .git não encontrado)"

echo "🔍 Verificando status final..."
bash scripts/check_status.sh

echo "✨ Ambiente de desenvolvimento configurado com sucesso!"
echo "🚀 Para iniciar o desenvolvimento, use: make exec"
echo "🌐 Acesse a aplicação em: http://localhost:3000"
