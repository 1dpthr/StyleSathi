# Style Sathi — Project Vision

## 1. Project Overview

Style Sathi is a fashion e-commerce platform designed to connect customers, sellers, and administrators through a set of mobile applications.

The project will contain three separate Flutter applications:

* **Customer App:** For customers to explore and interact with the platform.
* **Seller App:** For sellers to manage their participation in the platform.
* **Admin App:** For administrators to oversee and manage the platform.

All three applications will use a shared backend and reusable code where appropriate.

## 2. Main Goals

* Build a reliable and maintainable application.
* Follow the approved Figma designs closely.
* Keep customer, seller, and admin experiences separate.
* Use a consistent design system across the applications.
* Implement secure authentication and role-based access.
* Integrate Firebase carefully and verify each integration.
* Build and test the project in small, complete milestones.

## 3. Technology Direction

* **Frontend:** Flutter
* **Language:** Dart
* **Backend direction:** Firebase
* **Repository structure:** One repository containing the three app targets and shared packages.

Specific Firebase services, architecture decisions, and package choices will be documented before implementation.

## 4. Design Reference

The provided Style Sathi Figma design packages are the primary visual reference.

The implementation should not replace the supplied designs with generic screens. Before implementing a screen, its layout, components, navigation, colors, typography, and assets must be reviewed against the relevant design.

## 5. Development Principles

1. Do not implement multiple major features in one step.
2. Do not make unrelated changes while working on a task.
3. Keep code modular, readable, and maintainable.
4. Reuse shared components when it makes sense.
5. Keep role-specific functionality isolated.
6. Never assume a Firebase integration works without testing it.
7. Run relevant checks after each implementation milestone.
8. Do not mark a feature complete until it has been implemented and verified.
9. Ask for clarification when requirements or designs are ambiguous.
10. Update project documentation as decisions are finalized.

## 6. Scope Control

This document defines the project direction, not the complete feature list.

Detailed requirements, database design, security rules, architecture, and development phases will be documented separately. Do not invent missing requirements or begin implementation based only on this document.
