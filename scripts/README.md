# Setup and Run Scripts

This directory contains automation scripts for setting up and running the Shopizer Shop React application.

## Scripts

### setup.sh
**Purpose**: Automated setup and dependency installation

**Usage**:
```bash
./scripts/setup.sh
```

**What it does**:
- Checks Node.js and npm versions
- Sets up environment configuration
- Installs npm dependencies
- Verifies installation
- Provides next steps

**When to run**:
- First time setup
- After pulling changes that modify package.json
- When dependencies are corrupted
- After updating .env file

### run.sh
**Purpose**: Start the application with pre-flight checks

**Usage**:
```bash
./scripts/run.sh
```

**What it does**:
- Runs pre-flight checks
- Loads environment variables
- Checks backend connectivity
- Starts React development server

**When to run**:
- Daily development
- After configuration changes
- To start the application

## Quick Start

```bash
# First time setup
chmod +x scripts/*.sh
./scripts/setup.sh

# Run application
./scripts/run.sh
```

## Requirements

- Node.js v16.13.0 or higher
- npm 6.x or higher
- Shopizer backend running (default: http://localhost:8080)

## Documentation

For detailed setup instructions, see: [docs/LOCAL_SETUP.md](../docs/LOCAL_SETUP.md)
