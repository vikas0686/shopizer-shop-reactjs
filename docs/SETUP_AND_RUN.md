# Setup and Run Guide

## Prerequisites

### Required Software

**Node.js**
- **Tested Version**: v16.13.0
- **Minimum Version**: v13.12.0
- **Download**: https://nodejs.org/

**npm**
- Comes with Node.js
- Version 6.x or higher

**Git** (optional, for cloning)
- Download: https://git-scm.com/

**Docker** (optional, for containerized deployment)
- Download: https://www.docker.com/

### Backend Requirement

**Shopizer Backend API**
- This frontend requires a running Shopizer backend
- Backend should be accessible via HTTP/HTTPS
- Default: http://localhost:8080
- API version: v1

## Installation

### 1. Clone or Download Repository

**Using Git**:
```bash
git clone <repository-url>
cd shopizer-shop-reactjs
```

**Or download and extract the ZIP file**

### 2. Install Dependencies

**Standard Installation**:
```bash
npm install
```

**If standard installation fails** (due to peer dependency conflicts):
```bash
npm install --legacy-peer-deps
```

This installs all dependencies listed in `package.json`.

**Installation Time**: 2-5 minutes depending on internet speed

### 3. Configure Backend Connection

Edit `public/env-config.js`:

```javascript
window._env_ = {
  APP_PRODUCTION: "false",
  APP_BASE_URL: "http://localhost:8080",  // Your Shopizer backend URL
  APP_API_VERSION: "/api/v1/",
  APP_MERCHANT: "DEFAULT",                 // Your merchant code
  APP_PRODUCT_GRID_LIMIT: "15",
  APP_MAP_API_KEY: "",                     // Google Maps API key (optional)
  APP_NUVEI_TERMINAL_ID: "",              // Nuvei config (if using)
  APP_NUVEI_SECRET: "",
  APP_PAYMENT_TYPE: "STRIPE",             // STRIPE or NUVEI
  APP_STRIPE_KEY: "pk_test_...",          // Your Stripe publishable key
  APP_THEME_COLOR: "#D1D1D1"              // Primary theme color
}
```

**Configuration Parameters**:

| Parameter | Description | Required |
|-----------|-------------|----------|
| APP_BASE_URL | Shopizer backend API URL | Yes |
| APP_MERCHANT | Merchant/store code | Yes |
| APP_STRIPE_KEY | Stripe publishable key | If using Stripe |
| APP_MAP_API_KEY | Google Maps API key | If using maps |
| APP_THEME_COLOR | Primary color (hex) | No |

### 4. Run Development Server

```bash
npm run dev
```

Or:
```bash
npm start
```

**Output**:
```
Compiled successfully!

You can now view shop-react in the browser.

  Local:            http://localhost:3000
  On Your Network:  http://192.168.1.x:3000
```

**Access Application**: Open browser to http://localhost:3000

**Development Features**:
- Hot module replacement (HMR)
- Automatic browser refresh on code changes
- Source maps for debugging
- React DevTools support
- Redux DevTools support

## Build for Production

### 1. Create Production Build

```bash
npm run build
```

**Output**:
```
Creating an optimized production build...
Compiled successfully.

File sizes after gzip:

  52.3 KB  build/static/js/2.chunk.js
  15.2 KB  build/static/js/main.chunk.js
  2.1 KB   build/static/css/main.chunk.css

The build folder is ready to be deployed.
```

**Build Output**: `build/` directory

**Build Optimizations**:
- Minified JavaScript and CSS
- Code splitting
- Tree shaking (unused code removal)
- Asset optimization
- Source maps (optional)

### 2. Test Production Build Locally

**Using serve**:
```bash
npm install -g serve
serve -s build -p 3000
```

**Using Python**:
```bash
cd build
python -m http.server 3000
```

**Access**: http://localhost:3000

## Docker Deployment

### 1. Build Docker Image

```bash
docker build -t shopizer-shop-reactjs:latest .
```

**Build Process**:
- Stage 1: Install dependencies and build React app
- Stage 2: Copy build to Nginx container
- Total time: 5-10 minutes

