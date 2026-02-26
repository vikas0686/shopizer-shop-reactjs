# Technical Details

## Technology Stack

### Core Technologies

**Frontend Framework**
- **React**: 16.6.0
  - Component-based UI library
  - Virtual DOM for performance
  - Hooks for state management
  - Lazy loading support

**State Management**
- **Redux**: 4.0.4
  - Centralized state container
  - Predictable state updates
  - Time-travel debugging
- **Redux Thunk**: 2.3.0
  - Middleware for async actions
  - Side effect management
- **redux-localstorage-simple**: 2.1.6
  - Persist Redux state to localStorage
  - Automatic state hydration
- **redux-multilanguage**: 0.1.2
  - Multi-language support
  - Translation management

**Routing**
- **React Router DOM**: 5.1.2
  - Client-side routing
  - Dynamic route matching
  - Route parameters and query strings
  - Programmatic navigation

**HTTP Client**
- **Axios**: 0.21.1
  - Promise-based HTTP client
  - Request/response interceptors
  - Automatic JSON transformation
  - Error handling

### UI and Styling

**CSS Framework**
- **Bootstrap**: 4.5.0
  - Responsive grid system
  - Pre-built components
  - Utility classes
- **React Bootstrap**: 1.0.1
  - Bootstrap components as React components
  - Accordion, Card, Modal, etc.

**Styling**
- **SASS**: 1.29.0
  - CSS preprocessor
  - Variables and mixins
  - Nested rules
  - Modular stylesheets
- **Animate.css**: 3.7.2
  - CSS animation library
  - Pre-built animations

**UI Components**
- **react-id-swiper**: 4.0.0 (with Swiper 5.4.1)
  - Touch-enabled slider/carousel
  - Product image galleries
  - Hero sliders
- **react-lightgallery**: 0.6.3
  - Image lightbox gallery
  - Zoom and navigation
- **react-modal-video**: 1.2.3
  - Video modal player
- **react-spinners**: 0.9.0
  - Loading indicators
- **react-star-ratings**: 2.3.0
  - Star rating display
- **react-countdown-now**: 2.1.2
  - Countdown timer component
- **react-countup**: 4.2.3
  - Animated number counter

### Form Management

**Form Libraries**
- **react-hook-form**: 6.13.1
  - Form validation
  - Form state management
  - Performance optimized
  - Minimal re-renders

**Validation**
- Built-in validation rules
- Custom validation functions
- Error message handling
- Field-level validation

### Payment Integration

**Stripe**
- **@stripe/stripe-js**: 1.11.0
  - Stripe JavaScript SDK
  - Payment element loading
- **@stripe/react-stripe-js**: 1.1.2
  - React components for Stripe
  - CardElement component
  - Payment form integration

**Nuvei**
- Configuration via environment variables
- Terminal ID and secret management
- Custom integration implementation

### Maps and Location

**Google Maps**
- **google-maps-react**: 2.0.6
  - Google Maps React wrapper
  - Map component integration
- **react-geocode**: 0.2.2
  - Geocoding service
  - Address to coordinates conversion
  - Reverse geocoding

### Utilities and Helpers

**Data Handling**
- **moment**: 2.29.1
  - Date/time manipulation
  - Date formatting
  - Relative time display
- **uuid**: 3.3.3
  - Unique ID generation
  - Cart and session IDs

**Security**
- **js-sha512**: 0.8.0
  - SHA-512 hashing
  - Password hashing (client-side)

**Cookies**
- **universal-cookie**: 4.0.4
  - Cookie management
  - Cart persistence
  - Cross-platform support

**Notifications**
- **react-toast-notifications**: 2.2.5
  - Toast notification system
  - Success/error messages
  - Auto-dismiss functionality
- **react-bootstrap-sweetalert**: 5.2.0
  - Alert dialogs
  - Confirmation modals

**Navigation and UX**
- **react-breadcrumbs-dynamic**: 1.2.1
  - Dynamic breadcrumb navigation
  - Route-based breadcrumbs
