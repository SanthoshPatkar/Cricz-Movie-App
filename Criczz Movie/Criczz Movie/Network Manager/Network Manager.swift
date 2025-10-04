//
//  Network Manager.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        var comps = URLComponents(string: TMDB.baseURL + path)!
        comps.queryItems = [URLQueryItem(name: "api_key", value: TMDB.apiKey)] + queryItems
        
        guard let url = comps.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard
                    let http = response as? HTTPURLResponse,
                    200..<300 ~= http.statusCode
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

