# Database Schema

# Overview

The application uses SQLite database for persistent local storage.

The database supports:
- authentication
- product catalog
- shopping cart
- orders
- payments
- pickup points

---

# Main Entities

## users

Stores:
- user profile
- authentication data
- contact information

---

## products

Stores:
- product title
- description
- price
- stock
- category

---

## categories

Stores product categories.

---

## carts

Stores user shopping carts.

---

## cart_items

Stores products added to cart.

---

## orders

Stores user orders and statuses.

---

## order_items

Stores ordered products.

---

## payments

Stores payment information and statuses.

---

## pickup_points

Stores pickup locations and coordinates.

---

## delivery_addresses

Stores user delivery addresses.

---

# Entity Relationships

- one user owns one cart
- one user has many orders
- one order contains many order items
- one product belongs to one category
- one payment belongs to one order

---

# Database Diagram

![Database Model](https://github.com/cin-tie/tpmp-lab4-uml/blob/main/blob/main/img/lab9_database_model.drawio.svg)

---

# Storage Architecture

The database layer includes:
- repositories
- persistence services
- SQLite queries
- local caching

---

# Persistence Features

The database supports:
- session persistence
- cart persistence
- order history
- offline storage
