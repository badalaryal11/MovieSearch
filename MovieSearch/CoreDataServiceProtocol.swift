//
//  CoreDataServiceProtocol.swift
//  MovieSearch
//
//  Created by Badal Aryal on 11/07/2025.
//


import Foundation

protocol CoreDataServiceProtocol {
    func fetchFavorites() -> [Movie]
    func saveFavorite(movie: Movie)
    func removeFavorite(movie: Movie)
    func fetchCachedMovies(for query: String) -> [Movie]?
    func saveMoviesToCache(_ movies: [Movie], for query: String)
}
