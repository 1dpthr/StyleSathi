# Style Sathi — Product Requirements

## 1. Purpose

This document defines the initial functional scope of Style Sathi. It is a planning baseline, not permission to implement every feature immediately.

The supplied Figma designs are the visual reference. Any feature or behavior not clear from the designs must be confirmed before implementation.

## 2. Customer App

The customer app is for people who browse and purchase fashion products.

### Initial feature areas

* Account registration, sign-in, and sign-out
* Customer profile management
* Browse products and categories
* Search and filter products
* View product details, images, sizes, and available options
* Manage a shopping cart
* Place and track orders
* View order history
* Manage delivery addresses
* Receive relevant order notifications

### Requirements to confirm

* Guest browsing
* Wishlist and saved products
* Product reviews and ratings
* Discount codes and promotions
* Payment methods and payment provider
* Returns, refunds, and cancellations

## 3. Seller App

The seller app is for sellers who manage their products and orders.

### Initial feature areas

* Seller registration and sign-in
* Seller profile and store information
* Seller onboarding and approval status
* Add, edit, and manage products
* Manage product images, sizes, variants, and stock
* View and manage incoming orders
* Update order status
* View basic sales and order summaries

### Requirements to confirm

* Seller verification documents
* Commission and platform fees
* Payouts and seller payment details
* Shipping and delivery integration
* Seller promotions
* Sales analytics and reports

## 4. Admin App

The admin app is for authorized administrators who operate the platform.

### Initial feature areas

* Secure admin sign-in
* Admin dashboard
* View and manage customer accounts
* View and manage seller accounts
* Review seller applications
* Review and manage product listings
* View and manage orders
* Manage product categories
* View platform activity and basic summaries

### Requirements to confirm

* Admin roles and permission levels
* Refund and dispute handling
* Commission configuration
* Promotion management
* Audit logs
* Reports and exports

## 5. Shared Platform Requirements

* All apps use the same backend and source of truth.
* Customer, seller, and admin data access must be separated by authorization rules.
* A user must not gain access to another role's functions by changing the app or client-side state.
* Important operations must be validated by trusted backend logic and security rules.
* Loading, empty, success, and error states must be designed and implemented.
* Network failures must be handled without losing user-entered data unnecessarily.
* Sensitive information must not be written to logs.
* The apps must be testable independently.

## 6. Non-Functional Requirements

### Maintainability

Use clear module boundaries, consistent naming, and documented architecture.

### Security

Apply least-privilege access. Client-side checks alone are not security controls.

### Reliability

Handle common failures, including unavailable network, invalid input, and backend errors.

### Performance

Avoid unnecessary network requests and large image downloads. Use pagination where appropriate.

### Accessibility

Use readable text, adequate contrast, and usable touch targets.

### Testing

Add tests for important business logic, authorization-sensitive behavior, and critical user journeys.

## 7. Scope and Implementation Rules

* Do not implement unconfirmed features.
* Do not invent screens that are absent from the approved designs unless required and agreed.
* Do not connect real payments or production services until their requirements and credentials are confirmed.
* Implement one app flow or milestone at a time.
* A feature is complete only after its expected behavior has been tested.
* Update this document when a requirement is confirmed or changed.
