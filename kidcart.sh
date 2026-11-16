#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_banner() {
    echo -e "${CYAN}"
    echo "  _  ___     _  ____            _   "
    echo " | |/ (_) __| |/ ___|__ _ _ __| |_ "
    echo " | ' /| |/ _\` | |   / _\` | '__| __|"
    echo " | . \\| | (_| | |__| (_| | |  | |_ "
    echo " |_|\\_\\_|\\__,_|\\____\\__,_|_|   \\__|"
    echo -e "${NC}"
    echo -e "${YELLOW}E-commerce for ages 3 to college${NC}"
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
        exit 1
    fi
    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker daemon is not running. Please start Docker.${NC}"
        exit 1
    fi
}

cmd_start() {
    echo -e "${GREEN}Starting KidCart...${NC}"
    docker compose up -d --build
    echo ""
    echo -e "${GREEN}KidCart is running!${NC}"
    echo -e "  Frontend: ${CYAN}http://localhost:3001${NC}  ← Open this!"
    echo -e "  API:      ${CYAN}http://localhost:5000${NC}"
    echo -e "  Swagger:  ${CYAN}http://localhost:5000/swagger${NC}"
    echo -e "  SQL Server: localhost:1433"
    echo -e "  Redis:      localhost:6379"
    echo ""
    echo -e "Run ${YELLOW}./kidcart.sh logs${NC} to view logs"
    echo -e "Run ${YELLOW}./kidcart.sh stop${NC} to stop"
}

cmd_stop() {
    echo -e "${YELLOW}Stopping KidCart...${NC}"
    docker compose down
    echo -e "${GREEN}Stopped.${NC}"
}

cmd_restart() {
    cmd_stop
    cmd_start
}

cmd_logs() {
    docker compose logs -f --tail=100
}

cmd_status() {
    docker compose ps
}

cmd_rebuild() {
    echo -e "${YELLOW}Rebuilding KidCart (no cache)...${NC}"
    docker compose down
    docker compose build --no-cache
    docker compose up -d
    echo -e "${GREEN}Rebuilt and running!${NC}"
}

cmd_db_reset() {
    echo -e "${YELLOW}Resetting database...${NC}"
    docker compose down -v
    docker compose up -d
    echo -e "${GREEN}Database reset complete.${NC}"
}

cmd_help() {
    print_banner
    echo "Usage: ./kidcart.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start all services (API + SQL Server + Redis)"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  logs      Follow container logs"
    echo "  status    Show running containers"
    echo "  rebuild   Rebuild from scratch (no cache)"
    echo "  db-reset  Reset database (destroys all data)"
    echo "  help      Show this help message"
    echo ""
}

# Main
print_banner
check_docker

case "${1:-start}" in
    start)    cmd_start ;;
    stop)     cmd_stop ;;
    restart)  cmd_restart ;;
    logs)     cmd_logs ;;
    status)   cmd_status ;;
    rebuild)  cmd_rebuild ;;
    db-reset) cmd_db_reset ;;
    help|-h)  cmd_help ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        cmd_help
        exit 1
        ;;
esac
