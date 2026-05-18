# BookShopApp User Stories

# 1. Authentication

### US-1 User Registration

As a guest user,
I want to create an account,
So that I can place and manage orders.

Priority: High

Acceptance Criteria:
- User can enter email, password, and phone number
- Email must be unique
- Password must contain at least 8 characters
- Successful registration creates user profile
- Validation errors are displayed correctly

### US-2 User Login

As a registered user,
I want to log into my account,
So that I can access my cart and orders.

Priority: High

Acceptance Criteria:
- User can enter valid credentials
- Invalid credentials display error message
- Successful login opens main catalog screen
- User session persists after app restart

### US-3 User Logout

As a registered user,
I want to log out from the application,
So that I can protect my personal data.

Priority: Medium

Acceptance Criteria:
- Logout button is accessible
- User session is cleared
- User returns to authorization screen

# 2. Product Catalog

### US-4 Browse Products

As a user,
I want to browse products,
So that I can find books and stationery items.

Priority: High

Acceptance Criteria:
- Product list loads successfully
- Products display title, image, and price
- Products are grouped by category
- Loading state is displayed

### US-5 Search Products

As a user,
I want to search products by name,
So that I can quickly find needed items.

Priority: High

Acceptance Criteria:
- Search bar is available
- Partial matches are supported
- Search results update dynamically
- Empty results screen is displayed

### US-6 Filter Products

As a user,
I want to filter products by category,
So that I can browse relevant items.

Priority: Medium

Acceptance Criteria:
- Categories are displayed
- Products filter correctly
- Selected category is highlighted

### US-7 View Product Details

As a user,
I want to view detailed product information,
So that I can make purchase decisions.

Priority: High

Acceptance Criteria:
- Product description is displayed
- Product image is displayed
- Product availability is displayed
- Add-to-cart button is available

# 3. Shopping Cart

### US-8 Add Product to Cart

As a user,
I want to add products to cart,
So that I can purchase them later.

Priority: High

Acceptance Criteria:
- Product can be added to cart
- Cart counter updates automatically
- Duplicate products increase quantity

### US-9 Edit Cart Quantity

As a user,
I want to change product quantity,
So that I can manage my order.

Priority: High

Acceptance Criteria:
- User can increase quantity
- User can decrease quantity
- Quantity cannot be less than 1
- Total price updates automatically

### US-10 Remove Product from Cart

As a user,
I want to remove products from cart,
So that I can update my order.

Priority: Medium

Acceptance Criteria:
- Product can be removed
- Cart updates automatically
- Empty cart state is displayed

# 4. Orders

### US-11 Create Order

As a user,
I want to place an order,
So that I can purchase selected products.

Priority: High

Acceptance Criteria:
- User can checkout successfully
- Order is saved in database
- Confirmation screen is displayed

### US-12 Track Orders

As a user,
I want to track my orders,
So that I can monitor delivery status.

Priority: Medium

Acceptance Criteria:
- Order history screen exists
- Order status is displayed
- Order details are accessible

### US-13 Cancel Order

As a user,
I want to cancel active orders,
So that I can stop unnecessary purchases.

Priority: Medium

Acceptance Criteria:
- Active orders can be canceled
- Confirmation dialog is displayed
- Order status updates correctly

# 5. Payment System

### US-14 Select Payment Method

As a user,
I want to choose payment method,
So that I can pay conveniently.

Priority: High

Acceptance Criteria:
- Online payment option exists
- Cash payment option exists
- Selected payment method is highlighted

### US-15 Process Payment

As a user,
I want to complete payment,
So that my order can be confirmed.

Priority: High

Acceptance Criteria:
- Payment processing screen exists
- Successful payment confirms order
- Failed payment shows error
- User can retry payment

# 6. Pickup Points

### US-16 Select Pickup Point

As a user,
I want to select a pickup point on map,
So that I can receive my order conveniently.

Priority: Medium

Acceptance Criteria:
- Pickup points display on map
- User location is detected
- User can select pickup point
- Selected point is saved to order

# 7. Localization

### US-17 Change Application Language

As a user,
I want to use the application in my preferred language,
So that I can understand the interface comfortably.

Priority: Medium

Acceptance Criteria:
- Application supports English
- Application supports Russian
- Application supports Belarusian
- UI updates after language change
