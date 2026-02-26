# Module Breakdown

## Directory Structure

```
shopizer-shop-reactjs/
├── public/                    # Static assets and HTML template
├── src/                       # Source code
│   ├── assets/               # Styles, fonts, images
│   ├── components/           # Presentational components
│   ├── data/                 # Static data files
│   ├── helpers/              # Helper functions
│   ├── layouts/              # Layout components
│   ├── pages/                # Route-level page components
│   ├── redux/                # Redux state management
│   ├── translations/         # Language files
│   ├── util/                 # Utility functions
│   ├── wrappers/             # Container components
│   ├── App.js                # Root application component
│   └── index.js              # Application entry point
├── conf/                      # Nginx configuration
├── .env                       # Environment variables
├── env-config.js             # Runtime configuration
├── Dockerfile                # Docker build configuration
└── package.json              # Dependencies and scripts
```

## Core Modules

### 1. Application Entry (src/)

#### index.js
**Purpose**: Application bootstrap and initialization

**Responsibilities**:
- Create Redux store with middleware
- Configure Redux DevTools
- Load persisted state from localStorage
- Render root App component
- Register service worker

**Key Code**:
```javascript
const store = createStore(
  rootReducer,
  load(),
  composeWithDevTools(applyMiddleware(thunk, save()))
);
```

**Dependencies**: Redux, Redux Thunk, react-dom

#### App.js
**Purpose**: Root application component and routing configuration

**Responsibilities**:
- Configure React Router with all routes
- Initialize multi-language support
- Load cart from cookies on mount
- Apply theme customization
- Provide global context (Toast, Breadcrumbs)
- Lazy load page components

**Key Routes**:
- `/` → Home
- `/category/:id` → Category
- `/product/:id` → ProductDetail
- `/cart` → Cart
- `/checkout` → Checkout
- `/my-account` → MyAccount
- `/login`, `/register` → LoginRegister

**Dependencies**: React Router, Redux, multilanguage

### 2. Pages Module (src/pages/)

#### Home (pages/home/Home.js)
**Purpose**: Landing page with featured content

**Components Used**:
- HeroSlider: Promotional banners
- Promo: Promotional boxes
- TabProduct: Featured products in tabs
- Newsletter: Email subscription

**Data Flow**: Fetches merchant configuration, displays static and dynamic content

#### Category (pages/category/Category.js)
**Purpose**: Product listing with filtering and sorting

**Responsibilities**:
- Fetch products for category
- Implement filtering (manufacturer, color, size)
- Implement sorting (price, name, date)
- Pagination
- Grid/list view toggle

**State Management**:
- Local state for filters, pagination, layout
- Redux for category ID
- API calls for product data

**Key Features**:
- Dynamic filter options from API
- URL parameter-based filtering
- Responsive grid layout

#### ProductDetail (pages/product-details/ProductDetail.js)
**Purpose**: Single product display with purchase options

**Components Used**:
- ProductImageDescription: Main product info
- ProductDescriptionTab: Detailed tabs
- RelatedProductSlider: Cross-sell products

**Responsibilities**:
- Fetch product details by ID
- Display product images, description, pricing
- Handle variant selection
- Add to cart functionality

#### Cart (pages/other/Cart.js)
**Purpose**: Shopping cart management

**Responsibilities**:
- Display cart items with images and details
- Update item quantities
- Remove items from cart
- Calculate totals
- Apply coupon codes
- Navigate to checkout

**State Management**:
- Redux cart state
- API calls for cart updates

**Key Features**:
- Real-time total calculation
- Persistent cart via cookies
- Empty cart handling

#### Checkout (pages/other/Checkout.js)
**Purpose**: Order placement and payment processing

**Responsibilities**:
- Collect billing address
- Collect shipping address
- Calculate shipping costs
- Select payment method
- Process payment (Stripe/Nuvei)
- Create order
- Navigate to confirmation

**Form Management**:
- react-hook-form for validation
- Multi-step form flow
- Address validation

**Payment Integration**:
- Stripe Elements for card input
- Nuvei script loading
- Payment method selection

**State Management**:
- Local state for form data
- Redux for user and cart data
- API calls for checkout process

#### MyAccount (pages/other/MyAccount.js)
**Purpose**: Customer account management

**Responsibilities**:
- Display account information
- Update profile (name, email, phone)
- Manage billing addresses
- Manage shipping addresses
- Change password
- View order history
- Delete account

