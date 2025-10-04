//
//  Movie Details.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation

enum TMDB {
    static let apiKey = "0c27474a6db85f6db99f975ff3e91a31"
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBase = "https://image.tmdb.org/t/p/w500"
}


// MARK: - MODELS
struct Movie: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let release_date: String?
    
    
    var posterURL: URL? { guard let p = poster_path else { return nil }; return URL(string: TMDB.imageBase + p) }
}


struct MovieResponse: Codable { let page: Int; let results: [Movie] }


struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let genres: [Genre]
    let runtime: Int?
    let vote_average: Double?
    let release_date: String?
    var posterURL: URL? { guard let p = poster_path else { return nil }; return URL(string: TMDB.imageBase + p) }
}


struct Genre: Codable {
    let id: Int
    let name: String
}

struct VideoListResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}

struct CastResponse: Codable {
    let cast: [CastMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
}
