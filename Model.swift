//
//  Model.swift
//  MovieSearch
//
//  Created by Badal Aryal on 10/07/2025.
//

import Foundation

// Represents the overall response from the TMDb API search endpoint.
struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// Represents a single movie object.
// It's Identifiable to be used in SwiftUI Lists and Codable for JSON parsing.
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    var isFavorite: Bool = false // Used to track favorite status in the UI

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }

    // Computed property to construct the full URL for the movie's poster image.
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

