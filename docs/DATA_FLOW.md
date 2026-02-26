# Data Flow

## Request Flow Overview

This document describes how data flows through the application from user interaction to database and back to the UI.

## Entry Points

### 1. Application Bootstrap

```
Browser loads index.html
    ↓
Load env-config.js (window._env_)
    ↓
Execute index.js
    ↓
Create Redux store with persisted state
    ↓
Render App component
    ↓
Initialize Router
    ↓
Load cart from cookies
    ↓
Fetch merchant configuration
    ↓
Render initial route (Home)
```

### 2. Route Navigation

```
User clicks navigation link
    ↓
React Router intercepts
    ↓
Update browser URL (client-side)
    ↓
Match route in App.js
    ↓
Lazy load page component (if needed)
    ↓
Render page component
    ↓
Page component fetches required data
    ↓
Update Redux state
    ↓
Re-render with data
```

## Complete Request Flows

### Flow 1: Browse Products by Category

**User Action**: Click on category link in navigation

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User Interaction                                          │
└─────────────────────────────────────────────────────────────┘
User clicks "Electronics" category in NavMenu
    ↓
NavMenu.js: <Link to="/category/electronics">

┌─────────────────────────────────────────────────────────────┐
│ 2. Routing                                                   │
└─────────────────────────────────────────────────────────────┘
React Router matches route: /category/:id
    ↓
App.js: <Route path="/category/:id" component={Category} />
    ↓
Lazy load Category component

┌─────────────────────────────────────────────────────────────┐
│ 3. Component Initialization                                  │
└─────────────────────────────────────────────────────────────┘
Category.js: useEffect hook triggered
    ↓
Extract category ID from route params
    ↓
Dispatch setCategoryID action
    ↓
Dispatch setLoader(true)

┌─────────────────────────────────────────────────────────────┐
│ 4. API Request                                               │
└─────────────────────────────────────────────────────────────┘
Category.js: Call fetchProducts()
    ↓
Build API URL with parameters:
  - Category ID
  - Store code (DEFAULT)
  - Language (en)
  - Pagination (page, size)
  - Filters (manufacturer, color, size)
    ↓
WebService.get('/products/?category=electronics&store=DEFAULT&lang=en&page=0&size=15')
    ↓
Axios request interceptor adds:
  - Base URL: http://localhost:8080/api/v1/
  - Authorization header: Bearer {token}
    ↓
HTTP GET request to backend

┌─────────────────────────────────────────────────────────────┐
│ 5. Backend Processing (External)                            │
└─────────────────────────────────────────────────────────────┘
Shopizer Backend API receives request
    ↓
Validate authentication (if required)
    ↓
Query database for products
    ↓
Apply filters and pagination
    ↓
Format response as JSON
    ↓
Return product list with metadata

┌─────────────────────────────────────────────────────────────┐
│ 6. Response Processing                                       │
└─────────────────────────────────────────────────────────────┘
Axios receives response
    ↓
Response interceptor processes
    ↓
WebService.get() returns data
    ↓
Category.js: setProductData(response.products)
    ↓
setTotalProduct(response.recordsTotal)
    ↓
Dispatch setLoader(false)

┌─────────────────────────────────────────────────────────────┐
│ 7. UI Update                                                 │
└─────────────────────────────────────────────────────────────┘
Category component re-renders
    ↓
Pass products to ProductGrid wrapper
    ↓
ProductGrid renders ProductGridSingle for each product
    ↓
Display product cards with:
  - Product image
  - Product name
  - Price
  - Add to cart button
    ↓
