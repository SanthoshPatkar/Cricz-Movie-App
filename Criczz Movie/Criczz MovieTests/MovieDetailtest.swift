//
//  MovieDetailtest.swift
//  Criczz MovieTests
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import XCTest
import Combine
@testable import Criczz_Movie

final class MovieDetailViewModelTests: XCTestCase {
    var vm: MovieDetailViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        vm = MovieDetailViewModel(repo: MockMovieRepositorySuccess())
        cancellables = []
    }

    override func tearDown() {
        vm = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadDetailDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch movie details")

        vm.$detail
            .dropFirst()
            .sink { detail in
                if detail != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        vm.load(id: 1)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(vm.detail?.title, "Inception")
        XCTAssertEqual(vm.videos.first?.key, "abcd1234")
        XCTAssertEqual(vm.cast.first?.name, "Leonardo DiCaprio")
    }

    func testGetTrailerURL() {
        vm.videos = MockMovieData.sampleVideos
        let url = vm.getTrailerURL()
        XCTAssertEqual(url?.absoluteString, "https://www.youtube.com/watch?v=abcd1234")
    }
}
