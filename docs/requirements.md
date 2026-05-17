# BookShopApp Requirements Specification

# 1. Purpose of the Application

BookShopApp is a mobile iOS application designed for ordering printed books,
electronic books, stationery products, and related goods.

The application allows users to:
- browse product catalog
- search and filter products
- add products to cart
- place and manage orders
- choose payment methods
- select pickup points on a map
- manage delivery addresses
- split or cancel orders

The system is developed as part of the team software engineering project
for the “Mobile Programming Technologies” course.

# 2. General Description

## 2.1 Target Users

The target users of the application are:

- students
- office workers
- readers
- customers purchasing books and stationery products

The application supports both guest users and registered users.

Guest users can:
- browse products
- search products
- view product details

Registered users can additionally:
- manage cart
- place orders
- select payment methods
- manage delivery addresses
- track orders
- cancel orders
- split orders

## 2.2 Software Requirements

The application requires:

- iOS 14 or newer
- Xcode 13 or newer
- Swift 4.0+
- Internet connection for synchronization and maps
- GitHub repository for collaborative development

## 2.3 Hardware Requirements

The application supports:
- iPhone devices
- iPad devices

Minimum requirements:
- 4 GB RAM
- 200 MB available storage
- GPS support for pickup point functionality

# 3. Requirements Specification

## 3.1 Functional Requirements

### 3.1.1 Authentication

The application shall provide user authentication functionality.

Features:
- user registration
- user login
- logout
- session persistence
- profile management

Requirements:
- user email must be unique
- password must contain at least 8 characters
- invalid credentials shall display error message
- authenticated session shall be stored locally using UserDefaults

### 3.1.2 Product Catalog

The application shall provide a product catalog.

Features:
- browse products
- search products
- filter products by category
- view product details
- display product images
- display product availability

Requirements:
- products shall be grouped into categories
- each product shall contain:
  - title
  - description
  - price
  - image
  - stock amount
- search shall support partial matches
- unavailable products shall be visually marked

### 3.1.3 Shopping Cart

The application shall provide shopping cart functionality.

Features:
- add products to cart
- remove products from cart
- edit quantity
- calculate total price
- clear cart

Requirements:
- quantity cannot be less than 1
- total price shall update automatically
- cart state shall persist between sessions

### 3.1.4 Orders

The application shall provide order management functionality.

Features:
- create order
- cancel order
- split order
- track order status

Requirements:
- order shall contain one or more products
- order status shall be updated automatically
- users shall be able to cancel active orders
- unavailable products may be separated into another order

### 3.1.5 Payment System

The application shall support payment processing.

Features:
- online payment
- cash payment
- payment cancellation
- refund support

Requirements:
- payment status shall be stored
- failed payment shall display error message
- users shall be able to retry payment
- online payment may be transferred to another order

### 3.1.6 Pickup Points Map

The application shall provide pickup point selection using maps.

Features:
- display pickup points
- detect user location
- select nearest pickup point
- build route to pickup point

Requirements:
- application shall request location permission
- map shall support zoom and navigation
- nearest pickup point shall be suggested automatically

### 3.1.7 Localization

The application shall support localization.

Supported languages:
- English
- Russian
- Belorussian

Requirements:
- all buttons shall be translated
- all alerts shall be translated
- all validation messages shall be translated

## 3.2 Usability Requirements

The application interface shall follow Apple Human Interface Guidelines.

Requirements:
- intuitive navigation
- responsive interface
- minimal number of actions for checkout
- support for dark mode
- readable typography
- consistent UI components

## 3.3 Reliability Requirements

The application shall provide reliable data storage and error handling.

Requirements:
- application shall prevent data loss
- local database corruption shall be handled
- invalid user input shall be validated
- application crashes shall be minimized

## 3.4 Performance Requirements

The application shall provide acceptable performance.

Requirements:
- screen loading time shall not exceed 2 seconds
- search results shall appear within 1 second
- application shall support at least 1000 products
- cart operations shall execute instantly

# 4. Diagrams

## 4.1 Use Case Diagram

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

### Use Case Diagram

![Use Case Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_use_case.png)

---

## 4.2 Class Diagram

The class diagram describes the structure of the application and relationships
between entities.

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

Relationships:
- User owns cart
- User creates orders
- Cart contains cart items
- Order contains order items
- Product belongs to category
- Order uses payment
- Order may contain pickup point

### Class Diagram

![Class Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_class_diagram.png)

---

## 4.3 Sequence Diagram

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

Components:
- User
- Mobile App
- Cart Service
- Payment System
- Order Service
- SQLite Database

### Sequence Diagram

![Sequence Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_sequence.png)

---

## 4.4 Activity Diagram

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

### Activity Diagram

![Activity Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_activity.png)

---

## 4.5 Database Model

The database model is based on SQLite storage and describes the main entities,
their attributes, and relationships used in the application.

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

The database structure supports:
- authentication and profile management
- product catalog management
- shopping cart functionality
- order processing
- payment management
- pickup point selection
- persistent local storage using SQLite

![Database Model](https://github.com/cin-tie/tpmp-lab4-uml/blob/main/img/lab9_database_model.drawio.svg)
