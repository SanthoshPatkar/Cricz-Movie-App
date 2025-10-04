//
//  HomeViewModelTests.swift
//  Criczz MovieTests
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import XCTest
import Combine
@testable import Criczz_Movie

final class HomeViewModelTests: XCTestCase {
    var vm: HomeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        vm = HomeViewModel(repo: MockMovieRepositorySuccess())
        cancellables = []
    }

    override func tearDown() {
        vm = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadPopularMoviesSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch popular movies")

        // When
        vm.$movies
            .dropFirst()
            .sink { movies in
                if !movies.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        vm.loadMovies()

        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(vm.movies.count, 2)
        XCTAssertFalse(vm.isLoading)
    }

    func testSearchMovies() {
        let expectation = XCTestExpectation(description: "Search movies")

        vm.$movies
            .dropFirst()
            .sink { movies in
                if !movies.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        vm.search(query: "Inception")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(vm.movies.first?.title, "Inception")
    }
}
