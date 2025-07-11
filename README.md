TMDb Movie Search iOS App
This is a modern iOS application built with SwiftUI that allows users to search for movies using The Movie Database (TMDb) API. It demonstrates best practices in iOS development, including the MVVM architecture, offline caching with Core Data, and a comprehensive suite of unit and UI tests.
 
 Github URL: https://github.com/badalaryal11/MovieSearch.git
 
Features
1. Movie Search: Search for movies by title using the TMDb API.

2. Pagination: Infinite scrolling to seamlessly load more movie results.

3. Offline Caching: Search results are cached locally, allowing for offline access to previously viewed movies.

4. Favorites List: Users can mark movies as favorites and view them in a dedicated list.

5. Movie Details: Tap on any movie to view more detailed information, including its overview and poster.

6. MVVM Architecture: A clean and scalable architecture that separates UI, business logic, and data models.

7. Unit & UI Testing: A complete testing suite to ensure code quality and application stability.

Prerequisites

1. macOS with Xcode 14.0 or later

2. Swift 5.7 or later

3. An active internet connection for initial movie searches.

Getting Started
To build and run this application, you will first need to obtain a free API key from The Movie Database.

1. Obtain a TMDb API Key

    * Go to themoviedb.org and create a free account.

    * Once logged in, navigate to your account Settings.

    * In the left sidebar, click on the API section.

    * Under the "Request an API Key" section, click to apply for a developer key.

    * Fill out the required information. For the application URL, you can use a placeholder like https://myapp.com.

    * Once approved, you will be provided with an API Key (v3 auth). Copy this key.

2. Configure the API Key in the Project
    * You must add your API key to the project for it to be able to communicate with the TMDb service.

    * Open the Xcode project.

    * Navigate to the Services/APIService.swift file.

    * Find the following line of code:

    * private let apiKey = "" // Replace with your TMDb API key

    * Paste your TMDb API key inside the quotes. The line should now look like this:

    * private let apiKey = "YOUR_COPIED_API_KEY_HERE"

3. Build and Run the Application
    * Once the API key is configured, you can run the app.

    * Select a target simulator (e.g., iPhone 14 Pro) or a connected physical device from the scheme menu at the top of the Xcode window.

    * Press the Run button (the play icon) or use the shortcut Cmd+R.

    * The app will build and launch on your selected device or simulator.

Project Structure
The project is organized into logical groups based on the MVVM architecture to promote separation of concerns.

MovieSearch/
    ├── MovieSearchApp.swift   // Main application entry point
│

├── Model/
    │   └── Model.swift        // Data structures (Movie, MovieResponse)
│

├── View/
    │   └── Views.swift        // All SwiftUI views (MovieListView, MovieDetailView, etc.)
    │

├── ViewModel/
    │   └── MovieViewModel.swift // The brain of the views, handles state and logic
    │

├── Services/
    │   ├── APIService.swift     // Handles network requests to TMDb
    │   └── CoreDataService.swift// Manages all Core Data operations

└── DataModel/
        └── MovieAppCache.xcdatamodeld // The Core Data model file

Running Tests
    
    * The project includes a full suite of tests to validate its functionality.

    * To run all tests, press Cmd+U or go to Product > Test in the Xcode menu.

    * You can also run specific test suites by opening the Test Navigator (the diamond icon in the left-hand sidebar) and clicking the play button next to a specific test file or individual test function.

    *    Unit Tests (MovieSearchTests): These tests validate the logic of the MovieViewModel and CoreDataService in isolation. They use mock objects and an in-memory database to run quickly and reliably.

    * UI Tests (MovieSearchUITests): These tests launch the full application and simulate user interactions to verify that the UI behaves as expected.
