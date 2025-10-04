//
//  MovieDetailViewModel.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published var detail: MovieDetail?
    @Published var videos: [Video] = []
    @Published var cast: [CastMember] = []
    @Published var isLoading = false
    
    private let repo: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repo: MovieRepositoryProtocol) {
        self.repo = repo
    }
    
    func load(id: Int) {
        fetchDetails(id: id)
        fetchCast(id: id)
        fetchVideos(id: id)
    }
    
    private func fetchDetails(id: Int) {
        isLoading = true
        repo.fetchDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in self?.isLoading = false }, receiveValue: { [weak self] detail in
                self?.detail = detail
            })
            .store(in: &cancellables)
    }
    
    private func fetchVideos(id: Int) {
        repo.fetchVideos(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] videos in
                self?.videos = videos
            })
            .store(in: &cancellables)
    }
    
    private func fetchCast(id: Int) {
        repo.fetchCast(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] cast in
                self?.cast = Array(cast.prefix(10))
            })
            .store(in: &cancellables)
    }
    
    func getTrailerURL() -> URL? {
        if let key = videos.first(where: { $0.site == "YouTube" && $0.type == "Trailer" })?.key {
            return  URL(string: "https://www.youtube.com/watch?v=\(key)")
        }
        return nil
    }
}
