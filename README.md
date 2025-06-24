# Flutter Task

This is a Flutter project that demonstrates user authentication and real-time location tracking.

## Features

- User registration and login
- Fetches user's current location
- Displays latitude and longitude
- Updates location every 5 seconds
- Persists the last known location locally

## How it Works

The application has two main screens:

1.  **Authentication Page**: A simple form for users to either register or log in. It uses a free API (`https://api.freeapi.app/api/v1/`) for authentication.
2.  **Home Page**: After successful authentication, the user is navigated to this page. It requests location permission and displays the user's current latitude and longitude. The location is updated every 5 seconds and also stored in the device's shared preferences.

## Project Structure

The project is structured as follows:

```
lib
├── authentication_page
│   └── auth_page.dart
├── home_page
│   └── home_page.dart
├── services
│   └── dio_client.dart
└── main.dart
```

-   `main.dart`: The entry point of the application.
-   `authentication_page`: Contains the UI for the login/registration screen.
-   `home_page`: Contains the UI for the home screen, which displays the location.
-   `services`: Contains the `DioClient` class for handling API requests.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

-   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
-   An editor like Android Studio or VS Code with the Flutter plugin.

### Installation

1.  Clone the repo
    ```sh
    git clone https://github.com/ajay007-web/flutter_task.git
    ```
2.  Install packages
    ```sh
    flutter pub get
    ```
3.  Run the app
    ```sh
    flutter run
    ```
