//
//  MovieViewModel.swift
//  MovieSearch
//
//  Created by Badal Aryal on 10/07/2025.
//

import Foundation
import Combine

@MainActor
class MovieViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var movies: [Movie] = []
    @Published var favoriteMovies: [Movie] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    
    // Properties for error handling - These were missing
    @Published var isShowingErrorAlert: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var currentPage = 1
    private var totalPages = 1
    private let apiService = APIService()
    private let coreDataService = CoreDataService.shared

    init() {
        loadFavorites()
    }

    // MARK: - Public Methods
    
    func searchMovies() {
        guard !searchQuery.isEmpty else { return }
        currentPage = 1
        movies = []
        fetchMovies(isNewSearch: true)
    }

    func loadMoreMovies() {
        guard !isLoading, currentPage < totalPages else { return }
        currentPage += 1
        fetchMovies(isNewSearch: false)
    }

    /// Toggles the favorite status of a movie.
    func toggleFavorite(movie: Movie) {
        if isFavorite(movie: movie) {
            coreDataService.removeFavorite(movie: movie)
        } else {
            coreDataService.saveFavorite(movie: movie)
        }
        // Reload favorites to update the UI state.
        loadFavorites()
    }
    
    /// Checks if a movie is in the favorites list - This was missing
    func isFavorite(movie: Movie) -> Bool {
        favoriteMovies.contains(where: { $0.id == movie.id })
    }
    
    /// Loads the list of favorite movies from Core Data - This was private, now it's accessible
    func loadFavorites() {
        favoriteMovies = coreDataService.fetchFavorites()
    }

    // MARK: - Private Helper Methods

    private func fetchMovies(isNewSearch: Bool) {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // For new searches, first try to load from cache.
        if isNewSearch {
            if let cachedMovies = coreDataService.fetchCachedMovies(for: query) {
                self.movies = cachedMovies
                self.totalPages = 1
                self.currentPage = 1
                return
            }
        }
        
        isLoading = true
        Task {
            do {
                let response = try await apiService.searchMovies(query: query, page: currentPage)
                
                if isNewSearch {
                    self.movies = response.results
                    coreDataService.saveMoviesToCache(response.results, for: query)
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                
                self.totalPages = response.totalPages
                
            } catch {
                // Set error properties to trigger the alert in the view.
                self.errorMessage = error.localizedDescription
                self.isShowingErrorAlert = true
            }
            isLoading = false
        }
    }
}
