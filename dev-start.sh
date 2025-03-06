#!/bin/bash

# Script para iniciar o ambiente de desenvolvimento correto
# Autor: Sistema Genius360
# Data: 2023

# Detecta se o usuário quer usar o ambiente .devcontainer ou o Docker Compose regular
print_help() {
    echo "Uso: ./dev-start.sh [OPÇÃO]"
    echo "Inicia o ambiente de desenvolvimento para o Genius360."
    echo ""
    echo "Opções:"
    echo "  -d, --devcontainer   Inicia o ambiente usando .devcontainer"
    echo "  -r, --regular        Inicia o ambiente usando o docker-compose.yml padrão"
    echo "  -i, --interactive    Inicia o ambiente em modo interativo"
    echo "  -h, --help           Exibe esta ajuda"
    echo ""
    echo "Se nenhuma opção for fornecida, o script iniciará o assistente interativo."
}

# Função para iniciar o assistente interativo
start_interactive_assistant() {
    clear
    echo "============================================"
    echo "  GENIUS360 - INICIAR DESENVOLVIMENTO"
    echo "============================================"
    echo ""
    echo "Qual ambiente você deseja iniciar?"
    echo ""
    echo "1) Ambiente DevContainer (.devcontainer)"
    echo "2) Ambiente Docker Compose padrão"
    echo "3) Sair"
    echo ""
    
    read -p "Escolha uma opção: " choice
    
    case $choice in
        1)
            cd .devcontainer
            if [ -f "run_devcontainer.sh" ]; then
                chmod +x run_devcontainer.sh
                ./run_devcontainer.sh
            else
                make run
                echo "Ambiente DevContainer iniciado!"
            fi
            ;;
        2)
            if [ -f "run.sh" ]; then
                chmod +x run.sh
                ./run.sh
            else
                make run
                echo "Ambiente padrão iniciado!"
            fi
            ;;
        3)
            echo "Operação cancelada."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            exit 1
            ;;
    esac
}

# Processa argumentos
case "$1" in
    -d|--devcontainer)
        cd .devcontainer
        chmod +x run_devcontainer.sh 2>/dev/null
        if [ -f "run_devcontainer.sh" ]; then
            ./run_devcontainer.sh
        else
            make run
        fi
        ;;
    -r|--regular)
        chmod +x run.sh 2>/dev/null
        if [ -f "run.sh" ]; then
            ./run.sh
        else
            make run
        fi
        ;;
    -i|--interactive)
        start_interactive_assistant
        ;;
    -h|--help)
        print_help
        exit 0
        ;;
    "")
        start_interactive_assistant
        ;;
    *)
        echo "Opção desconhecida: $1"
        print_help
        exit 1
        ;;
esac

exit 0
