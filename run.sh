#!/bin/bash

# Script interativo para gerenciar o Genius360
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
    echo -e "${BLUE}            GENIUS360 - GERENCIAMENTO              ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
}

# Função para verificar o status dos containers
check_status() {
    if docker ps | grep -q "genius360_web"; then
        echo -e "${GREEN}✓ O sistema Genius360 está em execução!${NC}"
        echo -e "  Web: http://localhost:3000"
        echo ""
        return 0
    else
        echo -e "${YELLOW}! O sistema Genius360 não está em execução.${NC}"
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
        echo "1) Reiniciar o sistema"
        echo "2) Parar o sistema"
        echo "3) Ver logs em tempo real"
        echo "4) Acessar shell do container web"
        echo "5) Executar comandos Rails"
        echo "6) Reconstruir container"
    else
        echo "1) Iniciar o sistema"
        echo "2) Iniciar o sistema em modo interativo"
        echo "3) Recriar containers e volumes"
        echo "4) Verificar status detalhado"
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
            5) rails_commands ;;
            6) rebuild_container ;;
            0) exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 2; main_menu ;;
        esac
    else
        case $choice in
            1) start_system ;;
            2) start_interactive ;;
            3) recreate_system ;;
            4) detailed_status ;;
            0) exit 0 ;;
            *) echo -e "${RED}Opção inválida!${NC}"; sleep 2; main_menu ;;
        esac
    fi
}

# Funções para sistema em execução
restart_system() {
    show_header
    echo "Reiniciando o sistema Genius360..."
    make restart
    echo -e "${GREEN}Sistema reiniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

stop_system() {
    show_header
    echo "Parando o sistema Genius360..."
    make down
    echo -e "${GREEN}Sistema parado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

show_logs() {
    show_header
    echo "Exibindo logs do sistema (Ctrl+C para sair)..."
    make logs
    main_menu
}

access_shell() {
    show_header
    echo "Acessando shell do container web (digite 'exit' para sair)..."
    echo "Para iniciar o ambiente de desenvolvimento, use o comando: cd /app && bin/dev"
    make shell
    main_menu
}

# Função para reconstruir o container
rebuild_container() {
    show_header
    echo "Reconstruindo o container Genius360..."
    make rebuild
    echo -e "${GREEN}Container reconstruído com sucesso!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

# Funções para sistema parado
start_system() {
    show_header
    echo "Iniciando o sistema Genius360..."
    make start
    echo -e "${GREEN}Sistema iniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

start_interactive() {
    show_header
    echo "Iniciando o sistema em modo interativo (Ctrl+C para parar)..."
    make dev
    main_menu
}

recreate_system() {
    show_header
    echo "Recriando containers e volumes..."
    make clean
    make build
    make run
    echo -e "${GREEN}Sistema recriado e iniciado!${NC}"
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

detailed_status() {
    show_header
    echo "Status detalhado do sistema:"
    make ps
    echo ""
    docker network ls | grep genius360
    echo ""
    docker volume ls | grep genius360
    echo ""
    read -p "Pressione Enter para continuar..." dummy
    main_menu
}

# Submenu para comandos Rails
rails_commands() {
    show_header
    echo "Comandos Rails:"
    echo ""
    echo "1) Abrir console Rails"
    echo "2) Executar migrações"
    echo "3) Resetar banco de dados"
    echo "4) Listar rotas"
    echo "5) Executar testes"
    echo "6) Voltar ao menu principal"
    echo ""
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1) make rails-console; rails_commands ;;
        2) make db-migrate; read -p "Pressione Enter para continuar..." dummy; rails_commands ;;
        3) make db-reset; read -p "Pressione Enter para continuar..." dummy; rails_commands ;;
        4) make routes; read -p "Pressione Enter para continuar..." dummy; rails_commands ;;
        5) make test; read -p "Pressione Enter para continuar..." dummy; rails_commands ;;
        6) main_menu ;;
        *) echo -e "${RED}Opção inválida!${NC}"; sleep 2; rails_commands ;;
    esac
}

# Iniciar o script
main_menu
