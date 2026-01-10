
Flutter User Directory - Sokrio Technologies Assignment
A robust Flutter application designed to demonstrate Clean Architecture, State Management (GetX), and Offline Capabilities (Hive). This app fetches user data from a public API, caches it for offline access, and provides search and pagination functionalities.
📱 Features
User List: Displays a paginated list of users with profile pictures and names.
User Details: Detailed view of a selected user (Email, ID, Avatar).
Search Functionality: Real-time local filtering of users by name.
Infinite Scrolling: Automatically loads more users as you scroll down.
Offline Mode: caches fetched data using Hive. If the internet is unavailable, the app seamlessly loads data from the local database.
Pull-to-Refresh: Refreshes the list and clears the current search context.
Error Handling: Robust handling of Network, Server, and Timeout errors with user-friendly retry options.
🛠 Tech Stack
Framework: Flutter (Dart)
State Management: GetX
Architecture: Clean Architecture (Domain, Data, Presentation layers)
Networking: http
Local Database: Hive (NoSQL)
Connectivity: connectivity_plus (Internet checking)
Image Caching: cached_network_image
⚠️ Important Note Regarding API
The original assignment requested the use of reqres.in. However, during development, calls to this API resulted in 403 Forbidden errors due to Cloudflare's bot protection blocking non-browser requests from specific networks.


🚀 Getting Started
Prerequisites
Flutter SDK installed (Version 3.0.0 or higher recommended)
Dart SDK
Installation
Clone the repository:
Bash


git clone https://github.com/yourusername/flutter-user-directory.git
cd flutter-user-directory




Install Dependencies:
Bash


flutter pub get




Generate Hive Adapters:
This project uses code generation for Hive models. You must run this command before running the app:
Bash


dart run build_runner build --delete-conflicting-outputs




Run the App:
Bash


flutter run




📂 Project Structure
The project follows the Clean Architecture principle to ensure separation of concerns and testability.
Plaintext


lib/
├── data/
│    ├── models/
│    ├── repositories/
│   ├── networks/          
├── presentation/
│   ├── controllers/
│   └── pages/           
└── main.dart



🧪 How It Works
Data Fetching:
The UserRepositoryImpl checks for internet connectivity.
If Online: It calls RemoteDataSource to fetch data from the API, saves it to LocalDataSource (Hive), and returns it to the UI.
If Offline: It bypasses the API and retrieves the last cached data from LocalDataSource.
State Management:
UserController manages the list of users, loading states, and pagination logic.
It uses reactive variables (.obs) to automatically update the UI when data changes.
Pagination:
A ScrollController listener in the controller detects when the user reaches the bottom of the list and triggers loadMoreUsers().


