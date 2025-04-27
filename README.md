Project Documentation for Find My Home
Find My Home is a mobile application developed using Flutter and Firebase to provide a platform for users to manage flat listings, search for flats, and handle bookings. This application supports multiple user roles including Customers, Flat Owners, and Admins, with different functionalities tailored to each role. The system ensures seamless interaction between users while leveraging Firebase services for authentication, storage, and real-time database management.

Table of Contents
    Overview
    Key Features
    Tech Stack
    Installation & Setup
    App Architecture
    Usage Instructions
    Contributing


1. Overview
Find My Home is a cross-platform mobile application that simplifies the process of flat management and flat booking. It enables users to:

Post flats (as a flat owner).

Search and book flats (as a customer).

Manage users and flat listings (as an admin).

This application integrates Google Maps API to display flat locations and utilizes Firebase for authentication and data storage.

2. Key Features
User Authentication
Email-based Login & Registration: Using Firebase Authentication, users can securely log in or register.

Role-based Access: Users are categorized into Admin, Flat Owner, and Customer, each with their own dashboard and permissions.

Admin Dashboard
Manage users and flats, including the ability to delete and approve listings.

Flat Owner Dashboard
Add and manage flat posts including title, description, price, and location.

Customer Dashboard
Search for flats based on title or description.

Book flats and view bookings in the profile.

Google Maps Integration
Display flat locations on an interactive map to provide users with better context.

Real-Time Firestore Integration
Firebase Firestore is used to store user data, flat details, and booking information.

3. Tech Stack
Flutter: A cross-platform framework for building natively compiled applications for mobile from a single codebase.

Firebase: A platform that provides authentication, Firestore (database), and storage services.

Google Maps: Used for displaying flat locations on a map.

Dart: Programming language used to develop the Flutter application.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
