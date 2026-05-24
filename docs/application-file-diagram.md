# Application File Diagram

# Overview

This page describes the internal structure of the BookShopApp project.

The application follows MVVM architecture and modular project organization.

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
├── docs/
└── README.md
```

---

# Architecture

The project uses MVVM architecture.

## Model

Contains:
- business entities
- database models
- domain logic

Examples:
- User
- Product
- Order
- Payment

---

## View

Contains:
- SwiftUI screens
- reusable UI components
- navigation

Examples:
- LoginView
- CatalogView
- CartView

---

## ViewModel

Contains:
- presentation logic
- state management
- interaction between View and Model

Examples:
- LoginViewModel
- CartViewModel
- CatalogViewModel

---

## Services

Contains:
- authentication services
- database services
- payment services
- order services

---

## Database Layer

Contains:
- SQLite integration
- repositories
- persistence logic

---

# Application Modules

## Authentication Module
Responsible for:
- registration
- login
- session persistence

---

## Catalog Module
Responsible for:
- product browsing
- searching
- filtering

---

## Cart Module
Responsible for:
- cart management
- quantity updates
- price calculation

---

## Order Module
Responsible for:
- order creation
- order tracking
- cancellation

---

## Payment Module
Responsible for:
- payment processing
- refunds
- payment validation

---

## Localization Module
Responsible for:
- translations
- language switching
- localized resources

---

# Design Principles

The project follows:
- SOLID principles
- separation of concerns
- reusable components
- modular architecture
- clean code practices
