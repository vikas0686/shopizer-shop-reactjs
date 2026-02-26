# Shopizer Shop React - Documentation

## Overview

Shopizer Shop React is a modern, production-ready e-commerce storefront application built with React. It serves as the customer-facing frontend for the Shopizer e-commerce platform, providing a complete online shopping experience including product browsing, cart management, checkout, and user account management.

## Purpose

This application provides a responsive, multi-language e-commerce storefront that connects to the Shopizer backend API to deliver:

- Product catalog browsing and search
- Shopping cart and checkout functionality
- Customer account management
- Order tracking and history
- Multi-language support (English, French)
- Payment processing integration (Stripe, Nuvei)
- Responsive design for mobile and desktop

## Scope

The application handles all customer-facing e-commerce operations:

- **Product Discovery**: Browse categories, search products, view product details
- **Shopping Experience**: Add to cart, manage cart items, apply promotions
- **Checkout Process**: Billing/shipping information, payment processing, order confirmation
- **Customer Management**: Registration, login, profile management, order history
- **Content Management**: Dynamic content pages, promotional banners, newsletters

## Technology Stack

- **Frontend Framework**: React 16.6.0
- **State Management**: Redux with Redux Thunk
- **Routing**: React Router DOM
- **Styling**: Bootstrap 4.5.0, SASS
- **Payment Integration**: Stripe, Nuvei
- **API Communication**: Axios
- **Build Tool**: Create React App (react-scripts 4.0.1)
- **Deployment**: Docker with Nginx

## Key Features

- Single Page Application (SPA) architecture
- Server-side rendering ready
- Multi-language support via redux-multilanguage
- Persistent cart using cookies
- Lazy loading for optimized performance
- Responsive design with mobile-first approach
- SEO-friendly with react-meta-tags
- Toast notifications for user feedback
- Form validation with react-hook-form
- Image galleries and product sliders

## Documentation Structure

This documentation is organized into the following sections:

1. **[BUSINESS_OVERVIEW.md](./BUSINESS_OVERVIEW.md)** - Business context, workflows, and domain concepts
2. **[ARCHITECTURE.md](./ARCHITECTURE.md)** - System architecture and design patterns
3. **[HIGH_LEVEL_DESIGN.md](./HIGH_LEVEL_DESIGN.md)** - Component design and system boundaries
4. **[TECHNICAL_DETAILS.md](./TECHNICAL_DETAILS.md)** - Technology stack and integrations
5. **[MODULE_BREAKDOWN.md](./MODULE_BREAKDOWN.md)** - Detailed module and component descriptions
6. **[DATA_FLOW.md](./DATA_FLOW.md)** - Request flow and data processing
7. **[SETUP_AND_RUN.md](./SETUP_AND_RUN.md)** - Installation and deployment instructions

## Quick Start

```bash
# Install dependencies
npm install --legacy-peer-deps

# Configure backend URL in public/env-config.js
# Set APP_BASE_URL to your Shopizer backend

# Run development server
npm run dev

# Access application
http://localhost:3000
```

For detailed setup instructions, see [SETUP_AND_RUN.md](./SETUP_AND_RUN.md).

## Project Status

- **Version**: 3.0.0
- **Node Version**: Tested with v16.13.0
- **Production Ready**: Yes
- **Docker Support**: Yes

## Support and Resources

- Backend API: Shopizer REST API (configured via env-config.js)
- Default Merchant: DEFAULT (configurable)
- API Version: v1

## License

See LICENSE file in the root directory.
