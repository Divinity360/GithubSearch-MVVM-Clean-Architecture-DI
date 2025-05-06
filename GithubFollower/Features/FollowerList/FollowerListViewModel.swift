import Foundation
import Combine

class FollowerListViewModel: ObservableObject {
    @Published var followers: [Follower] = []
    @Published var filteredFollowers: [Follower] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    
    private var page = 1
    private var hasMoreFollowers = true
    private(set) var username: String
    private var cancellables = Set<AnyCancellable>()
    
    // Injected service
    private let networkService: NetworkServiceProtocol
    
    init(username: String, networkService: NetworkServiceProtocol) {
        self.username = username
        self.networkService = networkService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filterFollowers(with: text)
            }
            .store(in: &cancellables)
        
        getFollowers()
    }
    
    func getFollowers() {
        guard hasMoreFollowers else { return }
        
        isLoading = true
        errorMessage = nil
        
        networkService.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let newFollowers):
                    if newFollowers.count < 100 { 
                        self.hasMoreFollowers = false 
                    }
                    self.followers.append(contentsOf: newFollowers)
                    self.filteredFollowers = self.followers
                    
                    if self.followers.isEmpty {
                        self.errorMessage = "This user doesn't have any followers."
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        
        page += 1
    }
    
    func loadMoreFollowersIfNeeded(currentFollower follower: Follower) {
        let thresholdIndex = followers.index(followers.endIndex, offsetBy: -5)
        if followers.firstIndex(where: { $0.id == follower.id }) == thresholdIndex {
            getFollowers()
        }
    }
    
    private func filterFollowers(with searchText: String) {
        if searchText.isEmpty {
            filteredFollowers = followers
        } else {
            filteredFollowers = followers.filter {
                $0.login.lowercased().contains(searchText.lowercased())
            }
        }
    }
}