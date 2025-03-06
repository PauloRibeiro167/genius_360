#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
  echo -e "${RED}❌ Uso: $0 <número_da_linha>${NC}"
  exit 1
fi

LINHA=$1
ARQUIVO="Makefile"

if [ ! -f "$ARQUIVO" ]; then
  echo -e "${RED}❌ Arquivo $ARQUIVO não encontrado!${NC}"
  exit 1
fi

# Verificar se a linha existe
TOTAL_LINHAS=$(wc -l < "$ARQUIVO")
if [ "$LINHA" -gt "$TOTAL_LINHAS" ]; then
  echo -e "${RED}❌ O arquivo tem apenas $TOTAL_LINHAS linhas. A linha $LINHA não existe.${NC}"
  exit 1
fi

# Exibir algumas linhas antes e depois para contexto
INICIO=$((LINHA - 3))
FIM=$((LINHA + 3))

if [ "$INICIO" -lt 1 ]; then
  INICIO=1
fi

if [ "$FIM" -gt "$TOTAL_LINHAS" ]; then
  FIM="$TOTAL_LINHAS"
fi

echo -e "${BLUE}🔍 Exibindo linhas de contexto (${INICIO}-${FIM})${NC}"
echo -e "${YELLOW}A linha problemática é a ${LINHA}:${NC}"

# Mostrar linhas com numeração
for i in $(seq "$INICIO" "$FIM"); do
  CONTEUDO=$(sed -n "${i}p" "$ARQUIVO")
  
  # Destacar a linha problemática
  if [ "$i" -eq "$LINHA" ]; then
    echo -e "${RED}$i:${NC} ${RED}${CONTEUDO}${NC}"
    
    # Mostrar visualização de caracteres especiais
    VISUALIZACAO=$(sed -n "${i}p" "$ARQUIVO" | sed 's/ /·/g' | sed 's/\t/→   /g')
    echo -e "   ${YELLOW}$VISUALIZACAO${NC} (· = espaço, → = tabulação)"
  else
    echo -e "$i: $CONTEUDO"
  fi
done

echo ""
echo -e "${BLUE}💡 Dica: No Makefile, os comandos devem começar com tabulação, não com espaços.${NC}"
