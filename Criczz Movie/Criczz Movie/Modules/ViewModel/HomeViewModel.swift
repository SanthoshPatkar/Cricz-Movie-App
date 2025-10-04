//
//  HomeViewModel.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var runtimes: [Int: Int] = [:]
    @Published var searchText = ""
    @Published var isLoading = false
    
    let repo: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repo: MovieRepositoryProtocol) {
        self.repo = repo
        bindSearch()
    }
    
    func loadMovies() {
        if movies.isEmpty {
            loadPopular()
        }
    }
    
    func loadDefaultPopularMovies() {
        loadPopular()
    }
    
    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] q in
                guard let self = self else { return }
                if !(q.isEmpty) {
                    self.search(query: q)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadPopular() {
        guard !isLoading else {
            return
        }
        isLoading = true
        movies = []
        repo.fetchPopular()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in self?.isLoading = false }, receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.fetchRuntimes(for: movies)
            })
            .store(in: &cancellables)
    }
    
    private func fetchRuntimes(for movies: [Movie]) {
        for m in movies where runtimes[m.id] == nil {
            repo.fetchDetail(id: m.id)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] detail in
                    self?.runtimes[m.id] = detail.runtime ?? 0
                })
                .store(in: &cancellables)
        }
    }
    
    func search(query: String) {
        isLoading = true
        repo.searchMovies(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] _ in self?.isLoading = false }, receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.fetchRuntimes(for: movies)
            })
            .store(in: &cancellables)
    }
}
