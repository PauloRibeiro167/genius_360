#!/bin/bash

# Script para diagnosticar e corrigir problemas com containers

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para verificar o status dos containers
check_containers() {
    echo -e "${BLUE}🔍 Verificando status dos containers...${NC}"
    local containers=$(docker ps -a --format "{{.Names}}" | grep genius360)
    
    if [ -z "$containers" ]; then
        echo -e "${YELLOW}⚠️ Nenhum container Genius360 encontrado${NC}"
        return 1
    fi
    
    echo -e "${BLUE}Containers encontrados:${NC}"
    for container in $containers; do
        local status=$(docker inspect --format='{{.State.Status}}' "$container")
        local uptime=$(docker inspect --format='{{.State.StartedAt}}' "$container")
        local created=$(docker inspect --format='{{.Created}}' "$container")
        
        if [ "$status" == "running" ]; then
            echo -e "${GREEN}✅ $container: $status (desde $uptime)${NC}"
        elif [ "$status" == "restarting" ]; then
            echo -e "${RED}🔄 $container: $status - O container está reiniciando continuamente${NC}"
            local restartCount=$(docker inspect --format='{{.RestartCount}}' "$container")
            echo -e "${RED}   Número de reinicializações: $restartCount${NC}"
        else
            echo -e "${YELLOW}⚠️ $container: $status (criado em $created)${NC}"
        fi
    done
}

# Função para exibir logs de um container
show_logs() {
    local container=$1
    
    if [ -z "$container" ]; then
        echo -e "${YELLOW}⚠️ Por favor, especifique um container${NC}"
        return 1
    fi
    
    if ! docker ps -a --format "{{.Names}}" | grep -q "$container"; then
        echo -e "${RED}❌ Container $container não encontrado${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📋 Exibindo os últimos 50 logs do container $container...${NC}"
    docker logs --tail 50 "$container"
}

# Função para tentar corrigir um container em estado de reinicialização
fix_restarting_container() {
    local container=$1
    
    if [ -z "$container" ]; then
        echo -e "${YELLOW}⚠️ Por favor, especifique um container${NC}"
        return 1
    fi
    
    if ! docker ps -a --format "{{.Names}}" | grep -q "$container"; then
        echo -e "${RED}❌ Container $container não encontrado${NC}"
        return 1
    fi
    
    local status=$(docker inspect --format='{{.State.Status}}' "$container")
    if [ "$status" != "restarting" ]; then
        echo -e "${YELLOW}⚠️ O container $container não está em estado de reinicialização (status atual: $status)${NC}"
        return 0
    fi
    
    echo -e "${BLUE}🔧 Tentando corrigir o container $container...${NC}"
    
    echo -e "${YELLOW}🛑 Parando o container...${NC}"
    docker stop "$container"
    sleep 2
    
    echo -e "${BLUE}🔍 Verificando configurações...${NC}"
    # Verificar se o container web tem todas as dependências necessárias
    if [[ "$container" == *"web"* ]]; then
        echo -e "${BLUE}🔧 Verificando se o container postgres está em execução...${NC}"
        if ! docker ps | grep -q "genius360_postgres.*Up"; then
            echo -e "${YELLOW}⚠️ Container postgres não está em execução. Tentando iniciar...${NC}"
            docker start genius360_postgres
            sleep 5
        fi
    fi
    
    echo -e "${GREEN}🚀 Iniciando o container...${NC}"
    docker start "$container"
    sleep 5
    
    status=$(docker inspect --format='{{.State.Status}}' "$container")
    if [ "$status" == "running" ]; then
        echo -e "${GREEN}✅ Container $container corrigido com sucesso (status: $status)${NC}"
    else
        echo -e "${RED}❌ Falha ao corrigir o container $container (status: $status)${NC}"
        echo -e "${BLUE}📋 Exibindo logs para diagnóstico:${NC}"
        docker logs --tail 20 "$container"
    fi
}

# Função para corrigir problemas de permissão
fix_permissions() {
    local container=$1
    
    if [ -z "$container" ] || ! [[ "$container" == *"web"* ]]; then
        echo -e "${YELLOW}⚠️ Esta função só é aplicável ao container web${NC}"
        return 1
    fi
    
    if ! docker ps | grep -q "$container.*Up"; then
        echo -e "${RED}❌ Container $container não está em execução${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🔧 Corrigindo permissões no container $container...${NC}"
    docker exec "$container" bash -c "mkdir -p /app/tmp/pids && chmod -R 777 /app/tmp /app/log" || {
        echo -e "${RED}❌ Falha ao ajustar permissões${NC}"
        return 1
    }
    echo -e "${GREEN}✅ Permissões corrigidas${NC}"
}

# Menu principal
main() {
    case "$1" in
        check)
            check_containers
            ;;
        logs)
            show_logs "$2"
            ;;
        fix)
            fix_restarting_container "$2"
            ;;
        permissions)
            fix_permissions "$2"
            ;;
        all)
            echo -e "${BLUE}===== Diagnóstico Completo do Sistema =====${NC}"
            check_containers
            
            if docker ps -a --format "{{.Names}}" | grep -q "genius360_web"; then
                echo -e "\n${BLUE}===== Logs do Container Web =====${NC}"
                show_logs "genius360_web"
                
                status=$(docker inspect --format='{{.State.Status}}' "genius360_web")
                if [ "$status" == "restarting" ]; then
                    echo -e "\n${YELLOW}⚠️ Container web está em estado de reinicialização. Tentando corrigir...${NC}"
                    fix_restarting_container "genius360_web"
                fi
            fi
            
            if docker ps -a --format "{{.Names}}" | grep -q "genius360_postgres"; then
                echo -e "\n${BLUE}===== Status do Container PostgreSQL =====${NC}"
                status=$(docker inspect --format='{{.State.Status}}' "genius360_postgres")
                echo -e "Status: $status"
                
                if [ "$status" != "running" ]; then
                    echo -e "${YELLOW}⚠️ Container PostgreSQL não está em execução. Verificando logs...${NC}"
                    show_logs "genius360_postgres"
                fi
            fi
            ;;
        *)
            echo "Uso: $0 {check|logs CONTAINER|fix CONTAINER|permissions CONTAINER|all}"
            echo "  check                - Verificar status de todos os containers"
            echo "  logs CONTAINER       - Exibir logs de um container específico"
            echo "  fix CONTAINER        - Tentar corrigir um container em estado de reinicialização"
            echo "  permissions CONTAINER - Corrigir permissões (apenas para container web)"
            echo "  all                  - Executar todas as verificações e correções"
            ;;
    esac
}

main "$@"
