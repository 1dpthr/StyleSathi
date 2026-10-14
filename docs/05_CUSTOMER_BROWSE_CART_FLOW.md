# Customer Browse-to-Cart Flow

## Purpose

Define the first customer-side feature to implement in Flutter, based on the supplied Style Sathi customer Figma designs.

## Scope

Included:

* Home page
* Product search
* Product details
* Add product to cart
* Cart

Not included in this milestone:

* Checkout and payment
* Order tracking
* Wishlist
* Virtual try-on
* Seller or admin features

## Screens and observed design

### 1. Home Page

Reference: `home Page.png`

Observed:

* Product and fashion imagery arranged in a vertically scrolling layout.
* Bottom navigation is present.
* The design appears to include entry points to other shopping areas.

Implementation notes:

* Recreate the visible layout and navigation from the Figma reference.
* Use temporary product data until backend integration is implemented.
* Confirm the exact home-page sections and navigation destinations during screen-by-screen review.

### 2. Search

Reference: `search.png`

Observed:

* Search field at the top.
* Category/filter chips are visible.
* Product imagery is shown below.
* The reference image shows the keyboard open.

Implementation notes:

* Search should accept text.
* Tapping a product should open its Product Details screen.
* The exact filter behavior and search-result rules still need confirmation.

### 3. Product Details

Reference: `Product details.png`

Observed:

* Large product image.
* Product name and price information.
* Product options, including size and color selectors.
* Add to Cart and try-on actions.
* Product description area.

Implementation notes:

* The selected size and color must be retained when adding the item to the cart.
* Add to Cart should provide visible feedback.
* The try-on action is outside this milestone; it can remain a placeholder until its own feature is planned.
* Confirm required options and stock behavior before implementation.

### 4. Cart

References: `your cart.png`, `your cart 2.png`

Observed:

* Product image and product information.
* Quantity controls.
* A summary showing item/shipping/total amounts.
* A Proceed to Checkout button.
* Bottom navigation.

Implementation notes:

* Cart should display the product added from Product Details.
* Quantity changes should update the displayed total.
* Removing an item should update the cart.
* Proceed to Checkout is outside this milestone; it may navigate to a placeholder or remain disabled until checkout is implemented.
* The two cart references look very similar. Confirm whether they represent different states or are duplicate exports.

## Primary user flow

Home → Search → Select Product → Product Details → Select Options → Add to Cart → Cart

## Functional acceptance criteria

* [ ] Customer can open Search from the app navigation.
* [ ] Customer can enter a search query.
* [ ] Customer can open a product from the results.
* [ ] Product Details displays the selected product.
* [ ] Customer can select available product options shown in the design.
* [ ] Add to Cart adds the selected product and options to the cart.
* [ ] Cart displays the added product and its selected options.
* [ ] Customer can increase or decrease quantity.
* [ ] Cart totals update when quantity changes.
* [ ] Customer can remove a product from the cart.
* [ ] Empty-cart state is handled.
* [ ] Layout remains usable on different mobile screen sizes.

## Items to confirm before coding

* Should the home page search icon open the Search screen?
* Does Add to Cart immediately open Cart, or show a confirmation first?
* Can the cart contain multiple different products?
* Are size and color required before adding a product?
* Do the two cart images represent different states?
* Should cart data persist after the app is closed? This will affect implementation.

## Implementation boundary

Build only the customer Browse-to-Cart flow in the first implementation milestone. Use reusable widgets and temporary local/mock data initially. Do not implement Firebase, payment processing, seller features, admin features, or virtual try-on in this milestone.

The Figma images define visual references; any behavior not clearly shown in the designs must be confirmed rather than assumed.
