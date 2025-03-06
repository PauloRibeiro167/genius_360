#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Corrigindo problemas de indentação no Makefile...${NC}"

# Verificar se o Makefile existe
if [ ! -f "Makefile" ]; then
    echo -e "${RED}❌ Arquivo Makefile não encontrado!${NC}"
    exit 1
fi

# Criar backup do Makefile original
cp Makefile Makefile.bak
echo -e "${GREEN}✅ Backup criado como Makefile.bak${NC}"

# Corrigir indentação - substituir espaços por tabs no início das linhas de comando
# Esta é a parte crítica: substituímos espaços no início das linhas por uma tabulação
# mas apenas para linhas que são comandos (após uma linha de regra)

echo -e "${BLUE}🔧 Aplicando correções de indentação...${NC}"

# Primeiro verificar se há problemas na linha 365
LINHA_365=$(sed -n '365p' Makefile)
echo -e "${YELLOW}Linha 365:${NC} $LINHA_365"

# Criar um novo Makefile com as correções
awk '
BEGIN { in_rule = 0; }
{
    # Se a linha define uma regra (termina com :)
    if ($0 ~ /^[^[:space:]#][^:]*:/) {
        in_rule = 1;
        print;
        next;
    }
    
    # Se a linha está em branco ou é um comentário
    if ($0 ~ /^[[:space:]]*$/ || $0 ~ /^[[:space:]]*#/) {
        print;
        in_rule = 0;
        next;
    }
    
    # Se a linha é um comando (começa com espaço ou tab) dentro de uma regra
    if (in_rule && $0 ~ /^[[:space:]]/) {
        # Substituir espaços iniciais por um tab
        sub(/^[[:space:]]+/, "\t");
        print;
        next;
    }
    
    # Para qualquer outra linha
    in_rule = 0;
    print;
}
' Makefile.bak > Makefile.fixed

# Substituir o Makefile original pelo corrigido
mv Makefile.fixed Makefile
chmod 644 Makefile

echo -e "${GREEN}✅ Makefile corrigido!${NC}"
echo -e "${BLUE}💡 Tente executar seus comandos make novamente.${NC}"
echo -e "${YELLOW}⚠️ Se o problema persistir, pode ser necessário editar manualmente o Makefile com um editor que mostra a diferença entre espaços e tabulações.${NC}"