**Features**:
- Accordion-based sections
- Form validation
- Address CRUD operations
- Password strength validation

#### LoginRegister (pages/other/LoginRegister.js)
**Purpose**: Authentication

**Responsibilities**:
- Customer login
- New customer registration
- Form validation
- Token storage
- Redirect after login

**Validation Rules**:
- Email format validation
- Password strength requirements
- Required field validation

#### OrderDetails (pages/other/OrderDetails.js)
**Purpose**: Display order information

**Responsibilities**:
- Fetch order by ID
- Display order items
- Show billing/shipping addresses
- Display order status
- Print order functionality

#### Other Pages:
- **OrderConfirm**: Order confirmation after successful checkout
- **RecentOrder**: List of customer's recent orders
- **Contact**: Contact form with map
- **ForgotPassword**: Password reset request
- **ResetPassword**: Password reset with token
- **NotFound**: 404 error page
- **Content**: Dynamic content pages
- **SearchProduct**: Product search results

### 3. Wrappers Module (src/wrappers/)

**Purpose**: Container components that connect to Redux and compose child components

#### Header (wrappers/header/Header.js)
**Purpose**: Site header with navigation

**Components**:
- HeaderTop: Language selector, currency
- Logo: Brand logo
- NavMenu: Main navigation
- IconGroup: Search, cart, account icons
- MobileMenu: Mobile navigation

**State**: Connected to Redux for cart count, user state

#### Footer (wrappers/footer/Footer.js)
**Purpose**: Site footer

**Components**:
- Footer navigation links
- FooterNewsletter: Email subscription
- FooterCopyright: Copyright text

**Data**: Fetches footer content from API

#### Product Wrappers:

**ProductGrid** (wrappers/product/ProductGrid.js)
- Renders product cards in grid layout
- Handles pagination
- Supports grid/list view

**TabProduct** (wrappers/product/TabProduct.js)
- Displays products in tabbed interface
- Fetches product groups
- Implements product sliders

**ProductImageDescription** (wrappers/product/ProductImageDescription.js)
- Product image gallery
- Product information
- Add to cart form
- Variant selection

**ProductDescriptionTab** (wrappers/product/ProductDescriptionTab.js)
- Product description tab
- Specifications tab
- Reviews tab

**ShopSidebar** (wrappers/product/ShopSidebar.js)
- Category filter
- Manufacturer filter
- Color filter
- Size filter

**ShopTopbar** (wrappers/product/ShopTopbar.js)
- Sort controls
- View toggle (grid/list)
- Results count

**RelatedProductSlider** (wrappers/product/RelatedProductSlider.js)
- Related products carousel
- Cross-sell functionality

#### Other Wrappers:

**HeroSlider** (wrappers/hero-slider/HeroSlider.js)
- Homepage banner carousel
- Fetches banner content from API

**Promos** (wrappers/promos/Promos.js)
- Promotional boxes
- Fetches promo content from API

**Newsletter** (wrappers/newsletter/Newsletter.js)
- Newsletter subscription form

**Breadcrumb** (wrappers/breadcrumb/Breadcrumb.js)
- Dynamic breadcrumb navigation

### 4. Components Module (src/components/)

**Purpose**: Presentational components (dumb components)

#### Product Components (components/product/)

**ProductGridSingle.js**
- Individual product card for grid view
- Product image, name, price
- Quick view button
- Add to cart button
- Wishlist button

**ProductGridListSingle.js**
- Product card for list view
- Extended product information
- Horizontal layout

**ProductImageGallery.js**
- Product image viewer
- Thumbnail navigation
- Zoom functionality
- Lightbox integration

**ProductDescriptionInfo.js**
- Product details display
- Variant selection (size, color)
- Quantity selector
- Add to cart button
- Product options

**ProductModal.js**
- Quick view modal
- Product preview
- Add to cart from modal

**Shop Filter Components**:
- **ShopCategories.js**: Category filter list
- **ShopManufacture.js**: Manufacturer filter
- **ShopColor.js**: Color filter
- **ShopSize.js**: Size filter
- **ShopTag.js**: Tag filter
- **ShopTopFilter.js**: Sort and filter controls
- **ShopTopAction.js**: View toggle and actions

#### Header Components (components/header/)

**NavMenu.js**
- Main navigation menu
- Category links
- Dropdown menus

**MobileMenu.js**
- Mobile navigation
- Hamburger menu
- Collapsible categories

