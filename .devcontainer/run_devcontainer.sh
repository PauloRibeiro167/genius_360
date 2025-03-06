#!/bin/bash

# Script interativo para gerenciar o ambiente .devcontainer
# Autor: Sistema Genius360
# Data: 2023

# Cores para melhorar a legibilidade
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para exibir o cabeçalho
show_header() {
    clear
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${BLUE}       GENIUS360 - AMBIENTE DE DESENVOLVIMENTO      ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
}

# Função para verificar o status dos containers
check_status() {
    if docker-compose -f compose.yaml ps | grep -q "Up"; then
        echo -e "${GREEN}✓ O ambiente de desenvolvimento está em execução!${NC}"
        echo ""
        return 0
    else
        echo -e "${YELLOW}! O ambiente de desenvolvimento não está em execução.${NC}"
        echo ""
        return 1
    fi
}

# Menu principal
main_menu() {
    show_header
    check_status
    status=$?

    echo "O que você deseja fazer?"
    echo ""
    
    if [ $status -eq 0 ]; then
        echo "1) Reiniciar o ambiente"
        echo "2) Parar o ambiente"
        echo "3) Ver logs em tempo real"
        echo "4) Acessar shell do container"
        echo "5) Verificar status detalhado"
    else
        echo "1) Iniciar o ambiente"
        echo "2) Iniciar em modo interativo"
        echo "3) Reconstruir o ambiente"
        echo "4) Limpar todos os recursos"
    fi
    
    echo "0) Sair"
    echo ""
    read -p "Escolha uma opção: " choice
    
    if [ $status -eq 0 ]; then
        case $choice in
            1) restart_system ;;
            2) stop_system ;;
            3) show_logs ;;
            4) access_shell ;;
            5) detailed_status ;;
            0) exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 2; main_menu ;;
        esac
    else
        case $choice in
            1) start_system ;;
            2) start_interactive ;;
            3) rebuild_system ;;
            4) clean_system ;;
            0) exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 2; main_menu ;;
        esac
    fi
}

# Funções para sistema em execução
restart_system() {
    show_header
    echo "Reiniciando o ambiente de desenvolvimento..."
    make restart
    echo -e "${GREEN}Ambiente reiniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

stop_system() {
    show_header
    echo "Parando o ambiente de desenvolvimento..."
    make down
    echo -e "${GREEN}Ambiente parado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

show_logs() {
    show_header
    echo "Exibindo logs do ambiente (Ctrl+C para sair)..."
    make logs
    main_menu
}

access_shell() {
    show_header
    echo "Acessando shell do container (digite 'exit' para sair)..."
    make shell
    main_menu
}

detailed_status() {
    show_header
    echo "Status detalhado do ambiente:"
    make ps
    echo ""
    docker network ls | grep genius360
    echo ""
    docker volume ls | grep genius360
    echo ""
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

# Funções para sistema parado
start_system() {
    show_header
    echo "Iniciando o ambiente de desenvolvimento..."
    make run
    echo -e "${GREEN}Ambiente iniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

start_interactive() {
    show_header
    echo "Iniciando o ambiente em modo interativo (Ctrl+C para parar)..."
    make dev
    main_menu
}

rebuild_system() {
    show_header
    echo "Reconstruindo o ambiente de desenvolvimento..."
    make build
    make run
    echo -e "${GREEN}Ambiente reconstruído e iniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

clean_system() {
    show_header
    echo "Limpando todos os recursos..."
    make clean
    echo -e "${GREEN}Recursos limpos!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

# Iniciar o script
main_menu
