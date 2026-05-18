# Functional Requirements

# Overview

This page describes the functional requirements of the BookShopApp application.

The requirements define the expected behavior of the system and interactions between users and the application.

---

# User Roles

## Guest User

Guest users can:
- browse products
- search products
- filter products
- view product details

---

## Registered User

Registered users can additionally:
- manage cart
- place orders
- select payment methods
- manage delivery addresses
- track orders
- cancel orders
- split orders
- select pickup points

---

# Functional Modules

## Authentication

Features:
- registration
- login
- logout
- session persistence
- profile management

Requirements:
- email must be unique
- password must contain at least 8 characters
- invalid credentials display errors

---

## Product Catalog

Features:
- browse products
- search products
- category filtering
- product details
- product availability

---

## Shopping Cart

Features:
- add products
- remove products
- edit quantity
- calculate total price
- clear cart

---

## Orders

Features:
- create orders
- cancel orders
- split orders
- track order status

---

## Payment System

Features:
- online payment
- cash payment
- refund support
- payment retry

---

## Pickup Points

Features:
- display map
- detect user location
- select pickup point
- build route

---

# Use Case Scenarios

## Scenario: User Registration

### Main Flow

1. User opens registration screen
2. User enters email and password
3. User submits form
4. System validates data
5. System creates account
6. User enters application

### Alternative Flow

- invalid email
- weak password
- duplicate account

---

## Scenario: Checkout

### Main Flow

1. User opens cart
2. User verifies products
3. User proceeds to checkout
4. User selects payment method
5. User selects pickup point
6. System processes payment
7. Order is created
8. Confirmation screen appears

### Alternative Flow

- payment failed
- unavailable products
- network error

---

# Use Case Diagram

![Use Case Diagram](https://raw.githubusercontent.com/NgdMav/tpmp-lab4-uml/main/img/lab9_use_case.png)

---

# User Stories

## US-1 Registration

As a guest user,  
I want to create an account,  
So that I can place orders.

---

## US-8 Add Product to Cart

As a user,  
I want to add products to cart,  
So that I can purchase them later.

---

## US-15 Payment

As a user,  
I want to complete payment,  
So that my order can be confirmed.