User sees product list
```

**Data Structure**:

Request:
```
GET /api/v1/products/?category=electronics&store=DEFAULT&lang=en&page=0&size=15
Headers: {
  Authorization: Bearer {token}
}
```

Response:
```json
{
  "products": [
    {
      "id": 123,
      "sku": "PROD-001",
      "name": "Product Name",
      "description": "Product description",
      "price": 99.99,
      "images": [...],
      "categories": [...],
      "manufacturer": {...}
    }
  ],
  "recordsTotal": 45,
  "recordsFiltered": 45,
  "page": 0,
  "size": 15
}
```

### Flow 2: Add Product to Cart

**User Action**: Click "Add to Cart" button on product

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User Interaction                                          │
└─────────────────────────────────────────────────────────────┘
User clicks "Add to Cart" on ProductGridSingle
    ↓
ProductGridSingle.js: onClick handler
    ↓
Collect product data:
  - Product SKU
  - Quantity (default: 1)
  - Selected options (size, color)

┌─────────────────────────────────────────────────────────────┐
│ 2. Redux Action Dispatch                                     │
└─────────────────────────────────────────────────────────────┘
Dispatch addToCart action:
  - item (product object)
  - addToast (notification function)
  - cartId (from Redux state or cookie)
  - quantityCount (1)
  - defaultStore (DEFAULT)
  - userData (if logged in)
  - selectedProductOptions (size, color)

┌─────────────────────────────────────────────────────────────┐
│ 3. Action Processing                                         │
└─────────────────────────────────────────────────────────────┘
cartActions.js: addToCart()
    ↓
Dispatch setLoader(true)
    ↓
Build request payload:
{
  "product": "PROD-001",
  "quantity": 1,
  "attributes": [
    {"id": 1, "value": "Large"},
    {"id": 2, "value": "Blue"}
  ]
}
    ↓
Check if cart exists (cartId)

┌─────────────────────────────────────────────────────────────┐
│ 4. API Request (New Cart or Update Cart)                    │
└─────────────────────────────────────────────────────────────┘
If cartId exists:
  WebService.put('/cart/{cartId}?store=DEFAULT', payload)
Else:
  WebService.post('/cart/?store=DEFAULT', payload)
    ↓
Axios adds auth token (if logged in)
    ↓
HTTP POST/PUT to backend

┌─────────────────────────────────────────────────────────────┐
│ 5. Backend Processing                                        │
└─────────────────────────────────────────────────────────────┘
Shopizer Backend receives request
    ↓
Validate product SKU and availability
    ↓
Check inventory
    ↓
Create/update cart in database
    ↓
Calculate cart totals
    ↓
Return cart object with:
  - Cart code (UUID)
  - Cart items
  - Subtotal
  - Total

┌─────────────────────────────────────────────────────────────┐
│ 6. Response Processing                                       │
└─────────────────────────────────────────────────────────────┘
cartActions.js receives response
    ↓
Dispatch setShopizerCartID(response.code)
    ↓
Store cart ID in cookie:
  - Name: DEFAULT_shopizer_cart
  - Value: cart-uuid
  - Max age: 6 months
    ↓
Store cart ID in localStorage
    ↓
Dispatch getCart(response.code, userData)

┌─────────────────────────────────────────────────────────────┐
│ 7. Fetch Updated Cart                                        │
└─────────────────────────────────────────────────────────────┘
cartActions.js: getCart()
    ↓
If user logged in:
  WebService.get('/auth/customer/cart?cart={cartId}&lang=en')
Else:
  WebService.get('/cart/{cartId}?lang=en')
    ↓
Backend returns full cart details
    ↓
Dispatch action: GET_CART with cart data

┌─────────────────────────────────────────────────────────────┐
│ 8. Redux State Update                                        │
└─────────────────────────────────────────────────────────────┘
cartReducer.js: Handle GET_CART action
    ↓
Update state:
{
  shopizerCartID: "cart-uuid",
  cart: {
    code: "cart-uuid",
    items: [
      {
        id: 1,
        product: {...},
        quantity: 1,
        price: 99.99
      }
    ],
    subtotal: 99.99,
    total: 99.99
  }
}

┌─────────────────────────────────────────────────────────────┐
│ 9. UI Update                                                 │
└─────────────────────────────────────────────────────────────┘
Dispatch setLoader(false)
    ↓
Show success toast: "Added to Cart"
    ↓
Components connected to cart state re-render:
  - Header IconGroup: Update cart count badge
  - Cart page: Update cart items (if open)
    ↓
User sees updated cart count
```

**Data Structures**:

Add to Cart Request:
```
POST /api/v1/cart/?store=DEFAULT
{
  "product": "PROD-001",
  "quantity": 1,
  "attributes": [
    {"id": 1, "value": "Large"}
  ]
}
```

