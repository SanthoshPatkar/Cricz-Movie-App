# Cricz-Movie-App
A SwiftUI-based iOS app that displays popular movies, allows users to search for titles, view detailed information, and manage a list of favorite movies.  
The app integrates **The Movie Database (TMDb) API** and uses **Core Data** for local persistence of favorites.

# Build and Run

Open MovieApp.xcodeproj (Api key already set up).

Select an iOS simulator.

Press ⌘ + R to build and run.

# Features
Popular Movies List

Search movies by title

Displays detailed info including overview, rating, and poster.

Option to open a trailer or play a preview (if available).

Users can add or remove a movie from favorites.

Persisted locally using Core Data.

image cache is handled using NSCache.

Unit test is written for all the case.

# Assumptions and  Known Limitations

TMDb API key is valid

Internet connectivity is available for fetching movie data.

Core Data stack is only configured for favorites

No pagination — only a single page of results fetched.

Error handling is minimal