### 2. Run Docker Container

**Basic Run**:
```bash
docker run -p 80:80 shopizer-shop-reactjs:latest
```

**With Environment Variables**:
```bash
docker run \
  -e "APP_MERCHANT=DEFAULT" \
  -e "APP_BASE_URL=http://localhost:8080" \
  -e "APP_STRIPE_KEY=pk_test_..." \
  -e "APP_THEME_COLOR=#D1D1D1" \
  -it --rm -p 80:80 shopizer-shop-reactjs:latest
```

**Access**: http://localhost

**Docker Environment Variables**:
All variables from `env-config.js` can be passed as environment variables.

### 3. Docker Compose (Optional)

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  shopizer-shop:
    image: shopizer-shop-reactjs:latest
    ports:
      - "80:80"
    environment:
      - APP_MERCHANT=DEFAULT
      - APP_BASE_URL=http://shopizer-backend:8080
      - APP_STRIPE_KEY=pk_test_...
      - APP_THEME_COLOR=#D1D1D1
    depends_on:
      - shopizer-backend

  shopizer-backend:
    image: shopizer-backend:latest
    ports:
      - "8080:8080"
```

**Run**:
```bash
docker-compose up -d
```

## Environment Configuration

### Development Environment

**File**: `public/env-config.js`

**Development Settings**:
```javascript
window._env_ = {
  APP_PRODUCTION: "false",
  APP_BASE_URL: "http://localhost:8080",
  APP_MERCHANT: "DEFAULT",
  APP_STRIPE_KEY: "pk_test_...",  // Test key
  // ... other settings
}
```

### Production Environment

**Docker Runtime Configuration**:

1. Set environment variables in `.env` file:
```bash
APP_PRODUCTION=true
APP_BASE_URL=https://api.yourstore.com
APP_MERCHANT=YOURSTORE
APP_STRIPE_KEY=pk_live_...
APP_THEME_COLOR=#FF5733
```

2. Docker container injects these at runtime via `env.sh`

**Nginx Deployment**:

1. Build production bundle: `npm run build`
2. Copy `build/` contents to web server
3. Update `env-config.js` on server with production values
4. Configure Nginx to serve static files

**Nginx Configuration Example**:
```nginx
server {
    listen 80;
    server_name yourstore.com;
    root /usr/share/nginx/html;
    index index.html;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location /static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Troubleshooting

### Common Issues

#### 1. Installation Fails

**Error**: `npm install` fails with peer dependency errors

**Solution**:
```bash
npm install --legacy-peer-deps
```

#### 2. Cannot Connect to Backend

**Error**: Network errors, CORS errors

**Checks**:
- Verify backend is running: `curl http://localhost:8080/api/v1/store/DEFAULT`
- Check `APP_BASE_URL` in `env-config.js`
- Verify CORS is enabled on backend
- Check firewall settings

**Backend CORS Configuration** (backend side):
```java
@CrossOrigin(origins = "http://localhost:3000")
```

#### 3. Blank Page After Build

**Error**: Production build shows blank page

**Checks**:
- Check browser console for errors
- Verify `env-config.js` is accessible
- Check `homepage` in `package.json` (should be `/` or correct path)
- Verify all environment variables are set

#### 4. Payment Not Working

**Error**: Stripe/Nuvei payment fails

**Checks**:
- Verify `APP_STRIPE_KEY` is correct (test vs live)
- Check browser console for Stripe errors
- Verify backend payment configuration
- Test with Stripe test cards: 4242 4242 4242 4242

#### 5. Images Not Loading

**Error**: Product images show broken

**Checks**:
- Verify backend image URLs are correct
- Check CORS for image domain
- Verify image paths in backend response

#### 6. Port Already in Use

**Error**: `Port 3000 is already in use`

**Solution**:
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
PORT=3001 npm start
```

### Debug Mode

**Enable Verbose Logging**:

1. Open browser DevTools (F12)
2. Check Console tab for errors
3. Check Network tab for API calls

**Redux DevTools**:

1. Install Redux DevTools browser extension
2. Open DevTools
3. Select Redux tab
4. Inspect state and actions

**React DevTools**:

1. Install React DevTools browser extension
2. Open DevTools
3. Select Components tab
4. Inspect component tree and props

## Testing

### Run Tests

```bash
npm test
```

**Test Runner**: Jest with React Testing Library

**Interactive Mode**:
- Press `a` to run all tests
- Press `f` to run only failed tests
- Press `q` to quit

### Test Coverage

```bash
npm test -- --coverage
```

**Output**: Coverage report in `coverage/` directory

## Scripts Reference

| Script | Command | Description |
|--------|---------|-------------|
| dev | `npm run dev` | Start development server |
| start | `npm start` | Start development server |
| build | `npm run build` | Create production build |
| test | `npm test` | Run tests |
| eject | `npm run eject` | Eject from Create React App (irreversible) |
| integration | `npm run integration` | Run with environment injection |

## Performance Optimization

### Development Performance

**Reduce Bundle Size**:
- Use code splitting
- Lazy load routes (already implemented)
- Remove unused dependencies

**Faster Rebuilds**:
- Use `npm start` instead of `npm run build`
- Enable hot module replacement
- Close unnecessary browser tabs

### Production Performance

**Optimize Build**:
```bash
# Analyze bundle size
npm install -g source-map-explorer
npm run build
source-map-explorer build/static/js/*.js
```

**CDN Configuration**:
- Serve static assets from CDN
- Update `PUBLIC_URL` in `.env`:
```bash
PUBLIC_URL=https://cdn.yourstore.com
```

**Caching Strategy**:
- Cache static assets (1 year)
- Cache API responses (where appropriate)
- Use service worker for offline support

## Deployment Checklist

### Pre-Deployment

- [ ] Update `APP_BASE_URL` to production backend
- [ ] Update `APP_MERCHANT` to production merchant code
- [ ] Update `APP_STRIPE_KEY` to live key (not test key)
- [ ] Set `APP_PRODUCTION` to `"true"`
- [ ] Test all critical flows (browse, cart, checkout)
- [ ] Verify payment processing works
- [ ] Check mobile responsiveness
- [ ] Test on multiple browsers
- [ ] Run production build locally
- [ ] Check for console errors

### Deployment

- [ ] Build production bundle: `npm run build`
- [ ] Upload to server or build Docker image
- [ ] Configure environment variables
- [ ] Set up SSL certificate (HTTPS)
- [ ] Configure domain and DNS
- [ ] Set up CDN (optional)
- [ ] Configure monitoring and logging
- [ ] Test production deployment

### Post-Deployment

- [ ] Verify site is accessible
- [ ] Test all critical user flows
- [ ] Check analytics integration
- [ ] Monitor error logs
- [ ] Set up automated backups
- [ ] Document deployment process

## Maintenance

### Update Dependencies

**Check for Updates**:
```bash
npm outdated
```

**Update All Dependencies**:
```bash
npm update
```

**Update Specific Package**:
```bash
npm install package-name@latest
```

**Security Audit**:
```bash
npm audit
npm audit fix
```

### Backup

**Backup Configuration**:
- `public/env-config.js`
- `.env`
- Custom styles in `src/assets/scss/`
- Custom components

**Version Control**:
```bash
git add .
git commit -m "Backup before update"
git push
```

## Support and Resources

### Documentation
- React: https://reactjs.org/docs
- Redux: https://redux.js.org/
- React Router: https://reactrouter.com/
- Stripe: https://stripe.com/docs
- Bootstrap: https://getbootstrap.com/docs

### Community
- Shopizer: https://www.shopizer.com/
- GitHub Issues: (repository issues page)

### Getting Help

1. Check this documentation
2. Search existing issues on GitHub
3. Check browser console for errors
4. Review backend API logs
5. Create new issue with:
   - Error message
   - Steps to reproduce
   - Environment details (Node version, OS)
   - Screenshots (if applicable)
