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
    echo "║     Shopizer Shop React - Local Setup Script          ║"
    echo "║     Version: 3.0.0                                     ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

# Check Node.js version
check_node_version() {
    log_info "Checking Node.js version..."
    
    if ! command_exists node; then
        log_error "Node.js is not installed!"
        log_info "Please install Node.js v16.13.0 or higher from https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2)
    REQUIRED_VERSION="16.13.0"
    
    log_success "Node.js version: v$NODE_VERSION"
    
    # Simple version check (major version)
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -lt 16 ]; then
        log_warning "Node.js version is below recommended v16.13.0"
        log_warning "Some features may not work correctly"
    fi
}

# Check npm
check_npm() {
    log_info "Checking npm..."
    
    if ! command_exists npm; then
        log_error "npm is not installed!"
        exit 1
    fi
    
    NPM_VERSION=$(npm -v)
    log_success "npm version: $NPM_VERSION"
}

# Setup environment file
setup_env_file() {
    log_info "Setting up environment configuration..."
    
    cd "$PROJECT_ROOT"
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        log_warning ".env file not found"
        
        if [ -f ".env.example" ]; then
            log_info "Copying .env.example to .env"
            cp .env.example .env
            log_success "Created .env file from .env.example"
        else
            log_error "Neither .env nor .env.example found!"
            log_info "Please create .env file with required variables"
            exit 1
        fi
    else
        log_success ".env file exists"
    fi
    
    # Generate env-config.js from .env
    if [ -f "env.sh" ]; then
        log_info "Generating public/env-config.js from .env..."
        chmod +x env.sh
        ./env.sh
        
        if [ -f "env-config.js" ]; then
            cp env-config.js public/env-config.js
            log_success "Generated public/env-config.js"
        fi
    fi
}

# Install dependencies
install_dependencies() {
    log_info "Installing npm dependencies..."
    
    cd "$PROJECT_ROOT"
    
    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        log_info "node_modules directory exists"
        read -p "Do you want to reinstall dependencies? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Skipping dependency installation"
            return 0
        fi
        log_info "Removing existing node_modules..."
        rm -rf node_modules package-lock.json
    fi
    
    log_info "Running npm install (this may take a few minutes)..."
    
    # Try standard install first
    if npm install --silent 2>/dev/null; then
        log_success "Dependencies installed successfully"
    else
        log_warning "Standard npm install failed, trying with --legacy-peer-deps..."
        if npm install --legacy-peer-deps --silent; then
            log_success "Dependencies installed successfully with --legacy-peer-deps"
        else
            log_error "Failed to install dependencies"
            log_info "Please try manually: npm install --legacy-peer-deps"
            exit 1
        fi
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    cd "$PROJECT_ROOT"
    
    # Check critical files
    local critical_files=(
        "package.json"
        "public/index.html"
        "src/index.js"
        "src/App.js"
        "public/env-config.js"
    )
    
    for file in "${critical_files[@]}"; do
        if [ ! -f "$file" ]; then
            log_error "Critical file missing: $file"
            exit 1
        fi
    done
    
    # Check node_modules
    if [ ! -d "node_modules" ]; then
        log_error "node_modules directory not found"
        exit 1
    fi
    
    log_success "Installation verified successfully"
}

# Print next steps
print_next_steps() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║              Setup Completed Successfully!             ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    log_info "Next steps:"
    echo ""
    echo "  1. Configure your backend URL in .env:"
    echo "     ${YELLOW}APP_BASE_URL=http://localhost:8080${NC}"
    echo ""
    echo "  2. Start the application:"
    echo "     ${GREEN}./scripts/run.sh${NC}"
    echo "     or"
    echo "     ${GREEN}npm run dev${NC}"
    echo ""
    echo "  3. Open your browser:"
    echo "     ${BLUE}http://localhost:3000${NC}"
    echo ""
    log_warning "Note: This frontend requires a running Shopizer backend API"
    log_info "Backend should be accessible at the URL configured in APP_BASE_URL"
    echo ""
}

# Main execution
main() {
    print_banner
    
    log_info "Starting setup process..."
    echo ""
    
    # Run checks and setup
    check_node_version
    check_npm
    setup_env_file
    install_dependencies
    verify_installation
    
    # Print completion message
    print_next_steps
}

# Run main function
main "$@"
