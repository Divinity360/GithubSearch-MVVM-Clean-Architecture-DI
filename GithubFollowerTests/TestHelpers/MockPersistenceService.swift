import Foundation
@testable import GithubFollower

class MockPersistenceService: PersistenceServiceProtocol {
    var shouldSucceed = true
    var mockFavorites = TestData.mockFollowers
    var isFavoriteValue = false
    
    var saveFavoriteWasCalled = false
    var removeFavoriteWasCalled = false
    var retrieveFavoritesWasCalled = false
    var isFavoriteWasCalled = false
    
    var lastFavorite: Follower?
    var lastUsername: String?
    
    func saveFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void) {
        saveFavoriteWasCalled = true
        lastFavorite = favorite
        
        if shouldSucceed {
            completion(nil)
        } else {
            completion(PersistenceError.saveFailed)
        }
    }
    
    func removeFavorite(_ favorite: Follower, completion: @escaping (Error?) -> Void) {
        removeFavoriteWasCalled = true
        lastFavorite = favorite
        
        if shouldSucceed {
            completion(nil)
        } else {
            completion(PersistenceError.deleteFailed)
        }
    }
    
    func retrieveFavorites(completion: @escaping (Result<[Follower], Error>) -> Void) {
        retrieveFavoritesWasCalled = true
        
        if shouldSucceed {
            completion(.success(mockFavorites))
        } else {
            completion(.failure(PersistenceError.loadFailed))
        }
    }
    
    func isFavorite(username: String, completion: @escaping (Bool) -> Void) {
        isFavoriteWasCalled = true
        lastUsername = username
        completion(isFavoriteValue)
    }
}