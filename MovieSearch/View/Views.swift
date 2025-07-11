//
//  Views.swift
//  MovieSearch
//
//  Created by Badal Aryal on 10/07/2025.
//

import SwiftUI

// The main view of the app, displaying the search bar and list of movies.
struct MovieListView: View {
    // @StateObject ensures the ViewModel is kept alive for the lifecycle of the view.
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery, onSearchButtonClicked: viewModel.searchMovies).accessibilityIdentifier("searchBar")

                
                if viewModel.movies.isEmpty && !viewModel.isLoading {
                    // Show a message when there are no results
                    Text("Search for movies to see results.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    // The list of movies fetched from the API or cache.
                    List(viewModel.movies) { movie in
                        // NavigationLink to go to the detail view for each movie.
                        NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                            MovieRow(movie: movie)
                                .onAppear {
                                    // Trigger pagination when the last visible item is about to appear.
                                    if movie.id == viewModel.movies.last?.id {
                                        viewModel.loadMoreMovies()
                                    }
                                }
                        }
                    }.accessibilityIdentifier("movieList")
                    
                }

                // Show a loading indicator while fetching data.
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .navigationTitle("Movie Search")
            .toolbar {
                // Toolbar button to navigate to the favorites screen.
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        Image(systemName: "heart.fill")
                    }
                    .accessibilityIdentifier("favoritesLink")
                                    
                }
            }
            // Alert to show any errors that occur.
            .alert(isPresented: $viewModel.isShowingErrorAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// A view that represents a single row in the movie list.
struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack {
            // Asynchronously loads and displays the movie poster.
            AsyncImage(url: movie.posterURL) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fill)
            } placeholder: {
                // A placeholder view while the image is loading.
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "film")
                        .foregroundColor(.white)
                }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                Text("Released: \(movie.releaseDate ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }.accessibilityIdentifier("favoriteButton") 
        }
        .padding(.vertical, 4)
    }
}

// A view that displays the list of favorite movies.
struct FavoritesView: View {
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        // Use a ZStack to show a message if the list is empty.
        ZStack {
            if viewModel.favoriteMovies.isEmpty {
                Text("No favorite movies yet.")
                    .foregroundColor(.secondary)
            } else {
                List(viewModel.favoriteMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                        MovieRow(movie: movie)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        // Refresh favorites when the view appears.
        .onAppear(perform: viewModel.loadFavorites)
    }
}

// The new detail screen for a selected movie.
struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Poster
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ZStack {
                        Color.gray.opacity(0.3)
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .frame(height: 500)
                }
                .cornerRadius(12)
                .shadow(radius: 10)

                // Movie Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Release Date: \(movie.releaseDate ?? "Not Available")")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    // Favorite Button
                    Button(action: {
                        viewModel.toggleFavorite(movie: movie)
                    }) {
                        Label(
                            viewModel.isFavorite(movie: movie) ? "Remove from Favorites" : "Add to Favorites",
                            systemImage: viewModel.isFavorite(movie: movie) ? "heart.fill" : "heart"
                        )
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    
                    // Overview
                    Text("Overview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Text(movie.overview)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// A reusable search bar component.
struct SearchBar: View {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void

    var body: some View {
        HStack {
            TextField("Search movies...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit(onSearchButtonClicked) // Allows searching via the return key
            
            Button(action: onSearchButtonClicked) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding([.horizontal, .top])
    }
}

