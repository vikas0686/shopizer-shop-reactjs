# Architecture

## Architectural Style

**Single Page Application (SPA) with Client-Side Rendering**

The Shopizer Shop React application follows a modern SPA architecture where:
- The entire application loads as a single HTML page
- Navigation and UI updates happen client-side without full page reloads
- React Router manages client-side routing
- State is managed centrally using Redux
- Backend communication happens via RESTful API calls

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Browser/Client                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              React Application Layer                   │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │         Pages (Route Components)                 │  │  │
│  │  │  Home | Category | Product | Cart | Checkout    │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │         Wrappers (Container Components)          │  │  │
│  │  │  Header | Footer | Product Grid | Slider        │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │         Components (Presentational)              │  │  │
│  │  │  ProductCard | NavMenu | Forms | Modals         │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              State Management (Redux)                  │  │
│  │  ┌──────────┬──────────┬──────────┬──────────────┐   │  │
│  │  │ Product  │   Cart   │   User   │   Merchant   │   │  │
│  │  │  State   │  State   │  State   │    State     │   │  │
│  │  └──────────┴──────────┴──────────┴──────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐    │  │
│  │  │         Redux Actions & Reducers              │    │  │
│  │  └──────────────────────────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Service Layer                             │  │
│  │  ┌──────────────────────────────────────────────┐    │  │
│  │  │  WebService (Axios HTTP Client)               │    │  │
│  │  │  - Request Interceptors (Auth Token)          │    │  │
│  │  │  - Response Interceptors (Error Handling)     │    │  │
│  │  └──────────────────────────────────────────────┘    │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         External Integrations                          │  │
│  │  ┌──────────────┬──────────────┬──────────────────┐  │  │
│  │  │   Stripe     │    Nuvei     │  Google Maps     │  │  │
│  │  │   Payment    │   Payment    │   Geocoding      │  │  │
│  │  └──────────────┴──────────────┴──────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS/REST API
                            │
┌─────────────────────────────────────────────────────────────┐
│                   Shopizer Backend API                       │
│                    (External System)                         │
│  /api/v1/store/{merchant}/...                               │
│  /api/v1/cart/...                                           │
│  /api/v1/products/...                                       │
│  /api/v1/auth/customer/...                                  │
└─────────────────────────────────────────────────────────────┘
```

## Component Architecture

### Layered Architecture

The application follows a clear layered architecture:

**1. Presentation Layer (Pages)**
- Route-level components
- Orchestrate multiple wrappers and components
- Handle route parameters
- Manage page-level state
- Examples: Home.js, Category.js, ProductDetail.js, Checkout.js

**2. Container Layer (Wrappers)**
- Smart components with business logic
- Connect to Redux store
- Fetch data and dispatch actions
- Compose multiple presentational components
- Examples: Header.js, Footer.js, ProductGrid.js, TabProduct.js

**3. Presentation Layer (Components)**
- Dumb/stateless components
- Receive data via props
- Focus on UI rendering
- Reusable across application
- Examples: ProductGridSingle.js, NavMenu.js, FeatureIconSingle.js

**4. State Management Layer (Redux)**
- Centralized application state
- Actions define state changes
- Reducers implement state transitions
- Middleware for async operations (Redux Thunk)

**5. Service Layer (Utilities)**
- WebService: HTTP client wrapper
- Helper functions: Data formatting, validation
- Constants: API endpoints, configuration

**6. Integration Layer**
- Payment gateways (Stripe, Nuvei)
- Maps and geocoding (Google Maps)
- Analytics and tracking

## Module Interactions

### Data Flow Pattern

```
User Action → Component Event Handler → Redux Action Creator
     ↓
Redux Thunk Middleware → WebService API Call → Backend API
     ↓
API Response → Redux Reducer → State Update
     ↓
Component Re-render (via Redux connect/useSelector)
```

### Key Interaction Patterns

**1. Product Browsing**
```
Category Page → Fetch Products Action → WebService.get()
     ↓
Backend API (/api/v1/products/...) → Response
     ↓
Product Reducer → Update productData state
     ↓
ProductGrid Component → Render Products
```

**2. Add to Cart**
```
Product Component → addToCart Action → WebService.post()
     ↓
Backend API (/api/v1/cart/) → Cart Response
     ↓
Cart Reducer → Update cartData state
     ↓
