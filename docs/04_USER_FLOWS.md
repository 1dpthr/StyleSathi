# Style Sathi — User Flow Map

## Purpose

This document maps the main journeys visible in the supplied designs. It is a planning document; exact navigation and behavior must be confirmed by inspecting the individual screens.

## 1. Customer — Shopping and Checkout

Home
→ Search or browse products
→ Product Details
→ Add to Cart
→ Your Cart
→ Shipping Information
→ Payment
→ Order Confirmation
→ Order Review / My Orders
→ Track Orders

**Screens involved:** Home Page, Search, Product details, Your cart, Your cart 2, Shipping information, Payment, Order Confirmation, Order Review, My Orders, Track Orders.

**Questions to confirm during design review:**

* Can customers browse without signing in?
* When is sign-in required?
* Does Add to Cart require selecting a size or variant?
* Which payment methods are supported?
* Is order placement confirmed by the backend before showing success?

## 2. Customer — Account Management

Account
→ Account Details
→ Edit Profile
→ Change Profile Image

Related screens: Shipping Address, Payment Method.

**Questions to confirm:**

* Can a customer save multiple addresses?
* Can customers add, edit, and remove payment methods?
* Which profile fields are editable?

## 3. Customer — Saved Products

Home / Product Details
→ Wishlist
→ Product Details

**Questions to confirm:**

* Can a customer add or remove products from the wishlist?
* Is the wishlist available across devices after sign-in?

## 4. Customer — Virtual Try-On

Product or Virtual Try-On entry
→ Camera Permission
→ Try-On / Shoe Try-on / Virtual Body
→ Wardrobe Suggestion

**Important:** Treat camera access, body measurement, image processing, and try-on behavior as separate requirements. Do not implement them based only on screen appearance. Confirm device permissions, privacy expectations, and the intended technical behavior first.

## 5. Seller — Store and Product Management

Seller Sign In
→ Seller Store Setup / Application
→ Seller Dashboard
→ Listed Items
→ Add New Product / Edit Items

Related areas: Offers, Orders, Order Details, Payment & Payout, Notifications, Settings, Edit Profile.

**Questions to confirm:**

* Must a seller be approved before listing products?
* Which product fields are mandatory?
* Who approves or moderates product listings?
* Which order status changes can sellers perform?

## 6. Admin — Platform Management

Admin Dashboard
→ Seller Applications
→ Seller Application Details
→ Approve / Reject / Suspend Seller

Admin Dashboard
→ Products Moderation
→ Review Product
→ Approve / Reject Product

Admin Dashboard
→ Order Management

Related areas: Active Sellers, Settings, Notifications, Payment Methods, Payment & Payout, Edit Profile.

**Questions to confirm:**

* Are there multiple admin permission levels?
* What are the allowed seller and product review decisions?
* Which actions require a reason or audit record?
* What can admins change in order management?

## 7. First Implementation Candidate

The first candidate for implementation is the **Customer browsing-to-cart flow**:

Home → Search/Browse → Product Details → Add to Cart → Cart

This lets us validate the design system, navigation, product model, and basic state management before integrating checkout or payments.

Do not begin implementation until the individual screens and expected interactions for this flow have been reviewed and approved.