- **react-scroll**: 1.7.14
  - Smooth scrolling
  - Scroll-to-element functionality
- **react-sticky-el**: 1.1.0
  - Sticky elements
  - Fixed headers/sidebars
- **react-visibility-sensor**: 5.1.1
  - Viewport visibility detection
  - Lazy loading trigger
- **react-idle-timer**: 4.5.2
  - User inactivity detection
  - Auto-logout functionality

**Other Utilities**
- **react-meta-tags**: 1.0.1
  - Dynamic meta tags
  - SEO optimization
- **react-to-print**: 2.12.3
  - Print functionality
  - Order printing
- **react-load-script**: 0.0.6
  - Dynamic script loading
  - Third-party script integration
- **react-cookie-consent**: 6.2.1
  - Cookie consent banner
  - GDPR compliance
- **react-custom-scrollbars-2**: 4.4.0
  - Custom scrollbar styling
- **react-fullpage**: 0.1.19
  - Full-page scrolling
- **react-paginate**: 7.0.0
  - Pagination component
  - Page navigation

### Build and Development Tools

**Build Tool**
- **Create React App**: 4.0.1 (react-scripts)
  - Zero-configuration setup
  - Webpack bundling
  - Babel transpilation
  - Development server
  - Production optimization

**Development Tools**
- **redux-devtools-extension**: 2.13.8
  - Redux DevTools integration
  - State inspection
  - Action replay

**Polyfills**
- **react-app-polyfill**: 1.0.4
  - IE11 support
  - Stable polyfills

**Node Version**
- **Tested with**: Node v16.13.0
- **Recommended**: Node 13.12.0+ (per Dockerfile)

## Frameworks and Libraries

### React Ecosystem

**Component Libraries**
- Bootstrap React components for consistent UI
- Custom components for e-commerce specific needs
- Reusable component library structure

**State Management Ecosystem**
- Redux for global state
- React hooks (useState, useEffect) for local state
- Context API for theme and language

**Routing Ecosystem**
- React Router for navigation
- Dynamic route parameters
- Programmatic navigation with useHistory
- Route guards for protected pages

### Third-Party Integrations

**Payment Gateways**
1. **Stripe**
   - PCI-compliant payment processing
   - Card element integration
   - Payment intent API
   - Webhook support (backend)

2. **Nuvei**
   - Alternative payment gateway
   - Terminal-based configuration
   - Custom integration

**Maps and Geocoding**
- Google Maps JavaScript API
- Geocoding API for address validation
- Location services for shipping

**Analytics** (Configurable)
- Google Analytics integration ready
- Event tracking capability
- E-commerce tracking

## Database Usage

**Client-Side Storage**

**1. LocalStorage**
- Redux state persistence
- User authentication token
- User preferences
- Language selection

**2. Cookies**
- Cart ID persistence (6 months expiry)
- Session management
- Cookie consent tracking

**3. Session Storage**
- Temporary data storage
- Form data preservation

**Note**: No direct database access from frontend. All data operations go through Shopizer backend API.

## Configuration Management

### Environment Configuration

**Configuration File**: `public/env-config.js`

```javascript
window._env_ = {
  APP_PRODUCTION: "false",
  APP_BASE_URL: "http://localhost:8080",
  APP_API_VERSION: "/api/v1/",
  APP_MERCHANT: "DEFAULT",
  APP_PRODUCT_GRID_LIMIT: "15",
  APP_MAP_API_KEY: "",
  APP_NUVEI_TERMINAL_ID: "",
  APP_NUVEI_SECRET: "",
  APP_PAYMENT_TYPE: "STRIPE",
  APP_STRIPE_KEY: "pk_test_...",
  APP_THEME_COLOR: "#D1D1D1"
}
```

**Configuration Parameters**:

