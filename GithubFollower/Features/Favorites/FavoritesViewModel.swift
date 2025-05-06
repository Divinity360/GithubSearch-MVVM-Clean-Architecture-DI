import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Follower] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
        getFavorites()
    }
    
    func getFavorites() {
        isLoading = true
        errorMessage = nil
        
        persistenceService.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let favorites):
                    self.favorites = favorites
                    
                    if favorites.isEmpty {
                        self.errorMessage = "No favorites yet. Add one on the follower screen."
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func removeFavorite(at indexSet: IndexSet) {
        for index in indexSet {
            let favorite = favorites[index]
            
            persistenceService.removeFavorite(favorite) { [weak self] error in
                guard let self = self else { return }
                
                // Refresh favorites list
                if error == nil {
                    DispatchQueue.main.async {
                        self.favorites.remove(at: index)
                        
                        if self.favorites.isEmpty {
                            self.errorMessage = "No favorites yet. Add one on the follower screen."
                        }
                    }
                }
            }
        }
    }
}