Cart Response:
```json
{
  "code": "cart-uuid-12345",
  "items": [
    {
      "id": 1,
      "product": {
        "id": 123,
        "sku": "PROD-001",
        "name": "Product Name",
        "price": 99.99,
        "image": "..."
      },
      "quantity": 1,
      "subTotal": 99.99
    }
  ],
  "subtotal": 99.99,
  "total": 99.99
}
```

### Flow 3: User Login

**User Action**: Submit login form

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User Interaction                                          │
└─────────────────────────────────────────────────────────────┘
User enters email and password
    ↓
User clicks "Login" button
    ↓
LoginRegister.js: onSubmit handler

┌─────────────────────────────────────────────────────────────┐
│ 2. Form Validation                                           │
└─────────────────────────────────────────────────────────────┘
react-hook-form validates:
  - Email format
  - Password not empty
    ↓
If validation fails: Show error messages
    ↓
If validation passes: Continue

┌─────────────────────────────────────────────────────────────┐
│ 3. API Request                                               │
└─────────────────────────────────────────────────────────────┘
Dispatch setLoader(true)
    ↓
Build login payload:
{
  "username": "user@example.com",
  "password": "hashedPassword"
}
    ↓
WebService.post('/auth/customer/login/?store=DEFAULT', payload)
    ↓
HTTP POST to backend

┌─────────────────────────────────────────────────────────────┐
│ 4. Backend Authentication                                    │
└─────────────────────────────────────────────────────────────┘
Shopizer Backend receives credentials
    ↓
Validate username and password
    ↓
If invalid: Return 401 Unauthorized
    ↓
If valid:
  - Generate JWT token
  - Return user data and token

┌─────────────────────────────────────────────────────────────┐
│ 5. Response Processing                                       │
└─────────────────────────────────────────────────────────────┘
LoginRegister.js receives response
    ↓
Extract token and user data
    ↓
Store token in localStorage:
  key: "token"
  value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    ↓
Dispatch setUser(userData)

┌─────────────────────────────────────────────────────────────┐
│ 6. Redux State Update                                        │
└─────────────────────────────────────────────────────────────┘
userReducer.js: Handle SET_USER action
    ↓
Update state:
{
  user: {
    id: 456,
    email: "user@example.com",
    firstName: "John",
    lastName: "Doe",
    billing: {...},
    shipping: {...}
  }
}

┌─────────────────────────────────────────────────────────────┐
│ 7. Post-Login Actions                                        │
└─────────────────────────────────────────────────────────────┘
Merge anonymous cart with user cart (if exists)
    ↓
Fetch user's cart:
  WebService.get('/auth/customer/cart?cart={cartId}')
    ↓
Update cart state with merged cart
    ↓
Dispatch setLoader(false)

┌─────────────────────────────────────────────────────────────┐
│ 8. Navigation and UI Update                                  │
└─────────────────────────────────────────────────────────────┘
Show success toast: "Login successful"
    ↓
Redirect to:
  - My Account page (if from login page)
  - Checkout page (if from cart)
  - Previous page (if from protected route)
    ↓
Header updates:
  - Show user name
  - Show "My Account" link
  - Show "Logout" option
    ↓
User is authenticated
```

**Data Structures**:

Login Request:
```
POST /api/v1/auth/customer/login/?store=DEFAULT
{
  "username": "user@example.com",
  "password": "password123"
}
```

Login Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "customer": {
    "id": 456,
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "billing": {
      "address": "123 Main St",
      "city": "New York",
      "country": "US",
      "postalCode": "10001"
    }
  }
}
```

### Flow 4: Checkout and Order Placement

**User Action**: Complete checkout form and place order

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Checkout Initialization                                   │
└─────────────────────────────────────────────────────────────┘
User navigates to /checkout
    ↓
Checkout.js: useEffect hook
    ↓
Check authentication (required)
    ↓
If not logged in: Redirect to /login
    ↓
Fetch cart data
    ↓
Fetch shipping countries
    ↓
Pre-fill form with user's saved addresses

┌─────────────────────────────────────────────────────────────┐
│ 2. Form Completion                                           │
└─────────────────────────────────────────────────────────────┘
User fills billing address:
  - First name, last name
  - Address, city, postal code
  - Country, state/province
  - Phone
    ↓
User fills shipping address (or same as billing)
    ↓
User selects shipping method
    ↓
