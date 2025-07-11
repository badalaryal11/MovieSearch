//
//  MockCoreDataService.swift
//  MovieSearch
//
//  Created by Badal Aryal on 11/07/2025.
//

import Foundation
@testable import MovieSearch // Import app module

class MockCoreDataService: CoreDataServiceProtocol {
    var favoriteMovies: [Movie] = []
    var cachedMovies: [String: [Movie]] = [:]
    
    func fetchFavorites() -> [Movie] {
        return favoriteMovies
    }
    
    func saveFavorite(movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }
    
    func removeFavorite(movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }
    
    func fetchCachedMovies(for query: String) -> [Movie]? {
        return cachedMovies[query]
    }
    
    func saveMoviesToCache(_ movies: [Movie], for query: String) {
        cachedMovies[query] = movies
    }
}
