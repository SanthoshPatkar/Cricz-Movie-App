//
//  MovieRowView.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    let runtime: Int?
    @EnvironmentObject var favs: FavoritesManager
    
    
    var body: some View {
        HStack {
            AsyncImageView(url: movie.posterURL, loader: AsyncImageLoader())
                .frame(width: 80, height: 120)
                .cornerRadius(6)
            
            
            VStack(alignment: .leading) {
                Text(movie.title).font(.headline)
                if let runtime = runtime, runtime > 0 {
                    Text(formatMinutes(runtime))
                        .font(.subheadline)
                }
                Spacer()
                HStack {
                    Text(String(format: "⭐️ %.1f", movie.vote_average ?? 0)).font(.subheadline)
                }
                
            }
            .padding(.vertical)
            Spacer()
            Button {
                favs.toggle(movie.id)
            } label: {
                Image(systemName: favs.isFavorite(movie.id) ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
    }
    
    private func formatMinutes(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return minutes > 0 ? "\(hours) hr \(minutes)min" : "\(hours) hr"
        } else {
            return "\(minutes)min"
        }
    }
}

#Preview {
    MovieRowView(movie: Movie(id: 1,
                              title: "Avenger End Game",
                              overview: "Conculsion of Avernger story",
                              poster_path: "path//",
                              vote_average: 8.9,
                              release_date: "28 April 2019"),
                 runtime: 120)
    .frame(height: 100)
    .padding()
    .environmentObject(FavoritesManager())
}
