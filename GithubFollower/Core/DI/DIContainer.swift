import Foundation
import SwiftUI

// Main dependency injection container
class DIContainer: ObservableObject {
    // Services
    let networkService: NetworkServiceProtocol
    let persistenceService: PersistenceServiceProtocol
    
    // Factory for ViewModels
    let viewModelFactory: ViewModelFactory
    
    // Singleton for app-wide access
    static let shared = DIContainer()
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        self.viewModelFactory = ViewModelFactory(networkService: networkService, persistenceService: persistenceService)
    }
}

// Factory for creating ViewModels with dependencies
class ViewModelFactory {
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    init(networkService: NetworkServiceProtocol, persistenceService: PersistenceServiceProtocol) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel()
    }
    
    func makeFollowerListViewModel(username: String) -> FollowerListViewModel {
        return FollowerListViewModel(username: username, networkService: networkService)
    }
    
    func makeUserDetailViewModel(username: String) -> UserDetailViewModel {
        return UserDetailViewModel(username: username, networkService: networkService, persistenceService: persistenceService)
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        return FavoritesViewModel(persistenceService: persistenceService)
    }
}

// Environment key for injecting the container
struct DIContainerKey: EnvironmentKey {
    static let defaultValue = DIContainer.shared
}

// Environment value extension for easy access in views
extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}

// View extension to inject DI container
extension View {
    func withDIContainer(_ container: DIContainer) -> some View {
        self.environment(\.diContainer, container)
    }
}