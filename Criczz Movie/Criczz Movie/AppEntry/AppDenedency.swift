//
//  AppDenedency.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation

struct AppDependencies {
    let movieRepository: MovieRepositoryProtocol
    let favoritesManager: FavoritesManager
    
    
    static func live() -> AppDependencies {
        AppDependencies(movieRepository: MovieService(), favoritesManager: FavoritesManager())
    }
}
