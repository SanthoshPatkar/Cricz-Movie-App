//
//  Movie Service.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import Combine

// MARK: - PROTOCOLS
protocol MovieRepositoryProtocol {
    func fetchPopular() -> AnyPublisher<[Movie], Error>
    func searchMovies(query: String) -> AnyPublisher<[Movie], Error>
    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error>
    func fetchVideos(id: Int) -> AnyPublisher<[Video], Error>
    func fetchCast(id: Int) -> AnyPublisher<[CastMember], Error>
}


// MARK: - SERVICES
final class MovieService: MovieRepositoryProtocol {
    
    private let network: NetworkManager
    
    init(network: NetworkManager = .shared) {
        self.network = network
    }
    func fetchPopular() -> AnyPublisher<[Movie], Error> {
        network.request(path: "/movie/popular", type: MovieResponse.self).map { $0.results }.eraseToAnyPublisher()
    }
    
    
    func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
        network.request(path: "/search/movie", queryItems: [URLQueryItem(name: "query", value: query)], type: MovieResponse.self).map { $0.results }.eraseToAnyPublisher()
    }
    
    
    func fetchDetail(id: Int) -> AnyPublisher<MovieDetail, Error> {
        network.request(path: "/movie/\(id)", type: MovieDetail.self)
    }
    
    
    func fetchVideos(id: Int) -> AnyPublisher<[Video], Error> {
        network.request(path: "/movie/\(id)/videos", type: VideoListResponse.self).map { $0.results }.eraseToAnyPublisher()
    }
    
    
    func fetchCast(id: Int) -> AnyPublisher<[CastMember], Error> {
        network.request(path: "/movie/\(id)/credits", type: CastResponse.self).map { $0.cast }.eraseToAnyPublisher()
    }
    
}
