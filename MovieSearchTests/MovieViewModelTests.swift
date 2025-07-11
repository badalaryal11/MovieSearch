//
//  MovieViewModelTests.swift
//  MovieSearchTests
//
//  Created by Badal Aryal on 11/07/2025.
//

import XCTest
@testable import MovieSearch

@MainActor
class MovieViewModelTests: XCTestCase {

    var mockCoreDataService: MockCoreDataService!
    var sut: MovieViewModel!

    override func setUpWithError() throws {
        mockCoreDataService = MockCoreDataService()
        // Inject the mock service into the ViewModel
        sut = MovieViewModel(coreDataService: mockCoreDataService)
    }

    override func tearDownWithError() throws {
        mockCoreDataService = nil
        sut = nil
    }

    func testToggleFavorite_AddsMovieToFavorites() {
        // Given
        let movie = Movie(id: 1, title: "Test Movie", overview: "", posterPath: nil, releaseDate: nil)
        sut.favoriteMovies = []
        
        // When
        sut.toggleFavorite(movie: movie)
        
        // Then
        XCTAssertTrue(sut.isFavorite(movie: movie))
        XCTAssertEqual(sut.favoriteMovies.count, 1)
    }
    
    func testToggleFavorite_RemovesMovieFromFavorites() {
        // Given
        let movie = Movie(id: 1, title: "Test Movie", overview: "", posterPath: nil, releaseDate: nil)
        sut.favoriteMovies = [movie]
        
        // When
        sut.toggleFavorite(movie: movie)
        
        // Then
        XCTAssertFalse(sut.isFavorite(movie: movie))
        XCTAssertTrue(sut.favoriteMovies.isEmpty)
    }
}