**IconGroup.js**
- Search icon and modal
- Cart icon with count
- Account menu
- Wishlist icon

**HeaderTop.js**
- Language selector
- Currency selector
- Top bar links

**Logo.js**
- Brand logo component
- Link to homepage

**OffcanvasMenu.js**
- Slide-out menu
- Mobile navigation

#### Footer Components (components/footer/)

**FooterCopyright.js**
- Copyright text
- Footer links

**FooterNewsletter.js**
- Newsletter subscription form

#### Other Components:

**HeroSlider Components** (components/hero-slider/)
- **HeroSliderSingle.js**: Individual slider item
- **HeroSliderStatic.js**: Static banner

**Feature Components**:
- **FeatureIconSingle.js**: Feature icon card (shipping, returns, etc.)

**Promo Components**:
- **PromosSingle.js**: Promotional box

**Newsletter Components**:
- **SubscribeEmail.js**: Email subscription form

**Contact Components**:
- **LocationMap.js**: Google Maps integration

**Utility Components**:
- **SectionTitle.js**: Section heading
- **Loader.js**: Loading spinner
- **Cookie.js**: Cookie consent banner

### 5. Redux Module (src/redux/)

#### Actions (redux/actions/)

**cartActions.js**
**Exports**:
- `addToCart(item, addToast, cartId, quantityCount, defaultStore, userData, selectedProductOptions)`
  - Adds product to cart with options
  - Creates new cart or updates existing
  - Persists cart ID in cookie
  - Shows success toast
  
- `getCart(cartID, userData)`
  - Fetches cart from API
  - Handles authenticated and anonymous users
  
- `setShopizerCartID(id)`
  - Stores cart ID in cookie and localStorage
  
- `deleteFromCart(cartID, item, defaultStore, addToast)`
  - Removes item from cart
  - Updates cart state
  
- `deleteAllFromCart(orderID)`
  - Clears entire cart

**productActions.js**
**Exports**:
- `fetchProducts(products)` - Store products in state
- `setProductID(productID)` - Set current product
- `setCategoryID(categoryID)` - Set current category

**userAction.js**
**Exports**:
- `setUser(data)` - Store user data after login
- `getCountry(lang)` - Fetch country list
- `getShippingCountry(lang)` - Fetch shipping countries
- `getState(code)` - Fetch states/provinces for country
- `getShippingState(code)` - Fetch shipping states
- `getCurrentLocation()` - Get user's geolocation
- `getCurrentAddress(lat, long)` - Geocode coordinates

**storeAction.js**
**Exports**:
- `setMerchant()` - Fetch merchant configuration
- `setStore(storeCode)` - Set current store code

**loaderActions.js**
**Exports**:
- `setLoader(isLoading)` - Show/hide loading indicator

**contentAction.js**
**Exports**:
- Content-related actions for dynamic pages

#### Reducers (redux/reducers/)

**cartReducer.js**
**State Shape**:
```javascript
{
  shopizerCartID: "cart-uuid",
  cart: {
    code: "cart-uuid",
    items: [...],
    subtotal: 0,
    total: 0
  }
}
```

**Actions Handled**:
- GET_SHOPIZER_CART_ID
- GET_CART
- DELETE_FROM_CART
- DELETE_ALL_FROM_CART

**productReducer.js**
**State Shape**:
```javascript
{
  products: [],
  productID: null,
  categoryID: null
}
```

**userReducer.js**
**State Shape**:
```javascript
{
  user: {...},
  countries: [],
  shippingCountries: [],
  states: [],
  shippingStates: [],
  currentAddress: []
}
```

**storeReducer.js**
**State Shape**:
```javascript
{
  merchant: {...},
  storeCode: "DEFAULT"
}
```

**loaderReducer.js**
**State Shape**:
```javascript
{
  isLoading: false
}
```

**contentReducer.js**
**State Shape**:
```javascript
{
  content: {...}
}
```

**rootReducer.js**
**Purpose**: Combines all reducers

**Combined State**:
```javascript
{
  multilanguage: {...},
  productData: {...},
  merchantData: {...},
  cartData: {...},
  loading: {...},
  userData: {...},
  content: {...}
}
```

### 6. Utilities Module (src/util/)

#### webService.js
**Purpose**: HTTP client wrapper using Axios

**Methods**:
- `post(action, params)` - POST request
- `put(action, params)` - PUT request
- `get(action)` - GET request
- `delete(action)` - DELETE request
- `patch(action, params)` - PATCH request

