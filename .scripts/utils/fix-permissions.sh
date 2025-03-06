#!/bin/bash

echo "🔧 Corrigindo permissões dos scripts..."

# Corrige o próprio script setup-scripts.sh
chmod +x setup-scripts.sh

# Mostra o resultado
ls -la setup-scripts.sh

echo "✅ Permissões corrigidas para setup-scripts.sh"
echo "👉 Agora você pode executar: ./setup-scripts.sh"