Cart Cookie → Persist cart ID
     ↓
Header Cart Icon → Update cart count
```

**3. User Authentication**
```
Login Form → setUser Action → WebService.post()
     ↓
Backend API (/api/v1/auth/customer/login) → JWT Token
     ↓
LocalStorage → Store token
     ↓
Axios Interceptor → Add token to all requests
     ↓
User Reducer → Update userData state
```

**4. Checkout Process**
```
Checkout Page → Collect billing/shipping info
     ↓
Payment Component → Stripe/Nuvei SDK
     ↓
Payment Gateway → Process payment
     ↓
Checkout Action → WebService.post()
     ↓
Backend API (/api/v1/checkout) → Create order
     ↓
Order Confirmation Page → Display order details
```

## Routing Architecture

**Client-Side Routing with React Router**

```
App.js (Router Root)
  ├── / → Home
  ├── /category/:id → Category
  ├── /product/:id → ProductDetail
  ├── /search/:id → SearchProduct
  ├── /content/:id → Content
  ├── /cart → Cart
  ├── /checkout → Checkout
  ├── /order-confirm → OrderConfirm
  ├── /login → LoginRegister
  ├── /register → LoginRegister
  ├── /my-account → MyAccount
  ├── /recent-order → RecentOrder
  ├── /order-details/:id → OrderDetails
  ├── /forgot-password → ForgotPassword
  ├── /customer/:code/reset/:id → ResetPassword
  ├── /contact → Contact
  └── /* → NotFound (404)
```

**Route Protection**: Checkout and account pages require authentication (handled in component logic)

## State Management Architecture

**Redux Store Structure**

```javascript
{
  multilanguage: {
    currentLanguageCode: "en",
    translations: {...}
  },
  productData: {
    products: [],
    productID: null,
    categoryID: null
  },
  merchantData: {
    merchant: {...},
    storeCode: "DEFAULT"
  },
  cartData: {
    shopizerCartID: "cart-uuid",
    cart: {
      code: "cart-uuid",
      items: [...],
      subtotal: 0,
      total: 0
    }
  },
  userData: {
    user: {...},
    countries: [],
    shippingCountries: [],
    states: [],
    shippingStates: [],
    currentAddress: []
  },
  content: {
    content: {...}
  },
  loading: {
    isLoading: false
  }
}
```

## Deployment Architecture

**Docker Multi-Stage Build**

```
Stage 1: Build
  - Node.js 13.12.0-alpine
  - Install dependencies
  - Build React app (npm run build)
  - Output: /app/build

Stage 2: Production
  - Nginx stable-alpine
  - Copy build artifacts
  - Copy nginx configuration
  - Inject environment variables at runtime
  - Expose port 80
```

**Runtime Configuration**
- Environment variables injected via env.sh script
- Configuration stored in window._env_ object
- Allows same Docker image for multiple environments

## Security Architecture

**1. Authentication**
- JWT token-based authentication
- Token stored in localStorage
- Token included in all API requests via Axios interceptor

**2. Payment Security**
- PCI-compliant payment gateways (Stripe, Nuvei)
- Payment details never stored in application
- Tokenized payment processing

**3. Data Protection**
- HTTPS for all API communication
- Sensitive data not logged
- Password hashing handled by backend

**4. Session Management**
- Cart persistence via secure cookies
- Session timeout for authenticated users
- Idle timer for automatic logout

## Scalability Considerations

**1. Frontend Scalability**
- Static assets served via CDN
- Code splitting with React lazy loading
- Optimized bundle size
- Nginx caching for static content

**2. API Scalability**
- Stateless API calls
- Backend handles scaling independently
- Client-side caching where appropriate

**3. Performance Optimization**
- Lazy loading of route components
- Image optimization
- Pagination for large datasets
- Debouncing for search inputs

## Technology Decisions

**Why React?**
- Component-based architecture for reusability
- Large ecosystem and community support
- Virtual DOM for performance
- SEO-friendly with SSR capabilities

**Why Redux?**
- Centralized state management
- Predictable state updates
- Time-travel debugging
- Middleware support for async operations

**Why Axios?**
- Promise-based HTTP client
- Request/response interceptors
- Automatic JSON transformation
- Browser and Node.js support

**Why Docker?**
- Consistent deployment across environments
- Easy scaling and orchestration
- Isolated runtime environment
- Multi-stage builds for optimization
