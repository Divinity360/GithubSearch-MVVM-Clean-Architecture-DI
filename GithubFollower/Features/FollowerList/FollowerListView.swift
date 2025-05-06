import SwiftUI

struct FollowerListView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: FollowerListViewModel
    @State private var showUserDetails = false
    @State private var selectedFollower: Follower?
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.viewModelFactory.makeFollowerListViewModel(username: username))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading && viewModel.followers.isEmpty {
                ProgressView()
                    .scaleEffect(2.0)
            } else if let errorMessage = viewModel.errorMessage, viewModel.followers.isEmpty {
                GFEmptyStateView(message: errorMessage)
            } else {
                followersList
            }
        }
        .navigationTitle(viewModel.username)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Search for a username")
        .background(
            NavigationLink(
                destination: UserDetailView(username: selectedFollower?.login ?? ""),
                isActive: $showUserDetails
            ) {
                EmptyView()
            }
        )
    }
    
    private var followersList: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                ForEach(viewModel.filteredFollowers, id: \.id) { follower in
                    Button(action: {
                        selectedFollower = follower
                        showUserDetails = true
                    }) {
                        FollowerCell(follower: follower)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        viewModel.loadMoreFollowersIfNeeded(currentFollower: follower)
                    }
                }
            }
            .padding()
            
            if viewModel.isLoading && !viewModel.followers.isEmpty {
                ProgressView()
                    .padding()
            }
        }
    }
}