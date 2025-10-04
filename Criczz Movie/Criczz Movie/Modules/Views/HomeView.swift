//
//  HomeView.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var favs: FavoritesManager
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search movies...", text: $viewModel.searchText)
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    )
                    .padding(.horizontal, 8)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.loadDefaultPopularMovies()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.searchText)
                }
            }
            .padding(.horizontal)
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.movies.isEmpty {
                Text("Opps! No movie Found")
                    .font(.headline)
                Text("Check internet or try diffrent text")
                
            } else {
                List(viewModel.movies.indices, id: \.self) { index in
                    let movie = viewModel.movies[index]
                    NavigationLink(
                        destination: MovieDetailView(movieID: movie.id, repo: viewModel.repo)
                            .environmentObject(favs)
                    ) {
                        MovieRowView(movie: movie, runtime: viewModel.runtimes[movie.id])
                            .onAppear {
                                if index == viewModel.movies.count - 3 {
                                    viewModel.loadMovies()
                                }
                            }
                    }
                }
                .listStyle(.plain)
            }
            Spacer()
        }.onAppear {
            viewModel.loadMovies()
        }
    }
}


#Preview {
    HomeView(viewModel: HomeViewModel(repo: MovieService()))
        .environmentObject(FavoritesManager())
}
