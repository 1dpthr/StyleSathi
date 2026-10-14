# Style Sathi — Figma Screen Inventory

## Purpose

This document lists the screens and design assets found in the supplied Figma export ZIPs. It is an inventory, not a finalized specification of behavior.

Before implementing a screen, inspect its image and record its layout, components, navigation, states, and interactions.

## 1. Customer App

Source: `Style Sathi User.zip`
Files found: 31

| #  | Screen / Asset                            |
| -- | ----------------------------------------- |
| 1  | Landing page                              |
| 2  | Onboard tour 1.0                          |
| 3  | Onboard tour 2.0                          |
| 4  | Onboard tour 3.0                          |
| 5  | Signup/login                              |
| 6  | Home Page                                 |
| 7  | Nav bar                                   |
| 8  | Search                                    |
| 9  | Product details                           |
| 10 | Your cart                                 |
| 11 | Your cart 2                               |
| 12 | Shipping information                      |
| 13 | Payment                                   |
| 14 | Order Confirmation                        |
| 15 | Order Review                              |
| 16 | My Orders                                 |
| 17 | Track Orders                              |
| 18 | Shipping Address                          |
| 19 | Payment Method                            |
| 20 | Wishlist                                  |
| 21 | Account details                           |
| 22 | Edit Profile                              |
| 23 | Change Profile image                      |
| 24 | Virtual body                              |
| 25 | Shoe Try-on                               |
| 26 | Try-On                                    |
| 27 | Wardrobe Suggestion                       |
| 28 | Camera Permission                         |
| 29 | Loading                                   |
| 30 | SoftechDigital Trainingacademy page image |
| 31 | User                                      |

## 2. Seller App

Source: `Style Sathi Seller.zip`
Files found: 18

| #  | Screen / Asset                            |
| -- | ----------------------------------------- |
| 1  | Loading                                   |
| 2  | Landing page                              |
| 3  | Seller Log in                             |
| 4  | Seller store setup                        |
| 5  | Seller new product                        |
| 6  | Seller store dashboard                    |
| 7  | Listed items                              |
| 8  | Edit Items                                |
| 9  | Offers                                    |
| 10 | Orders                                    |
| 11 | Orders Details                            |
| 12 | Payment & Payout                          |
| 13 | Seller Application details                |
| 14 | Settings                                  |
| 15 | Notifications                             |
| 16 | Payment Method                            |
| 17 | Edit Profile                              |
| 18 | SoftechDigital Trainingacademy page image |

## 3. Admin App

Source: `Style Sathi Admin.zip`
Files found: 17

| #  | Screen / Asset             |
| -- | -------------------------- |
| 1  | Admin Dashboard            |
| 2  | Seller Applications        |
| 3  | Seller Application details |
| 4  | Manage seller              |
| 5  | Active Sellers             |
| 6  | Products Moderation        |
| 7  | Review Product             |
| 8  | Approval                   |
| 9  | Application suspended      |
| 10 | Product Approval           |
| 11 | Order Management           |
| 12 | Settings                   |
| 13 | Notifications              |
| 14 | Payment Method             |
| 15 | Payment Method 2           |
| 16 | Payment & Payout           |
| 17 | Edit Profile               |

## 4. Inventory Notes

* The filenames have been normalized for readability; original image filenames may use different capitalization or spelling.
* `SoftechDigital Trainingacademy_page-0001 1.png` appears in the Customer and Seller archives. Confirm whether it is a reference/branding asset or an actual screen.
* Customer and Seller each contain a loading image.
* Admin contains two Payment Method images. Inspect both to determine whether they represent separate screens or design states.
* Customer contains both `Your cart` and `Your cart 2`, and both `Shoe Try-on` and `Try-On`. Inspect these pairs before treating them as separate routes.
* The inventory does not establish navigation order or business rules.

## 5. Screen Review Checklist

For every screen, record:

* [ ] What the screen is for
* [ ] How the user reaches it
* [ ] Main UI components
* [ ] Buttons and their expected actions
* [ ] Input fields and validation
* [ ] Loading, empty, error, and success states
* [ ] Data required from the backend
* [ ] Whether it is a separate screen or a state of another screen
* [ ] Whether it matches the approved design

## 6. Implementation Rule

Do not ask an AI coding assistant to implement all screens from filenames alone. First review the actual images, group related screens into user flows, and confirm unclear behavior. Implement and verify one flow at a time.
