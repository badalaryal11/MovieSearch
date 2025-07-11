//
//  MovieSearchUITests.swift
//  MovieSearchUITests
//
//  Created by Badal Aryal on 11/07/2025.
//

import XCTest

class MovieSearchUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Add launch arguments to use mock data or reset state if needed
        app.launch()
    }

    func testSearchFlow_WhenTypingQuery_ShouldDisplayResults() {
        // Given
        let searchBar = app.textFields["searchBar"]
        let movieList = app.tables["movieList"]

        // When
        searchBar.tap()
        searchBar.typeText("Inception\n") // \n simulates pressing the search button

        // Then
        // Wait for the first cell of the list to appear (adjust timeout as needed)
        let firstCell = movieList.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "The movie list should appear with results.")
        XCTAssertTrue(firstCell.staticTexts["Inception"].exists)
    }

    func testFavoritesFlow_WhenTappingFavorite_ShouldAppearInFavoritesList() {
        // Given
        let searchBar = app.textFields["searchBar"]
        let movieList = app.tables["movieList"]
        let favoritesLink = app.buttons["favoritesLink"]

        // When
        // 1. Search for a movie
        searchBar.tap()
        searchBar.typeText("Inception\n")

        // 2. Tap the first movie in the list to go to details
        let firstCell = movieList.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()
        
        // 3. Tap the favorite button on the detail screen
        let favoriteButton = app.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 2))
        favoriteButton.tap()
        
        // 4. Go back to the main list
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // 5. Navigate to the favorites screen
        favoritesLink.tap()

        // Then
        // Check that the movie now exists in the favorites list
        XCTAssertTrue(app.tables.cells.staticTexts["Inception"].exists, "Inception should be in the favorites list.")
    }
}
