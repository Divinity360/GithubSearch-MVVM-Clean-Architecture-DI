import Foundation

enum PersistenceError: Error {
    case saveFailed
    case loadFailed
    case deleteFailed
}

protocol PersistenceServiceProtocol {
    func saveFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void)
    func removeFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void)
    func retrieveFavorites(completion: @escaping (Result<[Follower], Error>) -> Void)
    func isFavorite(username: String, completion: @escaping (Bool) -> Void)
}

class PersistenceService: PersistenceServiceProtocol {
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    func saveFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void) {
        retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var favorites):
                guard !favorites.contains(favorite) else {
                    completion(nil) // Already a favorite
                    return
                }
                
                favorites.append(favorite)
                completion(self.save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func removeFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void) {
        retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var favorites):
                favorites.removeAll { $0.login == favorite.login }
                completion(self.save(favorites: favorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func retrieveFavorites(completion: @escaping (Result<[Follower], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(PersistenceError.loadFailed))
        }
    }
    
    func isFavorite(username: String, completion: @escaping (Bool) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                let isFavorite = favorites.contains { $0.login == username }
                completion(isFavorite)
                
            case .failure:
                completion(false)
            }
        }
    }
    
    private func save(favorites: [Follower]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return PersistenceError.saveFailed
        }
    }
}