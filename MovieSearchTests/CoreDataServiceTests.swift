//
//  CoreDataServiceTests.swift .swift
//  MovieSearch
//
//  Created by Badal Aryal on 11/07/2025.
//

import XCTest
@testable import MovieSearch

class CoreDataServiceTests: XCTestCase {

    var sut: CoreDataService!

    override func setUpWithError() throws {
        // Use the in-memory store for each test to ensure a clean state
        sut = CoreDataService(inMemory: true)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSaveAndFetchFavorite() {
        // Given
        let movie = Movie(id: 1, title: "Test Movie", overview: "", posterPath: nil, releaseDate: nil)
        
        // When
        sut.saveFavorite(movie: movie)
        let favorites = sut.fetchFavorites()
        
        // Then
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.id, movie.id)
    }

    func testRemoveFavorite() {
        // Given
        let movie = Movie(id: 1, title: "Test Movie", overview: "", posterPath: nil, releaseDate: nil)
        sut.saveFavorite(movie: movie)
        
        // When
        sut.removeFavorite(movie: movie)
        let favorites = sut.fetchFavorites()
        
        // Then
        XCTAssertTrue(favorites.isEmpty)
    }
    
    func testSaveAndFetchCache() {
        // Given
        let query = "test"
        let movies = [Movie(id: 1, title: "Cached Movie", overview: "", posterPath: nil, releaseDate: nil)]
        
        // When
        sut.saveMoviesToCache(movies, for: query)
        let cached = sut.fetchCachedMovies(for: query)
        
        // Then
        XCTAssertNotNil(cached)
        XCTAssertEqual(cached?.count, 1)
        XCTAssertEqual(cached?.first?.title, "Cached Movie")
    }
}