| Parameter | Description | Default |
|-----------|-------------|---------|
| APP_PRODUCTION | Production mode flag | false |
| APP_BASE_URL | Shopizer backend API URL | http://localhost:8080 |
| APP_API_VERSION | API version path | /api/v1/ |
| APP_MERCHANT | Merchant/store code | DEFAULT |
| APP_PRODUCT_GRID_LIMIT | Products per page | 15 |
| APP_MAP_API_KEY | Google Maps API key | (empty) |
| APP_NUVEI_TERMINAL_ID | Nuvei terminal ID | (empty) |
| APP_NUVEI_SECRET | Nuvei secret key | (empty) |
| APP_PAYMENT_TYPE | Payment gateway (STRIPE/NUVEI) | STRIPE |
| APP_STRIPE_KEY | Stripe publishable key | (test key) |
| APP_THEME_COLOR | Primary theme color | #D1D1D1 |

**Configuration Loading**:
1. Configuration loaded from `public/env-config.js`
2. Accessible via `window._env_` object
3. Can be overridden at runtime (Docker deployment)
4. Environment-specific configuration without rebuild

**Docker Configuration**:
- `.env` file for environment variables
- `env.sh` script injects variables into `env-config.js`
- Runtime configuration injection
- Same Docker image for all environments

### Build Configuration

**package.json Scripts**:
```json
{
  "dev": "react-scripts start",
  "start": "react-scripts start",
  "build": "react-scripts build",
  "test": "react-scripts test",
  "eject": "react-scripts eject",
  "integration": "chmod +x ./env.sh && ./env.sh && cp env-config.js ./public/ && react-scripts start"
}
```

**Browser Support**:
```json
{
  "production": [
    ">0.2%",
    "not dead",
    "not op_mini all",
    "ie 11"
  ],
  "development": [
    "last 1 chrome version",
    "last 1 firefox version",
    "last 1 safari version",
    "ie 11"
  ]
}
```

## External Integrations

### Shopizer Backend API

**Base URL**: Configured via `APP_BASE_URL`

**API Version**: `/api/v1/`

**Authentication**: JWT Bearer token

**Key Endpoints**:

**Store/Merchant**
- `GET /store/{merchant}` - Get store configuration

**Products**
- `GET /products/?store={merchant}&lang={lang}` - List products
- `GET /product/{id}?store={merchant}&lang={lang}` - Get product details
- `GET /products/group/{group}?store={merchant}` - Get product group
- `GET /search/{query}?store={merchant}` - Search products

**Categories**
- `GET /category/{id}?store={merchant}&lang={lang}` - Get category
- `GET /category/?store={merchant}&lang={lang}` - List categories

**Cart**
- `POST /cart/?store={merchant}` - Create cart
- `GET /cart/{cartId}?lang={lang}` - Get cart
- `PUT /cart/{cartId}?store={merchant}` - Update cart
- `DELETE /cart/{cartId}/product/{itemId}?store={merchant}` - Remove item

**Customer**
- `POST /customers/register?store={merchant}` - Register customer
- `POST /auth/customer/login/?store={merchant}` - Login
- `GET /auth/customer/profile` - Get profile (authenticated)
- `PUT /auth/customer/profile` - Update profile (authenticated)
- `GET /auth/customer/cart?cart={cartId}&lang={lang}` - Get customer cart
- `GET /auth/customer/orders/` - Get order history
- `GET /auth/customer/orders/{orderId}` - Get order details

**Checkout**
- `POST /auth/customer/checkout` - Place order (authenticated)
- `GET /shipping?store={merchant}` - Get shipping methods
- `POST /total/?store={merchant}` - Calculate order total

**Address**
- `GET /country/?store={merchant}&lang={lang}` - List countries
- `GET /shipping/country?store={merchant}&lang={lang}` - Shipping countries
- `GET /zones/?code={countryCode}` - Get states/provinces

**Content**
- `GET /content/pages/{id}?store={merchant}&lang={lang}` - Get content page
- `GET /content/boxes/{code}?store={merchant}` - Get content box

**Other**
- `POST /contact/?store={merchant}` - Contact form submission
- `POST /newsletter/?store={merchant}` - Newsletter subscription
- `POST /customer/password/request/?store={merchant}` - Password reset request
- `POST /customer/password/reset/{code}` - Password reset

