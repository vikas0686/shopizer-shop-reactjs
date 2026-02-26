# High-Level Design

## System Overview

The Shopizer Shop React application is a client-side e-commerce storefront that provides a complete shopping experience. It is designed as a decoupled frontend that communicates with the Shopizer backend API, following a clear separation of concerns with distinct layers for presentation, business logic, state management, and data access.

## Component Responsibilities

### 1. Application Core (App.js)

**Responsibility**: Application bootstrap and routing configuration

**Key Functions**:
- Initialize Redux store connection
- Configure multi-language support
- Set up routing with React Router
- Initialize cart from cookies on app load
- Apply theme customization from configuration
- Provide global context (Toast, Breadcrumbs)

**Dependencies**: Redux store, Router, Language provider

### 2. Page Components (src/pages/)

**Responsibility**: Route-level orchestration and page composition

**Major Pages**:

**Home Page**
- Displays hero slider with promotional banners
- Shows featured products in tabs
- Renders promotional sections
- Newsletter subscription
- Entry point for product discovery

**Category Page**
- Lists products for selected category
- Provides filtering (manufacturer, color, size)
- Supports sorting (price, name, newest)
- Pagination for large product sets
- Sidebar with category tree and filters
- Grid/list view toggle

**Product Detail Page**
- Displays product images in gallery
- Shows product information and pricing
- Variant selection (size, color, options)
- Add to cart functionality
- Related products display
- Product reviews and ratings

**Cart Page**
- Lists cart items with images and details
- Quantity adjustment controls
- Remove item functionality
- Cart totals calculation
- Coupon/promo code application
- Proceed to checkout button

**Checkout Page**
- Billing address form
- Shipping address form (optional different address)
- Shipping method selection
- Payment method selection
- Payment details collection (Stripe/Nuvei)
- Order review and confirmation
- Order placement

**My Account Page**
- Account information management
- Billing/shipping address management
- Password change functionality
- Order history display
- Profile update forms

**Order Details Page**
- Detailed order information
- Order items with pricing
- Shipping and billing addresses
- Order status tracking
- Print order functionality

**Login/Register Page**
- Customer login form
- New customer registration form
- Form validation
- Password strength requirements

### 3. Wrapper Components (src/wrappers/)

**Responsibility**: Container components that connect to Redux and compose multiple child components

**Header Wrapper**
- Navigation menu with category links
- Logo and branding
- Search functionality
- User account menu
- Shopping cart icon with item count
- Language selector
- Mobile menu toggle

**Footer Wrapper**
- Footer navigation links
- Newsletter subscription
- Contact information
- Social media links
- Copyright information

**Product Grid Wrapper**
- Fetches products from API
- Renders product cards in grid layout
- Handles pagination
- Manages loading states
- Connects to Redux for product data

**Tab Product Wrapper**
- Displays products in tabbed interface
- Fetches product groups
- Renders product sliders
- Handles tab switching

**Hero Slider Wrapper**
- Displays promotional banners
- Fetches banner content from API
- Implements carousel functionality
- Responsive image handling

**Promos Wrapper**
- Displays promotional boxes
- Fetches promo content
- Renders promo cards

### 4. Presentational Components (src/components/)

**Responsibility**: Pure UI components that receive data via props

**Product Components**:
- ProductGridSingle: Individual product card
- ProductGridListSingle: Product in list view
- ProductImageGallery: Product image viewer
- ProductDescriptionInfo: Product details and add to cart
- ProductModal: Quick view modal
- ShopCategories: Category filter list
- ShopManufacture: Manufacturer filter
- ShopColor: Color filter
- ShopSize: Size filter
- ShopTopFilter: Sort and filter controls

**Header Components**:
- NavMenu: Main navigation
- MobileMenu: Mobile navigation
- IconGroup: Header icons (search, cart, account)
- HeaderTop: Top bar with language/currency
- Logo: Brand logo component
- OffcanvasMenu: Slide-out menu

**Footer Components**:
- FooterCopyright: Copyright text
- FooterNewsletter: Newsletter form

