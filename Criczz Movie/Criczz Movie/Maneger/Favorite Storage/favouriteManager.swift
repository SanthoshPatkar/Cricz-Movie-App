//
//  favouriteManager.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI
import CoreData

final class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: Set<Int> = []
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
        loadFavorites()
    }

    func isFavorite(_ id: Int) -> Bool {
        favorites.contains(id)
    }

    func toggle(_ id: Int, title: String? = nil, posterPath: String? = nil) {
        if isFavorite(id) {
            remove(id)
        } else {
            add(id, title: title, posterPath: posterPath)
        }
    }

    private func add(_ id: Int, title: String?, posterPath: String?) {
        let favorite = FavoriteMovie(context: container.viewContext)
        favorite.id = Int64(id)
        favorite.title = title
        favorite.posterPath = posterPath
        saveContext()
        favorites.insert(id)
    }

    private func remove(_ id: Int) {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        if let results = try? container.viewContext.fetch(request) {
            results.forEach { container.viewContext.delete($0) }
            saveContext()
            favorites.remove(id)
        }
    }

    private func loadFavorites() {
        let request: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        if let results = try? container.viewContext.fetch(request) {
            favorites = Set(results.map { Int($0.id) })
        }
    }

    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
}