**Features**:
- Request interceptor: Adds auth token
- Response interceptor: Handles errors
- Base URL configuration
- Automatic JSON transformation

#### constant.js
**Purpose**: API endpoint constants

**Exports**:
```javascript
{
  ACTION: {
    STORE: 'store/',
    CATEGORY: 'category/',
    PRODUCT: 'product/',
    PRODUCTS: 'products/',
    CART: 'cart/',
    CUSTOMER: 'customer/',
    LOGIN: 'login/',
    CHECKOUT: 'checkout',
    // ... more endpoints
  }
}
```

#### helper.js
**Purpose**: Utility helper functions

**Functions**:
- `setLocalData(key, value)` - Store in localStorage
- `getLocalData(key)` - Retrieve from localStorage
- `isValidObject(obj)` - Object validation
- `isCheckValueAndSetParams(params)` - Query parameter builder

### 7. Helpers Module (src/helpers/)

#### scroll-top.js
**Purpose**: Scroll to top on route change

**Implementation**: ScrollToTop component that scrolls window to top on location change

#### product.js
**Purpose**: Product-related helper functions

**Functions**:
- Product filtering logic
- Price calculation
- Discount calculation
- Product comparison
- Wishlist management
- Layout state management

### 8. Layouts Module (src/layouts/)

#### Layout.js
**Purpose**: Page layout wrapper

**Structure**:
```
<Header />
{children}
<Footer />
```

**Props**:
- `headerContainerClass` - Header container styling
- `headerTop` - Show/hide header top bar
- `headerPaddingClass` - Header padding
- `headerPositionClass` - Header position (fixed/static)

### 9. Assets Module (src/assets/)

#### CSS (assets/css/)
- Compiled CSS files
- Third-party CSS

#### SCSS (assets/scss/)
**Structure**:
- `style.scss` - Main stylesheet
- `_variables.scss` - SASS variables
- `_mixins.scss` - SASS mixins
- Component-specific styles
- Responsive styles
- Theme customization

**Key Variables**:
- Colors (primary, secondary, etc.)
- Typography
- Spacing
- Breakpoints

#### Fonts (assets/fonts/)
- Custom web fonts
- Icon fonts

### 10. Translations Module (src/translations/)

#### english.json
**Structure**:
```json
{
  "home": "Home",
  "shop": "Shop",
  "cart": "Cart",
  "checkout": "Checkout",
  // ... more translations
}
```

#### french.json
- French translations
- Same structure as english.json

**Usage**: Accessed via `strings` prop from multilanguage HOC

### 11. Data Module (src/data/)

#### hero-sliders/
- Static hero slider data
- Fallback content

#### feature-icons/
- Feature icon data
- Service highlights (shipping, returns, etc.)

### 12. Configuration Files

#### public/env-config.js
**Purpose**: Runtime configuration

**Configuration**: See Technical Details document

#### .env
**Purpose**: Environment variables for build

**Variables**: Same as env-config.js

#### Dockerfile
**Purpose**: Docker image build

**Stages**:
1. Build stage (Node.js)
2. Production stage (Nginx)

#### conf/conf.d/
**Nginx Configuration**:
- `default.conf` - Server configuration
- `gzip.conf` - Compression settings

## Module Dependencies

### Dependency Graph

```
index.js
  └── App.js
      ├── Pages
      │   ├── Wrappers
      │   │   └── Components
      │   └── Components
      ├── Redux (Actions, Reducers)
      │   └── WebService
      │       └── Constants
      └── Layouts
          ├── Header Wrapper
          │   └── Header Components
          └── Footer Wrapper
              └── Footer Components
```

### Key Dependency Rules

1. **Pages** depend on Wrappers and Components
2. **Wrappers** depend on Components and Redux
3. **Components** are independent (props only)
4. **Actions** depend on WebService
5. **WebService** depends on Constants
6. **Reducers** are pure (no external dependencies)
7. **All modules** can use Helpers and Utilities

## Module Communication

### Component Communication

**Parent to Child**: Props
**Child to Parent**: Callback props
**Sibling to Sibling**: Redux state
**Global State**: Redux store

### API Communication

**Pattern**: Component → Action → WebService → API

**Example**:
```
ProductDetail → fetchProduct action → WebService.get() → Backend API
```

### Event Communication

**User Events**: Component event handlers → Redux actions
**System Events**: Lifecycle hooks (useEffect) → Redux actions
**Route Events**: React Router → Page components
