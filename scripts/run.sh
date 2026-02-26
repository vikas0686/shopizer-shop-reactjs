#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Print banner
print_banner() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║       Shopizer Shop React - Starting Application      ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

# Pre-flight checks
preflight_checks() {
    log_info "Running pre-flight checks..."
    
    cd "$PROJECT_ROOT"
    
    # Load nvm and use Node v16
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        log_info "Loading nvm..."
        source "$HOME/.nvm/nvm.sh"
        
        # Check if Node v16 is installed
        if ! nvm ls 16 >/dev/null 2>&1; then
            log_info "Installing Node.js v16.13.0..."
            nvm install 16.13.0
        fi
        
        log_info "Using Node.js v16..."
        nvm use 16
    fi
    
    # Check Node.js
    if ! command_exists node; then
        log_error "Node.js is not installed!"
        log_info "Please run: ./scripts/setup.sh"
        exit 1
    fi
    
    log_info "Node version: $(node --version)"
    
    # Check npm
    if ! command_exists npm; then
        log_error "npm is not installed!"
        exit 1
    fi
    
    # Check node_modules
    if [ ! -d "node_modules" ]; then
        log_error "Dependencies not installed!"
        log_info "Please run: ./scripts/setup.sh"
        exit 1
    fi
    
    # Check .env file
    if [ ! -f ".env" ]; then
        log_error ".env file not found!"
        log_info "Please run: ./scripts/setup.sh"
        exit 1
    fi
    
    # Check env-config.js
    if [ ! -f "public/env-config.js" ]; then
        log_warning "public/env-config.js not found, generating..."
        if [ -f "env.sh" ]; then
            chmod +x env.sh
            ./env.sh
            cp env-config.js public/env-config.js 2>/dev/null || true
        fi
    fi
    
    log_success "Pre-flight checks passed"
}

# Load environment variables
load_environment() {
    log_info "Loading environment configuration..."
    
    cd "$PROJECT_ROOT"
    
    if [ -f ".env" ]; then
        # Export variables from .env
        set -a
        source .env
        set +a
        log_success "Environment variables loaded"
    fi
}

# Check backend connectivity
check_backend() {
    log_info "Checking backend connectivity..."
    
    if [ -z "$APP_BASE_URL" ]; then
        log_warning "APP_BASE_URL not set in .env"
        return 0
    fi
    
    log_info "Backend URL: $APP_BASE_URL"
    
    # Try to ping backend (optional, non-blocking)
    if command_exists curl; then
        if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 "$APP_BASE_URL" >/dev/null 2>&1; then
            log_success "Backend is reachable"
        else
            log_warning "Cannot reach backend at $APP_BASE_URL"
            log_warning "Make sure Shopizer backend is running"
        fi
    fi
}

# Start application
start_application() {
    log_info "Starting React development server..."
    echo ""
    log_info "Application will be available at: ${GREEN}http://localhost:3000${NC}"
    log_info "Press ${YELLOW}Ctrl+C${NC} to stop the server"
    echo ""
    
    cd "$PROJECT_ROOT"
    
    # Start the dev server
    npm run dev
}

# Cleanup on exit
cleanup() {
    echo ""
    log_info "Shutting down..."
}

# Trap cleanup
trap cleanup EXIT INT TERM

# Main execution
main() {
    print_banner
    
    preflight_checks
    load_environment
    check_backend
    
    echo ""
    log_success "All checks passed, starting application..."
    echo ""
    
    start_application
}

# Run main function
main "$@"
