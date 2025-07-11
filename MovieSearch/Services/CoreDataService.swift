//
//  CoreDataService.swift
//  MovieSearch
//
//  Created by Badal Aryal on 10/07/2025.
//

import CoreData
import Foundation

// A singleton class to manage all Core Data operations for caching and favorites.
class CoreDataService: CoreDataServiceProtocol {
    // initializer for testing 
    init(inMemory: Bool = false) {
           persistentContainer = NSPersistentContainer(name: "MovieAppCache")
           
           if inMemory {
               // Use an in-memory store for unit tests to keep them isolated and fast.
               let description = NSPersistentStoreDescription()
               description.url = URL(fileURLWithPath: "/dev/null")
               persistentContainer.persistentStoreDescriptions = [description]
           }
           
           persistentContainer.loadPersistentStores { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           }
           persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
       }
    static let shared = CoreDataService()
    let persistentContainer: NSPersistentContainer
    
    // Cache will be considered expired after this many seconds (e.g., 1 hour)
    private let cacheExpiration: TimeInterval = 3600

    private init() {
        // The name "MovieAppCache" must match your .xcdatamodeld file name.
        persistentContainer = NSPersistentContainer(name: "MovieAppCache")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        // Merge policies ensure that new data overwrites old data smoothly.
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Favorite Movies
    
    func saveFavorite(movie: Movie) {
        let context = persistentContainer.viewContext
        let favorite = FavoriteMovie(context: context) // error:
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.overview = movie.overview
        favorite.posterPath = movie.posterPath
        favorite.releaseDate = movie.releaseDate
        saveContext()
    }

    func removeFavorite(movie: Movie) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let favoriteToRemove = results.first {
                context.delete(favoriteToRemove)
                saveContext()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }

    func fetchFavorites() -> [Movie] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toMovie() }
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
    
    // MARK: - Search Cache
    
    /// Saves a list of movies to the cache for a specific search query.
    func saveMoviesToCache(_ movies: [Movie], for query: String) {
        let context = persistentContainer.viewContext
        
        // Find existing cache or create a new one
        let fetchRequest: NSFetchRequest<SearchQueryCache> = SearchQueryCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "term ==[c] %@", query)
        
        let queryCache: SearchQueryCache
        if let existingCache = try? context.fetch(fetchRequest).first {
            queryCache = existingCache
            // Clear old results before adding new ones
            if let oldResults = queryCache.results as? Set<CachedMovie> {
                for movie in oldResults {
                    context.delete(movie)
                }
            }
        } else {
            queryCache = SearchQueryCache(context: context)
            queryCache.term = query
        }
        
        queryCache.timestamp = Date()
        
        // Add the new results
        for movie in movies {
            let cachedMovie = CachedMovie(context: context)
            cachedMovie.id = Int64(movie.id)
            cachedMovie.title = movie.title
            cachedMovie.overview = movie.overview
            cachedMovie.posterPath = movie.posterPath
            cachedMovie.releaseDate = movie.releaseDate
            queryCache.addToResults(cachedMovie)
        }
        
        saveContext()
    }

    /// Fetches cached movies for a specific search query.
    /// Returns nil if the cache is expired or doesn't exist.
    func fetchCachedMovies(for query: String) -> [Movie]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SearchQueryCache> = SearchQueryCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "term ==[c] %@", query)

        do {
            guard let queryCache = try context.fetch(fetchRequest).first,
                  let timestamp = queryCache.timestamp,
                  Date().timeIntervalSince(timestamp) < cacheExpiration else {
                // Cache doesn't exist or is expired
                return nil
            }
            
            if let cachedResults = queryCache.results as? Set<CachedMovie> {
                // Sort results to maintain a consistent order
                return cachedResults.map { $0.toMovie() }.sorted { $0.title < $1.title }
            }
        } catch {
            print("Failed to fetch cached movies: \(error)")
        }
        
        return nil
    }

    // MARK: - Context Saving
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - NSManagedObject Extensions
// Helper extensions to convert Core Data objects to our app's Model struct.

extension FavoriteMovie {
    func toMovie() -> Movie {
        Movie(id: Int(self.id),
              title: self.title ?? "",
              overview: self.overview ?? "",
              posterPath: self.posterPath,
              releaseDate: self.releaseDate,
              isFavorite: true)
    }
}

extension CachedMovie {
    func toMovie() -> Movie {
        Movie(id: Int(self.id),
              title: self.title ?? "",
              overview: self.overview ?? "",
              posterPath: self.posterPath,
              releaseDate: self.releaseDate)
    }
}
