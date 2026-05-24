# BookShopApp

![iOS CI](https://github.com/cin-tie/BookShopApp/actions/workflows/ios-ci.yml/badge.svg)

## Project Name

BookShopApp — mobile iOS application for purchasing books, electronic books, stationery products, and related goods.

The application is developed as a team software engineering project for the course “Mobile Programming Technologies”.

---

# Description

BookShopApp is an e-commerce mobile application developed for iOS using Swift and SwiftUI.

The application allows users to browse product catalogs, search and filter products, manage shopping carts, place orders, choose payment methods, and select pickup points using map integration.

The system supports both guest and registered users. Registered users can manage orders, delivery addresses, payment methods, and order tracking.

The project follows Apple Human Interface Guidelines and modern iOS development practices including MVVM architecture, Git workflow, GitHub Actions CI/CD, automated testing, localization, and UML-based software design.

Main functionality includes:
- user authentication
- product catalog browsing
- product search and filtering
- shopping cart management
- order processing
- payment management
- pickup point selection
- localization support

---

# Table of Contents

1. Description
2. Technologies
3. Features
4. Application Requirements
5. Installation
6. Usage
7. Application Screens
8. Project Structure
9. UML Diagrams
10. Database Model
11. Functional Requirements
12. User Stories
13. Non-Functional Requirements
14. CI/CD
15. Testing
16. Documentation
17. Design
18. Team
19. Development Workflow
20. GitHub Project
21. Wiki Structure
22. GitHub Pages
23. Presentation
24. Future Improvements
25. Contributing
26. License

---

# Technologies

## Programming Language
- Swift 5+

## UI Framework
- SwiftUI

## Architecture
- MVVM (Model-View-ViewModel)

## Database
- SQLite

## Development Tools
- Xcode
- Git
- GitHub
- GitHub Projects
- GitHub Actions
- Figma

## Testing
- XCTest
- XCUITest
- Swift Testing

---

# Features

## Authentication
- User registration
- User login
- Session persistence
- Logout
- Profile management

## Product Catalog
- Browse products
- Search products
- Filter products by categories
- View product details
- Display product availability

## Shopping Cart
- Add products to cart
- Edit quantity
- Remove products
- Calculate total price
- Persist cart between sessions

## Orders
- Create orders
- Cancel orders
- Split orders
- Track order status

## Payment System
- Online payment
- Cash payment
- Refund support
- Payment retry functionality

## Pickup Points
- Map integration
- Pickup point selection
- User location detection
- Route building

## Localization
Supported languages:
- English
- Russian
- Belarusian

---

# Application Requirements

## Software Requirements

The application requires:
- iOS 14 or newer
- Xcode 13 or newer
- Swift 5+
- Internet connection
- GitHub account for collaboration

## Hardware Requirements

Supported devices:
- iPhone
- iPad

Minimum requirements:
- 4 GB RAM
- 200 MB available storage
- GPS support for map functionality

---

# Installation

## Clone Repository

```bash
git clone https://github.com/your-username/BookShopApp.git
```

## Open Project

```bash
cd BookShopApp
open BookShopApp.xcodeproj
```

## Install Dependencies

If Swift Package Manager dependencies are used:

```bash
xcodebuild -resolvePackageDependencies
```

## Run Application

1. Open project in Xcode
2. Select simulator or physical device
3. Press `Run`
4. Wait until application builds successfully

---

# Usage

## Guest User

Guest users can:
- browse product catalog
- search products
- filter products
- view product details

## Registered User

Registered users can additionally:
- manage shopping cart
- place orders
- select payment methods
- manage delivery addresses
- track orders
- cancel orders
- split orders
- select pickup points

## Typical User Flow

1. User opens application
2. User browses products
3. User adds products to cart
4. User opens cart
5. User proceeds to checkout
6. User selects payment method
7. User selects pickup point
8. User confirms order
9. User tracks order status

---

# Application Screens

The application interface is designed in Figma according to Apple Human Interface Guidelines.

Main application screens:
- Login screen
- Registration screen
- Product catalog screen
- Product details screen
- Shopping cart screen
- Checkout screen
- Pickup point map screen
- Orders history screen

Example mockups are available in the Figma project.

---

# Project Structure

```text
BookShopApp/
├── App/
├── Models/
├── Views/
├── ViewModels/
├── Services/
├── Database/
├── Resources/
├── Localization/
├── Tests/
├── UITests/
├── Docs/
│   ├── requirements.md
│   └── user-stories.md
├── README.md
└── LICENSE
```

## Structure Description

### App
Contains application entry point and global configuration.

### Models
Contains business entities and data models.

### Views
Contains SwiftUI screens and reusable UI components.

### ViewModels
Contains presentation logic based on MVVM architecture.

### Services
Contains services for authentication, orders, payment, and database interaction.

### Database
Contains SQLite database logic and storage management.

### Resources
Contains application assets and configuration files.

### Localization
Contains localized strings for supported languages.

### Tests
Contains unit tests.

### UITests
Contains UI automation tests.

### Docs
Contains project documentation:
- requirements specification
- user stories
- additional documentation

---

# UML Diagrams

## Use Case Diagram

The use case diagram describes interactions between users and the online store system.

Main actors:
- Guest
- Registered User
- Delivery Service
- Payment System

Main use cases:
- Register
- Login
- Browse products
- Search products
- Filter products
- View product details
- Manage cart
- Checkout
- Select payment method
- Pay for order
- Track orders
- Cancel order
- Split order

![Use Case Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_use_case.png)

---

## Class Diagram

The class diagram describes the structure of the application and relationships between entities.

Main entities:
- User
- Product
- Cart
- CartItem
- Order
- OrderItem
- Payment
- PickupPoint
- DeliveryAddress
- Category

![Class Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_class_diagram.png)

---

## Sequence Diagram

The sequence diagram describes the checkout process between system components.

Main process:
1. User opens cart
2. Application loads cart data
3. Cart service fetches products from database
4. User starts checkout
5. Payment system processes payment
6. Order service creates order
7. Database saves order
8. User receives confirmation

![Sequence Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_sequence.png)

---

## Activity Diagram

The activity diagram describes the user order flow.

Main flow:
- Browse products
- Add products to cart
- Continue shopping
- Open cart
- Edit quantity
- Proceed to checkout
- Enter delivery address
- Select payment method
- Process payment
- Create order
- Show confirmation screen

Alternative flow:
- Payment failure
- Display payment error

![Activity Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_activity.png)

---

# Database Model

The application uses SQLite database for persistent local storage.

Main tables:
- users
- delivery_addresses
- categories
- products
- carts
- cart_items
- orders
- order_items
- payments
- pickup_points

Relationships:
- one user can have multiple delivery addresses
- one user owns one shopping cart
- one user can place multiple orders
- one category contains multiple products
- one cart contains multiple cart items
- one order contains multiple order items
- one product can appear in multiple cart items
- one product can appear in multiple order items
- one order has one payment
- one pickup point can be associated with multiple orders

Database supports:
- authentication and profile management
- product catalog management
- shopping cart functionality
- order processing
- payment management
- pickup point selection
- persistent local storage

![Database Model](https://github.com/cin-tie/tpmp-lab4-uml/blob/main/blob/main/img/lab9_database_model.drawio.svg)

---

# Functional Requirements

## Authentication
- User registration
- User login/logout
- Session persistence
- Profile management

## Product Catalog
- Browse products
- Search and filtering
- Product details screen
- Product categories

## Shopping Cart
- Add/remove products
- Quantity management
- Automatic total calculation

## Orders
- Order creation
- Order tracking
- Order cancellation
- Order splitting

## Payment
- Online payment
- Cash payment
- Refund support
- Payment retry

## Pickup Points
- Map support
- Pickup point selection
- User location detection

## Localization
- English language support
- Russian language support
- Belarusian language support

---

# User Stories

Examples of user stories used during development.

## US-1 User Registration

As a guest user,  
I want to create an account,  
So that I can place and manage orders.

## US-8 Add Product to Cart

As a user,  
I want to add products to cart,  
So that I can purchase them later.

## US-15 Process Payment

As a user,  
I want to complete payment,  
So that my order can be confirmed.

Complete user stories documentation:
- `docs/user-stories.md`

---

# Non-Functional Requirements

## Usability
- intuitive navigation
- responsive interface
- dark mode support
- readable typography
- consistent UI components

## Reliability
- error handling
- data validation
- persistent local storage
- crash minimization

## Performance
- screen loading under 2 seconds
- search under 1 second
- support for 1000+ products
- instant cart operations

---

# CI/CD

The project uses GitHub Actions for:
- automatic builds
- unit testing
- UI testing
- pull request validation

Workflow includes:
- development branch
- protected main branch
- pull requests
- code review process

---

# Testing

## Unit Tests
- authentication tests
- cart logic tests
- order tests
- payment validation tests

## UI Tests
- login flow
- product browsing
- cart interaction
- checkout flow
- localization tests

## Test Plan Includes
- functional testing
- usability testing
- regression testing
- UI testing
- unit testing

---

# Documentation

Project documentation includes:
- Requirements Specification
- User Stories
- UML Diagrams
- Database Schema
- GitHub Wiki
- GitHub Pages
- Presentation

Documentation files:
- `docs/requirements.md`
- `docs/user-stories.md`

---

# Design

The application interface is designed in Figma according to Apple Human Interface Guidelines.

Design requirements:
- responsive layout
- dark mode support
- accessibility support
- adaptive navigation
- reusable UI components

Main screens:
- Login
- Catalog
- Product Details
- Cart
- Checkout
- Orders
- Pickup Points Map

---

# Team

| Team Member | Role | Responsibilities |
|---|---|---|
| Neyfeld Kirill | Project Manager / Team Lead | Project management, requirements, CI/CD, architecture |
| Shulga Maria | iOS Developer | SwiftUI implementation, business logic |
| Kazlou Maksim | UI/UX Designer | Figma mockups, interface design |
| Drozd Yahor | Tester | Unit tests, UI tests, test plans |

---

# Development Workflow

## Branch Strategy

```text
main
develop
feature/*
bugfix/*
docs/*
```

## Pull Request Rules
- direct push to main is prohibited
- all changes must use Pull Requests
- at least one review approval required
- CI checks must pass before merge

## Commit Convention

Examples:
```text
feat: add login screen
fix: resolve cart calculation bug
docs: update requirements specification
test: add authentication unit tests
refactor: improve payment service
```

---

# GitHub Project

The project uses GitHub Kanban board for:
- task management
- sprint planning
- issue tracking
- feature development

Main labels:
- feature
- bug
- ui
- backend
- testing
- documentation
- ci/cd

Project roles:
- Project Manager
- iOS Developer
- UI/UX Designer
- Tester

---

# Wiki Structure

The GitHub Wiki contains the following pages:

## Main Page
Contains:
- project overview
- quick links
- navigation between documentation sections

## Functional Requirements
Contains:
- functional requirements
- use case descriptions
- UML diagrams
- scenarios

## File Diagram
Contains:
- project structure diagram
- module descriptions

## Additional Specification
Contains:
- security requirements
- reliability requirements
- performance limitations
- validation rules

## Database Schema
Contains:
- SQLite schema
- entity relationships
- database diagrams

## Presentation
Contains:
- presentation link
- team responsibilities
- architecture overview
- requirements summary

---

# GitHub Pages

GitHub Pages contains:
- project overview
- documentation pages
- requirements specification
- diagrams
- user stories
- database schema
- presentation materials

GitHub Pages structure matches the GitHub Wiki structure.

---

# Presentation

Project presentation:
https://canva.link/iupnucu3yqik95p

Presentation includes:
- project goals
- team responsibilities
- application requirements
- UML diagrams
- database schema
- architecture overview
- implementation details

---

# Future Improvements

Planned improvements:
- backend integration
- push notifications
- favorites system
- recommendation system
- cloud synchronization
- online payments API
- analytics dashboard

---

# Contributing

This project is developed as a team educational project.

## Contribution Process

1. Create feature branch
2. Implement functionality
3. Commit changes
4. Create Pull Request
5. Pass code review
6. Merge into develop branch

## Development Rules

- follow Swift style guide
- use MVVM architecture
- write unit tests
- write UI tests
- document major features
- use Pull Requests for all changes

---

# License

Educational project developed for university coursework.

All rights reserved to project contributors.
