# Local Setup Guide

## Overview

This guide will help you set up and run the Shopizer Shop React application on your local machine. The setup process is automated through scripts that handle dependency installation, configuration, and application startup.

## Table of Contents

- [System Requirements](#system-requirements)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup Instructions](#detailed-setup-instructions)
- [Environment Variables](#environment-variables)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)
- [Development Workflow](#development-workflow)

## System Requirements

### Minimum Requirements

- **Operating System**: macOS, Linux, or Windows (with WSL2 recommended)
- **RAM**: 4 GB minimum, 8 GB recommended
- **Disk Space**: 500 MB for dependencies
- **Internet Connection**: Required for initial setup

### Software Requirements

| Software | Version | Required |
|----------|---------|----------|
| Node.js | v16.13.0 or higher | Yes |
| npm | 6.x or higher | Yes |
| Git | Any recent version | Optional |
| Shopizer Backend | v2.x or v3.x | Yes |

## Prerequisites

### 1. Install Node.js

**macOS** (using Homebrew):
```bash
brew install node@16
```

**Linux** (using nvm):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 16.13.0
nvm use 16.13.0
```

**Windows**:
- Download from [nodejs.org](https://nodejs.org/)
- Install the LTS version (v16.x or higher)

**Verify Installation**:
```bash
node -v   # Should show v16.13.0 or higher
npm -v    # Should show 6.x or higher
```

### 2. Shopizer Backend

This frontend application requires a running Shopizer backend API.

**Backend Requirements**:
- Shopizer backend must be running and accessible
- Default URL: `http://localhost:8080`
- API version: v1
- Endpoints must be accessible from your machine

**Backend Setup**:
- Follow Shopizer backend setup instructions
- Ensure backend is running before starting frontend
- Test backend: `curl http://localhost:8080/api/v1/store/DEFAULT`

## Quick Start

### One-Command Setup

```bash
# Clone the repository (if not already done)
git clone <repository-url>
cd shopizer-shop-reactjs

# Run setup script
chmod +x scripts/setup.sh scripts/run.sh
./scripts/setup.sh

# Start the application
./scripts/run.sh
```

The application will be available at: **http://localhost:3000**

## Detailed Setup Instructions

### Step 1: Clone Repository

```bash
git clone <repository-url>
cd shopizer-shop-reactjs
```

Or download and extract the ZIP file.

### Step 2: Make Scripts Executable

```bash
chmod +x scripts/setup.sh scripts/run.sh
```

### Step 3: Run Setup Script

```bash
./scripts/setup.sh
```

**What the setup script does**:

1. **Checks Node.js and npm versions**
   - Verifies Node.js v16.13.0 or higher is installed
   - Verifies npm is available

2. **Sets up environment configuration**
   - Checks for `.env` file
   - Creates `.env` from `.env.example` if needed
   - Generates `public/env-config.js` from `.env`

3. **Installs dependencies**
   - Runs `npm install`
   - Falls back to `npm install --legacy-peer-deps` if needed
   - Installs all packages from `package.json`

4. **Verifies installation**
   - Checks critical files exist
   - Verifies `node_modules` directory
   - Confirms setup completed successfully

**Expected Output**:
```
╔════════════════════════════════════════════════════════╗
║     Shopizer Shop React - Local Setup Script          ║
║     Version: 3.0.0                                     ║
╚════════════════════════════════════════════════════════╝

[INFO] Starting setup process...
[INFO] Checking Node.js version...
[SUCCESS] Node.js version: v16.13.0
[INFO] Checking npm...
[SUCCESS] npm version: 8.1.0
[INFO] Setting up environment configuration...
[SUCCESS] .env file exists
[INFO] Installing npm dependencies...
[SUCCESS] Dependencies installed successfully
[INFO] Verifying installation...
[SUCCESS] Installation verified successfully

╔════════════════════════════════════════════════════════╗
║              Setup Completed Successfully!             ║
╚════════════════════════════════════════════════════════╝
```

**Setup Time**: 2-5 minutes depending on internet speed

### Step 4: Configure Environment

Edit `.env` file with your configuration:

```bash
# Open in your preferred editor
nano .env
# or
vim .env
# or
code .env
```

**Minimum Required Configuration**:
```bash
APP_BASE_URL=http://localhost:8080  # Your Shopizer backend URL
APP_MERCHANT=DEFAULT                 # Your merchant code
```

**Optional Configuration**:
```bash
APP_STRIPE_KEY=pk_test_...          # Stripe publishable key
APP_MAP_API_KEY=...                  # Google Maps API key
APP_THEME_COLOR=#D1D1D1             # Primary theme color
```

After editing `.env`, regenerate the config:
```bash
./env.sh
cp env-config.js public/env-config.js
```

Or re-run setup:
```bash
./scripts/setup.sh
```

### Step 5: Start Application

```bash
./scripts/run.sh
```

**What the run script does**:

1. **Pre-flight checks**
   - Verifies Node.js and npm are installed
   - Checks `node_modules` exists
   - Verifies `.env` file exists
   - Ensures `public/env-config.js` is generated

2. **Loads environment**
   - Reads variables from `.env`
   - Exports them to the environment

3. **Checks backend connectivity**
   - Tests connection to backend URL
   - Warns if backend is unreachable

4. **Starts development server**
   - Runs `npm run dev`
   - Opens browser automatically (if configured)
   - Enables hot module replacement

**Expected Output**:
```
╔════════════════════════════════════════════════════════╗
║       Shopizer Shop React - Starting Application      ║
╚════════════════════════════════════════════════════════╝

[INFO] Running pre-flight checks...
[SUCCESS] Pre-flight checks passed
[INFO] Loading environment configuration...
[SUCCESS] Environment variables loaded
[INFO] Checking backend connectivity...
[INFO] Backend URL: http://localhost:8080
[SUCCESS] Backend is reachable
[SUCCESS] All checks passed, starting application...

[INFO] Starting React development server...
[INFO] Application will be available at: http://localhost:3000

Compiled successfully!

You can now view shop-react in the browser.

  Local:            http://localhost:3000
  On Your Network:  http://192.168.1.x:3000
```

### Step 6: Access Application

Open your browser and navigate to:

**http://localhost:3000**

## Environment Variables

### Complete Variable Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `APP_BASE_URL` | Shopizer backend API URL | http://localhost:8080 | Yes |
| `APP_API_VERSION` | API version path | /api/v1/ | Yes |
| `APP_MERCHANT` | Store/merchant code | DEFAULT | Yes |
| `APP_PRODUCTION` | Production mode flag | false | No |
| `APP_PRODUCT_GRID_LIMIT` | Products per page | 15 | No |
| `APP_PAYMENT_TYPE` | Payment gateway (STRIPE/NUVEI) | STRIPE | No |
| `APP_STRIPE_KEY` | Stripe publishable key | (empty) | If using Stripe |
| `APP_NUVEI_TERMINAL_ID` | Nuvei terminal ID | (empty) | If using Nuvei |
| `APP_NUVEI_SECRET` | Nuvei secret key | (empty) | If using Nuvei |
| `APP_MAP_API_KEY` | Google Maps API key | (empty) | If using maps |
| `APP_THEME_COLOR` | Primary theme color (hex) | #D1D1D1 | No |

### Environment File Locations

1. **`.env`** - Main environment file (not committed to git)
2. **`.env.example`** - Template with all variables documented
3. **`public/env-config.js`** - Generated JavaScript config (runtime)

### How Environment Configuration Works

```
.env (source)
    ↓
env.sh (script)
    ↓
env-config.js (generated)
    ↓
public/env-config.js (copied)
    ↓
window._env_ (runtime)
```

**Flow**:
1. You edit `.env` with your configuration
2. `env.sh` script reads `.env` and generates `env-config.js`
3. File is copied to `public/env-config.js`
4. Application loads it as `window._env_` object
5. React components access via `window._env_.APP_BASE_URL`

## Running the Application

### Development Mode

**Using run script** (recommended):
```bash
./scripts/run.sh
```

**Using npm directly**:
```bash
npm run dev
# or
npm start
```

**Features**:
- Hot module replacement (HMR)
- Automatic browser refresh
- Source maps for debugging
- React DevTools support
- Redux DevTools support

**Access**:
- Local: http://localhost:3000
- Network: http://192.168.1.x:3000 (accessible from other devices)

**Stop Server**:
- Press `Ctrl+C` in terminal

### Production Build

**Build for production**:
```bash
npm run build
```

**Output**: `build/` directory with optimized files

**Test production build locally**:
```bash
# Install serve globally
npm install -g serve

# Serve production build
serve -s build -p 3000
```

**Access**: http://localhost:3000

### Docker Deployment

**Build Docker image**:
```bash
docker build -t shopizer-shop-reactjs:latest .
```

**Run container**:
```bash
docker run \
  -e "APP_MERCHANT=DEFAULT" \
  -e "APP_BASE_URL=http://localhost:8080" \
  -p 80:80 \
  shopizer-shop-reactjs:latest
```

**Access**: http://localhost

## Troubleshooting

### Common Issues and Solutions

#### 1. Setup Script Fails

**Issue**: `./scripts/setup.sh` fails with permission error

**Solution**:
```bash
chmod +x scripts/setup.sh scripts/run.sh
./scripts/setup.sh
```

#### 2. Node.js Version Error

**Issue**: "Node.js version is below recommended v16.13.0"

**Solution**:
```bash
# Install Node.js v16 or higher
# macOS
brew install node@16

# Linux (using nvm)
nvm install 16.13.0
nvm use 16.13.0

# Verify
node -v
```

#### 3. npm Install Fails

**Issue**: `npm install` fails with peer dependency errors

**Solution**:
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

#### 4. Backend Connection Error

**Issue**: "Cannot reach backend at http://localhost:8080"

**Checks**:
```bash
# Test backend is running
curl http://localhost:8080/api/v1/store/DEFAULT

# Check backend logs
# Verify CORS is enabled on backend
# Check firewall settings
```

**Solution**:
- Start Shopizer backend first
- Verify `APP_BASE_URL` in `.env` is correct
- Ensure backend CORS allows `http://localhost:3000`

#### 5. Port 3000 Already in Use

**Issue**: "Port 3000 is already in use"

**Solution**:
```bash
# Find and kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
PORT=3001 npm run dev
```

#### 6. Blank Page After Start

**Issue**: Browser shows blank page

**Checks**:
- Open browser console (F12) and check for errors
- Verify `public/env-config.js` exists
- Check `APP_BASE_URL` is correct

**Solution**:
```bash
# Regenerate config
./env.sh
cp env-config.js public/env-config.js

# Restart server
./scripts/run.sh
```

#### 7. Payment Not Working

**Issue**: Stripe payment fails

**Checks**:
- Verify `APP_STRIPE_KEY` is set in `.env`
- Use test key: `pk_test_...` (not live key)
- Check browser console for Stripe errors

**Solution**:
```bash
# Update .env
APP_STRIPE_KEY=pk_test_51234567890abcdef

# Regenerate config
./scripts/setup.sh

# Restart
./scripts/run.sh
```

#### 8. Images Not Loading

**Issue**: Product images show as broken

**Checks**:
- Verify backend is returning correct image URLs
- Check browser console for CORS errors
- Test image URL directly in browser

**Solution**:
- Ensure backend CORS allows image requests
- Verify backend image paths are correct

#### 9. Environment Changes Not Applied

**Issue**: Changes to `.env` not reflected in app

**Solution**:
```bash
# Regenerate config
./env.sh
cp env-config.js public/env-config.js

# Restart server (Ctrl+C then)
./scripts/run.sh
```

#### 10. Module Not Found Errors

**Issue**: "Module not found" errors in console

**Solution**:
```bash
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps

# Restart
./scripts/run.sh
```

### Debug Mode

**Enable verbose logging**:

1. Open browser DevTools (F12)
2. Console tab: Check for JavaScript errors
3. Network tab: Check API calls and responses
4. Redux DevTools: Inspect state and actions

**Check backend API**:
```bash
# Test store endpoint
curl http://localhost:8080/api/v1/store/DEFAULT

# Test products endpoint
curl http://localhost:8080/api/v1/products/?store=DEFAULT

# Check with authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8080/api/v1/auth/customer/profile
```

### Getting Help

If you encounter issues not covered here:

1. Check browser console for errors
2. Check terminal output for error messages
3. Verify backend is running and accessible
4. Review `.env` configuration
5. Check GitHub issues for similar problems
6. Create new issue with:
   - Error message
   - Steps to reproduce
   - Environment details (Node version, OS)
   - Screenshots

## Development Workflow

### Daily Development

```bash
# Start development server
./scripts/run.sh

# Make code changes
# Browser auto-refreshes

# Stop server
Ctrl+C
```

### After Pulling Changes

```bash
# Update dependencies (if package.json changed)
npm install --legacy-peer-deps

# Restart server
./scripts/run.sh
```

### Testing Changes

```bash
# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

### Building for Production

```bash
# Create production build
npm run build

# Test production build
serve -s build -p 3000
```

### Updating Configuration

```bash
# Edit environment
nano .env

# Regenerate config
./env.sh
cp env-config.js public/env-config.js

# Restart
./scripts/run.sh
```

## Project Structure

```
shopizer-shop-reactjs/
├── scripts/
│   ├── setup.sh              # Setup automation script
│   └── run.sh                # Run automation script
├── public/
│   ├── index.html            # HTML template
│   └── env-config.js         # Runtime configuration
├── src/
│   ├── index.js              # Application entry point
│   ├── App.js                # Root component
│   ├── pages/                # Page components
│   ├── components/           # Reusable components
│   ├── redux/                # State management
│   └── util/                 # Utilities
├── .env                      # Environment variables (not in git)
├── .env.example              # Environment template
├── package.json              # Dependencies
└── README.md                 # Project documentation
```

## Additional Resources

### Documentation
- [React Documentation](https://reactjs.org/docs)
- [Redux Documentation](https://redux.js.org/)
- [Create React App](https://create-react-app.dev/)
- [Shopizer Documentation](https://www.shopizer.com/)

### Tools
- [React DevTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
- [Redux DevTools](https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd)

### Support
- GitHub Issues: (repository issues page)
- Shopizer Community: https://www.shopizer.com/

## Quick Reference

### Essential Commands

```bash
# Setup
./scripts/setup.sh

# Run
./scripts/run.sh

# Build
npm run build

# Test
npm test

# Install dependencies
npm install --legacy-peer-deps

# Update config
./env.sh && cp env-config.js public/env-config.js
```

### Important Files

- `.env` - Environment configuration
- `public/env-config.js` - Runtime config
- `package.json` - Dependencies
- `src/App.js` - Root component
- `src/util/webService.js` - API client

### Default URLs

- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- API: http://localhost:8080/api/v1/

### Environment Variables

```bash
APP_BASE_URL=http://localhost:8080
APP_MERCHANT=DEFAULT
APP_STRIPE_KEY=pk_test_...
```
