//
//  MovieDetailView.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    @EnvironmentObject var favs: FavoritesManager
    let movieID: Int
    @State private var showPlayer = false
    
    
    init(movieID: Int, repo: MovieRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(repo: repo))
        self.movieID = movieID
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let poster = viewModel.detail?.posterURL {
                    AsyncImageView(url: poster, loader: AsyncImageLoader())
                        .frame(width: UIScreen.main.bounds.width - 32)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(10)
                        .overlay(
                            ZStack {
                                if viewModel.videos.count != 0 {
                                    if let url = viewModel.getTrailerURL() {
                                        NavigationLink {
                                            TrailerPlayerView(url: url)
                                        } label: {
                                            Image(systemName: "play.circle.fill")
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        )
                }
                HStack {
                    Text(viewModel.detail?.title ?? "--").font(.title).bold()
                    Spacer()
                    Button { favs.toggle(movieID) } label: {
                        Image(systemName: favs.isFavorite(movieID) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
                if let rating = viewModel.detail?.vote_average {
                    Text("Rating: \(rating, specifier: "%.1f")")
                }
                if let runtime = viewModel.detail?.runtime {
                    Text("Duration: \(runtime) min")
                }
                if let genres = viewModel.detail?.genres {
                    Text("Genres: " + genres.map { $0.name }.joined(separator: ", "))
                }
                if let overview = viewModel.detail?.overview {
                    Text(overview)
                }
                
                if !viewModel.cast.isEmpty {
                    Text("Cast")
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.cast) { member in
                                VStack(spacing: 8) {
                                    if let p = member.profile_path, let url = URL(string: TMDB.imageBase + p) {
                                        AsyncImageView(url: url, loader: AsyncImageLoader())
                                            .frame(width: 80, height: 100)
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                    
                                    Text(member.name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                    
                                    Text(member.character)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(width: 110, height: 160)
                                .padding(8)
                                .background(
                                    LinearGradient(colors: [Color(.systemGray6), Color(.systemGray4)], startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear { viewModel.load(id: movieID) }
    }
}

#Preview {
    MovieDetailView(movieID: 99, repo: MovieService())
        .environmentObject(FavoritesManager())
}
