# 🚗 Beep Roadside Assistance

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GetX](https://img.shields.io/badge/State%20Management-GetX-orange)](https://pub.dev/packages/get)

A comprehensive on-demand roadside assistance platform connecting vehicle owners with nearby mechanics in real-time.

---

## 📖 Table of Contents

- [Overview](#overview)
- [App Idea & Core Concept](#app-idea--core-concept)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Installation & Run Guide](#installation--run-guide)
- [Usage](#usage)
- [Future Improvements](#future-improvements)
- [Contribution](#contribution)
- [License](#license)
- [Author](#author)

---

## 📋 Overview

**Beep Roadside Assistance** is a cross-platform mobile application built with Flutter that provides on-demand roadside assistance services. The app serves as a two-sided marketplace where vehicle owners can browse, book, and track mechanics, while service providers can manage availability, receive orders, navigate to customers, and handle payments — all in real-time.

The platform supports five core roadside emergency services:
- 🚛 **Towing**
- 🔓 **Lockout Assistance**
- 🔋 **Jump Start**
- 🛞 **Flat Tire Repair**
- ⛽ **Gasoline Delivery**

---

## 💡 App Idea & Core Concept

The app addresses a common pain point: vehicle breakdowns in remote or inconvenient locations. Instead of searching for mechanics manually, users can:

1. **Select a service** based on their emergency type
2. **Browse nearby mechanics** with ratings and pricing
3. **Book instantly** with vehicle and location details
4. **Track in real-time** as the mechanic navigates to their location
5. **Chat directly** with the assigned mechanic
6. **Pay and review** after service completion

Mechanics, on the other hand, get a dedicated dashboard to manage their availability, service area, orders, and earnings — all from a single interface.

---

## ✨ Key Features

### 👤 User Features
- **Role-based onboarding** — Choose between User or Mechanic during signup
- **Email/OTP authentication** — Secure login with email verification
- **Service browsing** — Filter mechanics by service type and location
- **Mechanic profiles** — View ratings, reviews, services, and pricing
- **Favorites system** — Save preferred mechanics for quick rebooking
- **Multi-step checkout** — Select services, vehicles, and pickup location
- **Real-time GPS tracking** — Live mechanic location with route polyline on map
- **In-app chat** — Real-time messaging with image sharing via Socket.io
- **Booking history** — View current and past service requests
- **Rating & reviews** — Rate mechanics after service completion
- **Vehicle management** — Add and manage multiple vehicles
- **Push notifications** — In-app notifications for order updates
- **Multi-language support** — English, Arabic (RTL), Spanish
- **Dark/Light theme** — Theme toggle support

### 🔧 Mechanic Features
- **Availability toggle** — Go online/offline to receive orders
- **Service area management** — Define service radius on interactive map
- **Service & pricing management** — Add, edit, and price services
- **Order management** — Accept, cancel, or mark orders as complete
- **Live navigation** — Real-time map routing to customer location
- **Wallet overview** — Track earnings, balance, and transaction history
- **Bank account management** — Add/remove payment methods
- **Withdrawal requests** — Request fund transfers to linked accounts
- **Chat with customers** — Direct messaging with users

---

## 🏗️ Architecture

The app follows a **GetX-based MVVM (Model-View-ViewModel) architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│                   Presentation                   │
│   (Views, Widgets, UI Components)               │
├─────────────────────────────────────────────────┤
│                 Business Logic                   │
│   (GetX Controllers, State Management)          │
├─────────────────────────────────────────────────┤
│                    Data Layer                    │
│   (NetworkCaller, API Services, Models)         │
├─────────────────────────────────────────────────┤
│                 External Services                │
│   (Google APIs, Socket.io, SharedPreferences)   │
└─────────────────────────────────────────────────┘
```

### Key Architectural Patterns
- **Feature-first modular structure** — Each feature (home, booking, payment, etc.) has its own module with controllers, views, models, and widgets
- **Lazy dependency injection** — GetX bindings inject controllers only when routes are accessed
- **Reactive state management** — Rx observables (`RxBool`, `RxList`, `Rx<Model>`) for automatic UI updates
- **Singleton network layer** — `NetworkCaller` provides a centralized HTTP client with interceptors for auth tokens and logging
- **Role-based routing** — Dynamic bottom navigation and screen access based on user role (`user` vs `mechanic`)

### Authentication Flow
```
Signup → OTP Verification → Login → JWT Token Storage → Role-based Redirect
```

### Real-time Communication
- **Socket.io** for live chat and location tracking
- Events: `send-message`, `message-sent`, `updateLocation`
- Auto-reconnection and token-based authentication via headers

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.7.2 |
| **Language** | Dart 3.7.2 |
| **State Management** | GetX 4.7.2 |
| **Routing** | GetX Named Routes |
| **HTTP Client** | `http` with custom `NetworkCaller` wrapper |
| **Real-time** | Socket.io Client 3.1.2 |
| **Maps** | `google_maps_flutter` |
| **Location** | `geolocator`, `geocoding` |
| **Route Polylines** | `flutter_polyline_points` 3.0.0 |
| **Google APIs** | Places Autocomplete, Geocoding, Distance Matrix, Routes API v2 |
| **Local Storage** | `shared_preferences`, `get_storage` |
| **Localization** | GetX translations (EN, AR, ES) with RTL support |
| **Responsive UI** | `flutter_screenutil` (393x852 base) |
| **UI Components** | `google_fonts`, `flutter_svg`, `shimmer`, `lottie`, `carousel_slider`, `pin_code_fields` |
| **Media** | `image_picker`, `file_picker`, `cached_network_image` |
| **Utilities** | `jwt_decoder`, `url_launcher`, `share_plus`, `intl` |
| **PDF** | `pdf`, `printing` (declared) |
| **Version Management** | FVM (Flutter Version Management) |

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point & GetMaterialApp setup
├── app/
│   ├── data/
│   │   ├── api_constants.dart         # API endpoints & base URLs
│   │   ├── network_caller.dart        # HTTP client with interceptors
│   │   ├── google_api_service.dart    # Google Places/Geocoding integration
│   │   └── current_location_service.dart  # Geolocator wrapper
│   ├── modules/                       # Feature modules (MVVM structure)
│   │   ├── splash/                    # Splash screen
│   │   ├── onboarding/                # Onboarding & role selection
│   │   ├── sign_in/                   # Login
│   │   ├── signup/                    # Registration
│   │   ├── otp/                       # OTP verification
│   │   ├── forgot_password/           # Password recovery
│   │   ├── change_password/           # Password reset
│   │   ├── home/                      # User home & service browsing
│   │   ├── mechanic_user_side/        # Mechanic list & details
│   │   ├── check_out/                 # Booking checkout flow
│   │   ├── my_booking/                # User booking history & tracking
│   │   ├── account/                   # Profile, vehicles, favorites, settings
│   │   ├── message_inbox/             # Real-time chat (Socket.io)
│   │   ├── notification/              # In-app notifications
│   │   ├── mechanic_home/             # Mechanic dashboard
│   │   ├── mechanic_order/            # Mechanic order management
│   │   ├── mechanic_service/          # Mechanic service management
│   │   └── mechanic_payment/          # Mechanic earnings & withdrawals
│   └── routes/
│       ├── app_pages.dart             # GetX route definitions (46 routes)
│       └── app_routes.dart            # Route name constants
├── common/
│   ├── controller/                    # Global controllers (theme, localization)
│   ├── widgets/                       # Reusable UI components
│   ├── app_color/                     # Color constants
│   ├── app_icons/                     # SVG icon paths
│   ├── app_images/                    # Image asset helpers
│   ├── bottom_menu/                   # Role-based bottom navigation
│   ├── di/                            # Dependency injection setup
│   ├── helper/                        # Local store, token decoder, translations
│   ├── themes/                        # Light/dark theme configs
│   └── prefs_helper/                  # SharedPreferences wrapper
assets/
├── language/                          # i18n JSON files
├── icons/                             # SVG & PNG icons
├── image/                             # Raster images
├── lotti/                             # Lottie animations
└── font/                              # Custom fonts (Outfit, DMSans)
```

---

## 🚀 Installation & Run Guide

### Prerequisites
- **Flutter SDK** ≥ 3.7.2 ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK** ≥ 3.7.2 (bundled with Flutter)
- **Android Studio** / **VS Code** with Flutter extensions
- **Google Maps API Key** (for map features)
- **Emulator** or **Physical Device**

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/redmi.dm.git
   cd Roadside_service
   ```

2. **Install FVM (optional, for version consistency)**
   ```bash
   dart pub global activate fvm
   fvm install
   fvm use
   ```

3. **Get dependencies**
   ```bash
   flutter pub get
   ```

4. **Configure Google Maps API Key**
   - **Android**: Add your API key to `android/app/src/main/AndroidManifest.xml`
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY_HERE" />
     ```
   - **iOS**: Add your API key to `ios/Runner/AppDelegate.swift`

5. **Update API Base URL (if needed)**
   - Edit `lib/app/data/api_constants.dart` to point to your backend server

6. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📱 Usage

### For Users
1. **Sign up** with email, password, and select "User" role
2. **Verify your email** via OTP code
3. **Browse services** on the home screen (Towing, Lockout, Jump Start, etc.)
4. **Select a mechanic** from the list or search by location/rating
5. **Book a service** by selecting your vehicle, services, and pickup location
6. **Track your mechanic** in real-time on the map with live ETA updates
7. **Chat directly** with the mechanic via the messaging feature
8. **Make payment** and leave a review after service completion

### For Mechanics
1. **Sign up** with email, password, and select "Mechanic" role
2. **Set your availability** by toggling online/offline status
3. **Define your service area** on the map with a radius selector
4. **Add services and pricing** you offer (e.g., Towing - $50/hr)
5. **Receive incoming orders** and accept/cancel based on availability
6. **Navigate to customers** using the live map with route guidance
7. **Mark orders complete** and track earnings in your wallet
8. **Add bank account** details and request withdrawals

---

## 🔮 Future Improvements

- [ ] **Push notifications** via Firebase Cloud Messaging (FCM)
- [ ] **Payment gateway integration** (Stripe, PayPal) for secure transactions
- [ ] **PDF invoice generation** for completed orders
- [ ] **Offline support** with local data caching
- [ ] **Repository pattern** abstraction for better testability
- [ ] **Unit & widget tests** for critical flows
- [ ] **Admin dashboard** for platform management
- [ ] **Mechanic verification** system (background checks, certifications)
- [ ] **Multi-vehicle support** for fleet management
- [ ] **Emergency SOS** feature for critical situations
- [ ] **Voice navigation** integration for mechanics
- [ ] **Subscription plans** for frequent users
- [ ] **Analytics & crash reporting** (Firebase Analytics, Crashlytics)

---

## 🤝 Contribution

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the existing architecture patterns and passes all tests.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Shuvo**  
[GitHub Profile](https://github.com/your-username)

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ If you found this project helpful, consider giving it a star!</p>
</div>