**Request Headers**:
```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

**Response Format**: JSON

### Stripe Integration

**SDK**: @stripe/stripe-js, @stripe/react-stripe-js

**Configuration**: `APP_STRIPE_KEY` (publishable key)

**Components Used**:
- `Elements` provider
- `CardElement` for card input
- `useStripe` hook
- `useElements` hook

**Payment Flow**:
1. Load Stripe with publishable key
2. Render CardElement in checkout form
3. Collect payment details
4. Create payment method
5. Send payment method to backend
6. Backend processes payment with Stripe API
7. Return order confirmation

### Nuvei Integration

**Configuration**:
- `APP_NUVEI_TERMINAL_ID`
- `APP_NUVEI_SECRET`

**Integration**: Custom implementation via script loading

### Google Maps Integration

**APIs Used**:
- Google Maps JavaScript API
- Geocoding API

**Configuration**: `APP_MAP_API_KEY`

**Features**:
- Display store location on contact page
- Geocode user location
- Address validation
- Reverse geocoding

**Components**:
- `LocationMap` component for map display
- `react-geocode` for geocoding services

## API Communication Patterns

### Request Interceptor

```javascript
axios.interceptors.request.use(async (config) => {
  config.baseURL = BASE_URL;
  const token = await getLocalData("token");
  config.headers.common['Authorization'] = token ? 'Bearer ' + token : '';
  return config;
});
```

**Purpose**:
- Set base URL dynamically
- Add authentication token to all requests
- Centralized request configuration

### Response Interceptor

```javascript
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;
    if (response.status === 401 || response.status === 404) {
      return Promise.reject(error);
    }
    return Promise.reject(error);
  }
);
```

**Purpose**:
- Handle authentication errors (401)
- Handle not found errors (404)
- Centralized error handling

### Error Handling

**Patterns**:
1. Try-catch in async actions
2. Error state in reducers
3. Toast notifications for user feedback
4. Loader state management
5. Fallback UI for errors

## Security Considerations

**1. Authentication**
- JWT token stored in localStorage
- Token included in all authenticated requests
- Token expiration handled by backend
- Automatic logout on token expiry

**2. Payment Security**
- PCI-compliant payment gateways
- No card data stored in application
- Tokenized payment processing
- HTTPS for all payment transactions

**3. Data Protection**
- No sensitive data in localStorage
- Passwords hashed before transmission
- HTTPS for all API communication
- CORS configuration on backend

**4. XSS Prevention**
- React's built-in XSS protection
- Sanitized user input
- No dangerouslySetInnerHTML usage

**5. CSRF Protection**
- Stateless API (no session cookies)
- JWT token-based authentication
- Backend CSRF protection

## Performance Optimization

**1. Code Splitting**
- Lazy loading of route components
- Dynamic imports with React.lazy
- Suspense for loading states

**2. Bundle Optimization**
- Tree shaking (unused code removal)
- Minification in production
- Gzip compression (Nginx)

**3. Image Optimization**
- Responsive images
- Lazy loading images
- CDN for image delivery

**4. Caching**
- Browser caching for static assets
- Redux state persistence
- API response caching (where appropriate)

**5. Rendering Optimization**
- React.memo for expensive components
- useMemo for expensive calculations
- useCallback for function memoization
- Virtual scrolling for large lists

## Deployment Configuration

### Docker Configuration

**Dockerfile**:
- Multi-stage build (Node + Nginx)
- Stage 1: Build React app
- Stage 2: Serve with Nginx
- Runtime environment injection

**Nginx Configuration**:
- Gzip compression
- Static file caching
- SPA routing support (fallback to index.html)
- Port 80 exposure

**Environment Variables**:
- Injected at container startup
- `env.sh` script for injection
- No rebuild required for config changes

### CI/CD

**CircleCI Configuration**: `.circleci/config.yml`
- Automated build pipeline
- Test execution
- Docker image building
- Deployment automation
