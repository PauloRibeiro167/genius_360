#!/bin/bash

MAKEFILE_PATH="$1"
if [ -z "$MAKEFILE_PATH" ]; then
    MAKEFILE_PATH="Makefile"
fi

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Verificando formatação do Makefile...${NC}"

# Verificar se o arquivo existe
if [ ! -f "$MAKEFILE_PATH" ]; then
    echo -e "${RED}❌ Arquivo $MAKEFILE_PATH não encontrado!${NC}"
    exit 1
fi

# Verificar regras com problemas de indentação
echo -e "${BLUE}🔍 Procurando por problemas de indentação...${NC}"
PROBLEMAS=$(grep -n "^[^#[:space:]\.][^:]*:" "$MAKEFILE_PATH" | while read -r linha; do
    num_linha=$(echo "$linha" | cut -d: -f1)
    proxima_linha=$((num_linha + 1))
    proxima_conteudo=$(sed -n "${proxima_linha}p" "$MAKEFILE_PATH")
    if [[ "$proxima_conteudo" =~ ^[[:space:]] && ! "$proxima_conteudo" =~ ^[[:space:]]*$ && ! "$proxima_conteudo" =~ ^[[:space:]]*# ]]; then
        # Verificar se a indentação não começa com tab
        if [[ ! "$proxima_conteudo" =~ ^$'\t' ]]; then
            echo "$num_linha:$proxima_linha:$proxima_conteudo"
        fi
    fi
done)

# Se encontrou problemas, mostrar detalhes
if [ -n "$PROBLEMAS" ]; then
    echo -e "${YELLOW}⚠️ Encontrados possíveis problemas de indentação:${NC}"
    echo "$PROBLEMAS" | while read -r problema; do
        regra=$(echo "$problema" | cut -d: -f1)
        linha=$(echo "$problema" | cut -d: -f2)
        conteudo=$(echo "$problema" | cut -d: -f3-)
        echo -e "${YELLOW}Linha $linha após regra na linha $regra:${NC}"
        echo -e "${RED}$conteudo${NC}"
        echo -e "${BLUE}Deve ser indentado com tab, não com espaços.${NC}"
        echo ""
    done
    
    echo -e "${BLUE}💡 Dica: Em um Makefile, todas as linhas de comando devem começar com um tab, não com espaços.${NC}"
    echo -e "${BLUE}   Para corrigir, edite o arquivo e substitua os espaços no início de cada linha de comando por um tab.${NC}"
    
    # Oferecer correção automática
    read -p "Deseja tentar corrigir automaticamente o Makefile? (s/n): " resposta
    if [[ "$resposta" == "s" ]]; then
        # Fazer backup do arquivo
        cp "$MAKEFILE_PATH" "${MAKEFILE_PATH}.bak"
        echo -e "${BLUE}✅ Backup criado em ${MAKEFILE_PATH}.bak${NC}"
        
        # Corrigir a indentação (converte espaços no início das linhas de comando para tab)
        awk '/^[^#[:space:]\.][^:]*:/ {print; in_rule=1; next} 
             /^[[:space:]]*$/ {in_rule=0; print; next} 
             /^[[:space:]]*#/ {print; next} 
             in_rule && /^[[:space:]]/ {gsub(/^[[:space:]]+/, "\t"); print; next} 
             {in_rule=0; print}' "${MAKEFILE_PATH}.bak" > "$MAKEFILE_PATH"
        
        echo -e "${GREEN}✅ Makefile corrigido! Teste novamente seu comando make.${NC}"
    else
        echo -e "${YELLOW}⚠️ Sem correção automática. Por favor, corrija manualmente o Makefile.${NC}"
    fi
    
    exit 1
else
    echo -e "${GREEN}✅ Nenhum problema óbvio de indentação encontrado no Makefile.${NC}"
    echo -e "${BLUE}💡 Se ainda estiver tendo problemas, verifique se há tabs escondidos ou caracteres especiais.${NC}"
fi

echo -e "${GREEN}✅ Verificação concluída!${NC}"