**Other Components**:
- HeroSliderSingle: Individual slider item
- FeatureIconSingle: Feature icon card
- PromosSingle: Promotional box
- SectionTitle: Section heading
- SubscribeEmail: Newsletter subscription
- LocationMap: Google Maps integration
- Loader: Loading spinner
- Cookie: Cookie consent banner

### 5. Redux State Management (src/redux/)

**Responsibility**: Centralized state management and business logic

**Actions** (src/redux/actions/):

**cartActions.js**
- addToCart: Add product to cart with options
- getCart: Fetch cart from API
- setShopizerCartID: Store cart ID in cookie
- deleteFromCart: Remove item from cart
- deleteAllFromCart: Clear cart

**productActions.js**
- fetchProducts: Store products in state
- setProductID: Set current product
- setCategoryID: Set current category

**userAction.js**
- setUser: Store user data after login
- getCountry: Fetch country list
- getShippingCountry: Fetch shipping countries
- getState: Fetch states/provinces
- getCurrentLocation: Get user's geolocation
- getCurrentAddress: Geocode coordinates to address

**storeAction.js**
- setMerchant: Fetch and store merchant configuration
- setStore: Set current store code

**loaderActions.js**
- setLoader: Show/hide loading indicator

**contentAction.js**
- Content-related actions

**Reducers** (src/redux/reducers/):

**cartReducer.js**
- Manages cart state
- Handles cart ID persistence
- Updates cart items

**productReducer.js**
- Stores product list
- Tracks current product/category

**userReducer.js**
- Stores user authentication state
- Manages address data
- Stores country/state lists

**storeReducer.js**
- Stores merchant configuration
- Manages store settings

**loaderReducer.js**
- Controls loading state

**contentReducer.js**
- Manages content pages

**rootReducer.js**
- Combines all reducers
- Configures multi-language reducer

### 6. Service Layer (src/util/)

**Responsibility**: API communication and utility functions

**webService.js**
- Axios wrapper for HTTP requests
- Request interceptor: Adds auth token
- Response interceptor: Handles errors
- Methods: get, post, put, delete, patch
- Base URL configuration from environment

**constant.js**
- API endpoint constants
- Centralized endpoint definitions
- Prevents hardcoded URLs

**helper.js**
- setLocalData: Store data in localStorage
- getLocalData: Retrieve data from localStorage
- isValidObject: Object validation
- isCheckValueAndSetParams: Query parameter builder

### 7. Layout Components (src/layouts/)

**Responsibility**: Page layout structure

**Layout.js**
- Wraps page content
- Includes Header and Footer
- Provides consistent page structure
- Accepts layout configuration props

## Service Boundaries

### Frontend-Backend Boundary

**Frontend Responsibilities**:
- User interface rendering
- Client-side routing
- Form validation
- State management
- Session management (cart cookies)
- Payment UI integration
- Image optimization and display

**Backend Responsibilities** (Shopizer API):
- Business logic execution
- Data persistence
- Authentication and authorization
- Payment processing
- Order management
- Inventory management
- Email notifications
- Product catalog management

**Communication Protocol**:
- RESTful HTTP/HTTPS
- JSON data format
- JWT token authentication
- Stateless requests

### External Service Boundaries

**Payment Gateways (Stripe/Nuvei)**:
- Payment tokenization
- Payment processing
- PCI compliance
- Transaction management

**Google Maps API**:
- Geocoding services
- Address validation
- Location services

## Layered Design

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  - Pages (Route Components)                             │
│  - Wrappers (Container Components)                      │
│  - Components (Presentational)                          │
│  - Layouts                                              │
│                                                          │
│  Responsibility: User interface and user interaction    │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  State Management Layer                  │
│  - Redux Store                                          │
│  - Actions (Action Creators)                            │
│  - Reducers (State Transitions)                         │
│  - Middleware (Redux Thunk)                             │
│                                                          │
│  Responsibility: Application state and business logic   │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                     Service Layer                        │
│  - WebService (HTTP Client)                             │
│  - Helper Functions                                     │
│  - Constants                                            │
│                                                          │
│  Responsibility: API communication and utilities        │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                   Integration Layer                      │
│  - Shopizer Backend API                                 │
│  - Payment Gateways (Stripe, Nuvei)                     │
│  - Google Maps API                                      │
│                                                          │
│  Responsibility: External system integration            │
└─────────────────────────────────────────────────────────┘
```

## Dependency Flow

**Unidirectional Data Flow**:

```
User Interaction (Component)
    ↓
