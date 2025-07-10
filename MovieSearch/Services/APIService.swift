//
//  API Service.swift
//  MovieSearch
//
//  Created by Badal Aryal on 10/07/2025.
//

import Foundation

// Handles all network requests to the TMDb API.
class APIService {
    // IMPORTANT: Replace with your own TMDb API key.
    private let apiKey = "75a806d10a38810ad4fd3ce4706aa526"
    private let baseURL = "https://api.themoviedb.org/3"

    /// Searches for movies on the TMDb API.
    /// - Parameters:
    ///   - query: The search term.
    ///   - page: The page number for pagination.
    /// - Returns: A `MovieResponse` object containing the search results.
    /// - Throws: An error if the network request or JSON decoding fails.
    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        // Safely construct the URL.
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&page=\(page)") else {
            throw URLError(.badURL)
        }

        // Perform the asynchronous network request.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response into our Codable structs.
        let decoder = JSONDecoder()
        return try decoder.decode(MovieResponse.self, from: data)
    }
}