Fetch shipping cost:
  WebService.post('/shipping?store=DEFAULT', addressData)
    ↓
Display shipping options and costs

┌─────────────────────────────────────────────────────────────┐
│ 3. Payment Information                                       │
└─────────────────────────────────────────────────────────────┘
User selects payment method (Stripe/Nuvei)
    ↓
If Stripe:
  - Render Stripe CardElement
  - User enters card details
  - Stripe validates card format
    ↓
If Nuvei:
  - Load Nuvei script
  - Render Nuvei payment form
  - User enters payment details

┌─────────────────────────────────────────────────────────────┐
│ 4. Order Review                                              │
└─────────────────────────────────────────────────────────────┘
Calculate order total:
  WebService.post('/total/?store=DEFAULT', {
    cart: cartId,
    shipping: shippingMethod
  })
    ↓
Display order summary:
  - Cart items
  - Subtotal
  - Shipping cost
  - Tax
  - Total

┌─────────────────────────────────────────────────────────────┐
│ 5. Place Order                                               │
└─────────────────────────────────────────────────────────────┘
User clicks "Place Order"
    ↓
Validate all form fields
    ↓
Dispatch setLoader(true)
    ↓
If Stripe:
  - Create payment method with Stripe
  - stripe.createPaymentMethod({card: cardElement})
  - Get payment method ID
    ↓
Build checkout payload:
{
  "cart": "cart-uuid",
  "billing": {...},
  "shipping": {...},
  "shippingMethod": "standard",
  "payment": {
    "type": "STRIPE",
    "paymentMethodId": "pm_xxx"
  }
}

┌─────────────────────────────────────────────────────────────┐
│ 6. Checkout API Request                                      │
└─────────────────────────────────────────────────────────────┘
WebService.post('/auth/customer/checkout', payload)
    ↓
Axios adds auth token
    ↓
HTTP POST to backend

┌─────────────────────────────────────────────────────────────┐
│ 7. Backend Order Processing                                  │
└─────────────────────────────────────────────────────────────┘
Shopizer Backend receives checkout request
    ↓
Validate cart and inventory
    ↓
Validate addresses
    ↓
Process payment with Stripe API:
  - Create payment intent
  - Charge customer
  - Handle payment confirmation
    ↓
If payment successful:
  - Create order in database
  - Update inventory
  - Generate order number
  - Send confirmation email
    ↓
If payment failed:
  - Return error
  - Rollback transaction

┌─────────────────────────────────────────────────────────────┐
│ 8. Response Processing                                       │
└─────────────────────────────────────────────────────────────┘
Checkout.js receives response
    ↓
If successful:
  - Extract order ID and number
  - Dispatch deleteAllFromCart()
  - Clear cart state
  - Remove cart cookie
    ↓
If failed:
  - Show error toast
  - Keep cart intact
  - Allow retry

┌─────────────────────────────────────────────────────────────┐
│ 9. Order Confirmation                                        │
└─────────────────────────────────────────────────────────────┘
Dispatch setLoader(false)
    ↓
Navigate to /order-confirm
    ↓
Pass order data via location state
    ↓
OrderConfirm.js displays:
  - Order number
  - Order total
  - Confirmation message
  - Link to order details
    ↓
User receives confirmation email
```

**Data Structures**:

Checkout Request:
```
POST /api/v1/auth/customer/checkout
Headers: {
  Authorization: Bearer {token}
}
Body: {
  "cart": "cart-uuid",
  "billing": {
    "firstName": "John",
    "lastName": "Doe",
    "address": "123 Main St",
    "city": "New York",
    "country": "US",
    "stateProvince": "NY",
    "postalCode": "10001",
    "phone": "555-1234"
  },
  "shipping": {
    "firstName": "John",
    "lastName": "Doe",
    "address": "123 Main St",
    "city": "New York",
    "country": "US",
    "stateProvince": "NY",
    "postalCode": "10001"
  },
  "shippingMethod": "standard",
  "payment": {
    "type": "STRIPE",
    "paymentMethodId": "pm_1234567890"
  }
}
```

Checkout Response:
```json
{
  "orderId": 789,
  "orderNumber": "ORD-2024-001",
  "total": 109.99,
  "status": "PENDING",
  "items": [...],
  "billing": {...},
  "shipping": {...},
  "payment": {
    "status": "PAID",
    "transactionId": "txn_123"
  }
}
```

## Sequence Diagrams

### Product Browse Sequence

```
User → NavMenu → Router → Category → WebService → Backend → Database
                                ↓                      ↓
                            Redux Store ← Response ← Response
                                ↓
                          ProductGrid
                                ↓
                        ProductGridSingle
                                ↓
                              User
