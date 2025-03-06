#!/bin/bash

echo "🔧 Configurando scripts..."

# Torna os scripts executáveis
chmod +x start.sh
chmod +x fix_server.sh
chmod +x inside-fix.sh
if [ -d scripts ]; then
  chmod +x scripts/*.sh 2>/dev/null || echo "⚠️ Nenhum script encontrado no diretório scripts/"
fi

# Corrige possíveis problemas com quebras de linha
sed -i 's/\r$//' start.sh
sed -i 's/\r$//' fix_server.sh
sed -i 's/\r$//' inside-fix.sh
if [ -d scripts ]; then
  find scripts -name "*.sh" -exec sed -i 's/\r$//' {} \;
fi

echo "✅ Scripts configurados"
echo "👉 Execute 'make start' para iniciar o Genius360"
