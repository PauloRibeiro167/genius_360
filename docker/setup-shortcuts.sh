#!/bin/bash

# Script para configurar atalhos úteis na raiz do container
echo "Configurando atalhos para facilitar desenvolvimento..."

# Criar atalho para Rails na raiz
cat > /usr/local/bin/rails << 'EOF'
#!/bin/bash
if [ -f /app/bin/rails ]; then
  cd /app && bin/rails "$@"
else
  echo "Erro: Aplicação Rails não encontrada em /app"
  echo "Por favor, use 'cd /app' primeiro"
  exit 1
fi
EOF
chmod +x /usr/local/bin/rails

# Criar atalho para bin/dev na raiz
cat > /usr/local/bin/dev << 'EOF'
#!/bin/bash
if [ -f /app/bin/dev ]; then
  cd /app && bin/dev "$@"
else
  echo "Erro: Script dev não encontrado em /app/bin"
  echo "Por favor, use 'cd /app' primeiro"
  exit 1
fi
EOF
chmod +x /usr/local/bin/dev

# Criar um atalho para bundle
cat > /usr/local/bin/bundle << 'EOF'
#!/bin/bash
if [ -f /app/Gemfile ]; then
  cd /app && /usr/local/bundle/bin/bundle "$@"
else
  echo "Erro: Gemfile não encontrado em /app"
  echo "Por favor, use 'cd /app' primeiro"
  exit 1
fi
EOF
chmod +x /usr/local/bin/bundle

# Criar um .bashrc personalizado para melhorar a experiência
cat > /root/.bashrc << 'EOF'
# Configurações personalizadas para o ambiente Genius360
PS1='\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] $ '

# Alias úteis
alias ll='ls -la'
alias app='cd /app'
alias server='cd /app && rails s -b 0.0.0.0'
alias console='cd /app && rails c'
alias routes='cd /app && rails routes'
alias migrate='cd /app && rails db:migrate'

# Mensagem de boas-vindas
echo "======================================================"
echo "       GENIUS360 - AMBIENTE DE DESENVOLVIMENTO        "
echo "======================================================"
echo ""
echo "Comandos úteis:"
echo "  app      - Navega para o diretório da aplicação"
echo "  server   - Inicia o servidor Rails"
echo "  console  - Inicia o console Rails"
echo "  dev      - Inicia o ambiente de desenvolvimento completo"
echo ""

# Ir direto para o diretório da aplicação
cd /app
EOF

echo "Atalhos configurados com sucesso!"