```

### Add to Cart Sequence

```
User → ProductCard → addToCart Action → WebService → Backend → Database
                          ↓                             ↓
                    setLoader(true)                 Create/Update Cart
                          ↓                             ↓
                    API Request                     Response
                          ↓                             ↓
                    setShopizerCartID ← Response ← Response
                          ↓
                    Store in Cookie
                          ↓
                    getCart Action → WebService → Backend
                          ↓                         ↓
                    Cart Reducer ← Response ← Response
                          ↓
                    setLoader(false)
                          ↓
                    Show Toast
                          ↓
                    Update UI
```

### Authentication Sequence

```
User → LoginForm → Validate → WebService → Backend → Database
                                  ↓            ↓
                            API Request    Validate Credentials
                                  ↓            ↓
                            Response ← Generate JWT Token
                                  ↓
                            Store Token (localStorage)
                                  ↓
                            setUser Action
                                  ↓
                            User Reducer
                                  ↓
                            Merge Cart (if exists)
                                  ↓
                            Redirect
                                  ↓
                            Update Header
```

## Integration Points

### Frontend-Backend Integration

**Communication Protocol**: REST over HTTPS
**Data Format**: JSON
**Authentication**: JWT Bearer token

**Request Pattern**:
```
Component → Action → WebService → Axios → Backend API
```

**Response Pattern**:
```
Backend API → Axios → WebService → Action → Reducer → Component
```

### Payment Gateway Integration

**Stripe Integration**:
```
Checkout Form → Stripe Elements → Stripe API → Payment Method
                                                      ↓
                                              Payment Method ID
                                                      ↓
                                              Backend API
                                                      ↓
                                              Process Payment
```

**Nuvei Integration**:
```
Checkout Form → Nuvei Script → Nuvei API → Payment Token
                                                ↓
                                          Backend API
                                                ↓
                                          Process Payment
```

### Maps Integration

**Google Maps**:
```
Contact Page → LocationMap → Google Maps API → Display Map
```

**Geocoding**:
```
User Location → getCurrentLocation → Geolocation API → Coordinates
                                                            ↓
                                                    Geocode API
                                                            ↓
                                                        Address
```

## Error Handling Flow

### API Error Handling

```
API Request
    ↓
Error Occurs
    ↓
Axios Response Interceptor
    ↓
Check Error Status:
  - 401: Unauthorized → Clear token → Redirect to login
  - 404: Not Found → Show not found message
  - 500: Server Error → Show error toast
  - Network Error → Show connection error
    ↓
Dispatch setLoader(false)
    ↓
Show Error Toast
    ↓
Log Error (console)
    ↓
Return to User
```

### Form Validation Error Flow

```
User Submits Form
    ↓
react-hook-form Validates
    ↓
Validation Errors?
    ↓
Yes: Display inline error messages
    ↓
User corrects errors
    ↓
Re-validate on change
    ↓
No errors: Submit form
```

## State Persistence

### Cart Persistence

```
Add to Cart
    ↓
Get Cart ID from API
    ↓
Store in Cookie (6 months)
    ↓
Store in Redux State
    ↓
User closes browser
    ↓
User returns
    ↓
App.js: Load cart ID from cookie
    ↓
Fetch cart from API
    ↓
Restore cart state
```

### Authentication Persistence

```
User Logs In
    ↓
Receive JWT Token
    ↓
Store in localStorage
    ↓
Store user data in Redux
    ↓
User refreshes page
    ↓
index.js: Load Redux state from localStorage
    ↓
Token and user data restored
    ↓
Axios interceptor adds token to requests
    ↓
User remains authenticated
```

### Language Persistence

```
User Selects Language
    ↓
Dispatch changeLanguage action
    ↓
Update Redux state
    ↓
Redux state saved to localStorage
    ↓
User refreshes page
    ↓
Language preference restored
    ↓
UI renders in selected language
```
