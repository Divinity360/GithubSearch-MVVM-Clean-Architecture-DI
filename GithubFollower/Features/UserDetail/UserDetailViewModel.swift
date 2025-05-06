import Foundation
import Combine

class UserDetailViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isAddedToFavorites: Bool = false
    
    private var username: String
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    init(username: String, 
         networkService: NetworkServiceProtocol,
         persistenceService: PersistenceServiceProtocol) {
        self.username = username
        self.networkService = networkService
        self.persistenceService = persistenceService
        
        getUserInfo()
        checkIfFavorite()
    }
    
    func getUserInfo() {
        isLoading = true
        errorMessage = nil
        
        networkService.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let user):
                    self.user = user
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func addToFavorites() {
        guard let user = user else { return }
        
        let favorite = Follower(login: user.login, id: user.id, avatarUrl: user.avatarUrl, url: user.htmlUrl)
        
        persistenceService.saveFavorite(favorite) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.isAddedToFavorites = true
                }
            }
        }
    }
    
    func removeFromFavorites() {
        guard let user = user else { return }
        
        let favorite = Follower(login: user.login, id: user.id, avatarUrl: user.avatarUrl, url: user.htmlUrl)
        
        persistenceService.removeFavorite(favorite) { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.isAddedToFavorites = false
                }
            }
        }
    }
    
    private func checkIfFavorite() {
        persistenceService.isFavorite(username: username) { [weak self] isFavorite in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isAddedToFavorites = isFavorite
            }
        }
    }
}