Event Handler
    ↓
Redux Action Dispatch
    ↓
Redux Thunk Middleware (Async Logic)
    ↓
Service Layer (API Call)
    ↓
Backend API
    ↓
Response
    ↓
Redux Reducer (State Update)
    ↓
Redux Store
    ↓
Component Re-render (via connect/hooks)
    ↓
Updated UI
```

**Dependency Rules**:
1. Components depend on Redux state (via connect/hooks)
2. Actions depend on Service layer
3. Service layer depends on external APIs
4. Reducers are pure functions (no side effects)
5. Components never directly call services
6. State updates only through Redux actions

## Scalability Considerations

### Code Scalability

**1. Component Reusability**
- Presentational components are highly reusable
- Props-based configuration
- No hardcoded business logic in UI components

**2. State Management**
- Modular reducers (easy to add new state slices)
- Action creators centralized
- Middleware for cross-cutting concerns

**3. Code Splitting**
- Lazy loading of route components
- Reduces initial bundle size
- Faster initial page load

**4. Modular Structure**
- Clear separation of concerns
- Easy to add new features
- Independent module testing

### Performance Scalability

**1. Rendering Optimization**
- React.memo for expensive components
- Lazy loading for off-screen content
- Virtual scrolling for large lists

**2. Network Optimization**
- Axios interceptors for caching
- Debouncing for search inputs
- Pagination for large datasets

**3. State Optimization**
- Normalized state structure
- Selective component updates
- Memoized selectors

### Deployment Scalability

**1. Horizontal Scaling**
- Stateless application (scales easily)
- Docker containerization
- Load balancer compatible

**2. CDN Integration**
- Static assets served from CDN
- Reduced server load
- Global content delivery

**3. Environment Flexibility**
- Runtime configuration injection
- Same build for all environments
- Easy multi-tenant deployment

## Extension Points

### Adding New Features

**1. New Page/Route**
```
1. Create page component in src/pages/
2. Add route in App.js
3. Create necessary actions/reducers if needed
4. Add navigation link in Header/Footer
```

**2. New Product Filter**
```
1. Create filter component in src/components/product/
2. Add filter state to Category page
3. Update API call with filter parameters
4. Add filter UI to ShopSidebar
```

**3. New Payment Gateway**
```
1. Add payment configuration to env-config.js
2. Create payment component in src/components/
3. Update Checkout page with new payment option
4. Add payment processing logic in checkout action
```

**4. New Language**
```
1. Create translation file in src/translations/
2. Add language to multilanguage configuration in App.js
3. Add language option to HeaderTop component
```

**5. New API Endpoint**
```
1. Add endpoint constant to src/util/constant.js
2. Create action in appropriate action file
3. Update reducer to handle new action
4. Connect component to new state
```

### Customization Points

**1. Theme Customization**
- SASS variables in src/assets/scss/
- Theme color via APP_THEME_COLOR environment variable
- Bootstrap theme overrides

**2. Layout Customization**
- Layout component accepts configuration props
- Header/Footer can be customized per page
- Responsive breakpoints configurable

**3. Multi-Tenant Support**
- APP_MERCHANT environment variable
- Store-specific configuration from API
- Dynamic branding and content

## Design Patterns Used

**1. Container/Presentational Pattern**
- Wrappers = Containers (smart components)
- Components = Presentational (dumb components)
- Clear separation of concerns

**2. Higher-Order Components (HOC)**
- multilanguage HOC for translations
- connect HOC for Redux integration

**3. Render Props**
- Stripe Elements consumer
- React Router render props

**4. Hooks Pattern**
- useState for local state
- useEffect for side effects
- useForm for form management
- Custom hooks for reusable logic

**5. Middleware Pattern**
- Redux Thunk for async actions
- Axios interceptors for cross-cutting concerns

**6. Observer Pattern**
- Redux store subscription
- Component re-rendering on state changes

**7. Factory Pattern**
- WebService methods (get, post, put, delete)
- Consistent API interface

**8. Singleton Pattern**
- Redux store (single source of truth)
- Axios instance configuration
