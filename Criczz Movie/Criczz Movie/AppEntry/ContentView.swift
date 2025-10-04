//
//  ContentView.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI


struct ContentView: View {
    let dependencies: AppDependencies
    @StateObject private var viewModel: HomeViewModel
    
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: HomeViewModel(repo: dependencies.movieRepository))
    }
    
    var body: some View {
        NavigationView {
            HomeView(viewModel: viewModel)
                .environmentObject(dependencies.favoritesManager)
                .navigationTitle("Movies")
        }
    }
}


#Preview {
    ContentView(dependencies: AppDependencies(movieRepository: MovieService(), favoritesManager: FavoritesManager()))
}
