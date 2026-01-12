# User Directory App - Sokrio Technologies Assignment

This is a robust, production-ready Flutter application built to demonstrate mastery of **Clean Architecture**, **State Management (GetX)**, and **Offline Persistence (Hive)**. The app fetches user data from a public API, manages infinite pagination, and ensures a seamless experience even without an internet connection.
---
## NOTE:

The API URL has a part of Cloudflare that causes browser only restrictions. So I Use a new similar API URL "https://jsonplaceholder.typicode.com/users" for fetching user data.
---
## 📱 Features
**Paginated User List**: Displays names and profile pictures using infinite scrolling to fetch users in batches (10 users per page).
*
**User Details**: Provides a dedicated view for detailed information, including email, full name, and high-resolution avatars.
*
**Intelligent Search**: Real-time local filtering by name that handles special characters and works without a network connection.
* 
* **Offline First**: Caches data locally using **Hive**. The app remains functional offline by loading the last synchronized data.
*
**Connectivity Awareness**: Includes "Pull-to-Refresh" and retry mechanisms for handling API failures or slow responses.
*
**Responsive UI**: Optimized typography and spacing designed to work across various screen sizes and orientations.

---
## 📱Screenshots [https://drive.google.com/drive/folders/1SNLGSqJ6NjKqStQal-NoMv4vI-xaEPwN?usp=sharing]

## 🛠 Tech Stack
**Framework**: Flutter
*
**State Management**: **GetX** for reactive UI and dependency injection.
*
**Architecture**: **Clean Architecture** (Separation of Data, Domain, and Presentation).
*
**Networking**: **http** package for REST API communication.
*
**Database**: **Hive** for high-performance NoSQL local caching.
* 
**Image Handling**: Cached Network Image for optimized performance and memory management.

---

## 📂 Architecture Overview
The project follows Clean Architecture principles to ensure the code is maintainable, scalable, and testable.
* 
**Domain Layer**: Contains the core Business Logic, Entities, and Repository Interfaces.
*
**Data Layer**: Handles data retrieval from the API (Remote) or Hive (Local) and implements the Repository Interfaces.
*
**Presentation Layer**: Contains GetX Controllers for state management and Widgets for the UI.

---

## 🚀 Getting Started
### Prerequisites

* Flutter SDK: `^3.0.0`
* Dart SDK

### Installation

1. **Clone the repository**:
## bash
git clone https://github.com/yourusername/flutter-user-directory.git
cd flutter-user-directory

2. **Install dependencies**:
## bash
flutter pub get

3. **Generate Hive Adapters**:
   This project uses `build_runner` for generating TypeAdapters.

## bash
dart run build_runner build --delete-conflicting-outputs

4. **Run the application**:
## bash
flutter run

---

## 🧪 Implementation Details
### Data Sync Strategy

The `UserRepository` acts as a single source of truth. When a user triggers a fetch:

1. The app attempts to reach `https://jsonplaceholder.typicode.com/users`.

2. On success, the local Hive box is updated with the fresh data.

3. On failure (Offline or Timeout), the app gracefully falls back to the local cache and notifies the user via a snackbar or error widget.

### Pagination Logic

The app uses a `ScrollController` in the `UserController` to monitor the scroll position. When the user reaches the threshold, the `page` parameter is incremented and the next batch of 10 users is appended to the list until the API returns an empty result.

---

## ⚖ Evaluation Criteria Compliance

**Clean Architecture**: Strict separation between layers.
*
**Error Handling**: Comprehensive handling of timeouts and offline states.
*
**Performance**: Local caching and optimized image loading.
*
**Bonus Features**: Implemented Hive caching, Pull-to-Refresh, and Dependency Injection.
