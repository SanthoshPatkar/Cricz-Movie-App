//
//  Servicerepository.swift
//  Criczz MovieTests
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Testing
@testable import Criczz_Movie
import Combine
import Foundation

struct MockMovieData {
    static let sampleMovies: [Movie] = [
        Movie(id: 1, title: "Inception", overview: "Its'a decent movie", poster_path: "/poster2.jpg",  vote_average: 8.8, release_date: "25 April"),
        Movie(id: 2, title: "Avatar", overview: "Its'a decent movie", poster_path: "/poster2.jpg", vote_average: 7.9, release_date: "10 April")
    ]
    
    static let sampleDetail = MovieDetail(id: 1, title: "Inception", overview: "Dream heist", poster_path: "/poster2.jpg", genres: [Genre(id: 1, name: "Drama")], runtime: 110, vote_average: 200, release_date: "10 April")
    static let sampleVideos = [Video(id: "v1", key: "abcd1234", name: "Official Trailer", site: "YouTube", type: "Trailer")]
    static let sampleCast = [CastMember(id: 1, name: "Leonardo DiCaprio", character: "Cobb", profile_path: "/leo.jpg")]
}

final class MockMovieRepositorySuccess: MovieRepositoryProtocol {
    func fetchPopular() -> AnyPublisher<[Movie], Error> {
        Just(MockMovieData.sampleMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        Just(MockMovieData.sampleDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchVideos(id: Int) -> AnyPublisher<[Video], Error> {
        Just(MockMovieData.sampleVideos)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchCast(id: Int) -> AnyPublisher<[CastMember], Error> {
        Just(MockMovieData.sampleCast)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
        Just(MockMovieData.sampleMovies.filter { $0.title.lowercased().contains(query.lowercased()) })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockMovieRepositoryFailure: MovieRepositoryProtocol {
    func fetchPopular() -> AnyPublisher<[Movie], Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    func fetchVideos(id: Int) -> AnyPublisher<[Video], Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    func fetchCast(id: Int) -> AnyPublisher<[CastMember], Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
        Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
