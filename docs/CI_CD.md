# CI/CD Pipeline Documentation

## GitHub Actions CI Pipeline

The project includes an automated CI/CD pipeline that runs on every push and pull request.

### Pipeline Jobs

#### 1. Test and Build Job
- **Node Version**: 16.x
- **Steps**:
  - Checkout code
  - Install dependencies with `--legacy-peer-deps`
  - Run tests (with no-watch mode)
  - Build production bundle
  - Create compressed artifact
  - Upload artifacts to GitHub

#### 2. Docker Build Job
- **Depends on**: test-and-build
- **Steps**:
  - Build Docker image
  - Save and compress image
  - Upload Docker artifact

### Artifacts Generated

1. **Build Archive** (`shopizer-shop-build-{SHA}.tar.gz`)
   - Compressed production build
   - Ready to deploy to any static hosting

2. **Build Folder** (`build-folder-{SHA}`)
   - Uncompressed build directory
   - All static assets

3. **Docker Image** (`docker-image-{SHA}.tar.gz`)
   - Complete Docker image
   - Ready to load and run

### Artifact Retention
- All artifacts retained for **30 days**

## Download and Run Artifacts Locally

### Prerequisites

1. **GitHub CLI** - Install from https://cli.github.com/
   ```bash
   # macOS
   brew install gh
   
   # Linux
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
   ```

2. **Docker** - Install from https://www.docker.com/

3. **Authenticate GitHub CLI**
   ```bash
   gh auth login
   ```

### Usage

#### List Available CI Runs
```bash
./scripts/download-artifacts.sh list
```

This shows recent CI runs with their IDs, status, and dates.

#### Download and Serve Build Artifact
```bash
./scripts/download-artifacts.sh download-build <RUN_ID>
```

This will:
1. Download the build artifact
2. Extract it
3. Start a local HTTP server on port 8000
4. Open http://localhost:8000 in your browser

#### Download and Run Docker Image
```bash
./scripts/download-artifacts.sh download-docker <RUN_ID>
```

This will:
1. Download the Docker image
2. Load it into Docker
3. Run the container on port 8080
4. Access at http://localhost:8080

### Examples

```bash
# Step 1: List recent runs
./scripts/download-artifacts.sh list

# Output:
# RUN ID       STATUS       RESULT       BRANCH          DATE
# 1234567890   completed    success      main            2026-02-26T10:30:00Z
# 1234567889   completed    success      develop         2026-02-25T15:20:00Z

# Step 2: Download and run build
./scripts/download-artifacts.sh download-build 1234567890

# OR download and run Docker image
./scripts/download-artifacts.sh download-docker 1234567890
```

### Manual Download (Alternative)

If you prefer to download manually:

1. Go to GitHub repository → Actions tab
2. Click on a successful workflow run
3. Scroll to "Artifacts" section
4. Download desired artifact
5. Extract and serve:
   ```bash
   tar -xzf shopizer-shop-build.tar.gz
   cd build
   python3 -m http.server 8000
   ```

### Configuration

The CI pipeline uses environment variables from `.env.example`. To customize:

1. Add secrets in GitHub repository settings
2. Update `.github/workflows/ci.yml` to use secrets:
   ```yaml
   env:
     APP_BASE_URL: ${{ secrets.APP_BASE_URL }}
     APP_STRIPE_KEY: ${{ secrets.STRIPE_KEY }}
   ```

### Troubleshooting

**Issue**: `gh: command not found`
- **Solution**: Install GitHub CLI (see Prerequisites)

**Issue**: `Not authenticated with GitHub CLI`
- **Solution**: Run `gh auth login`

**Issue**: Docker image fails to load
- **Solution**: Ensure Docker daemon is running: `docker ps`

**Issue**: Port already in use
- **Solution**: Change port in script or stop conflicting service

### CI Pipeline Triggers

The pipeline runs on:
- Push to `main`, `master`, or `develop` branches
- Pull requests to these branches

To manually trigger:
1. Go to Actions tab in GitHub
2. Select "CI Pipeline" workflow
3. Click "Run workflow"
