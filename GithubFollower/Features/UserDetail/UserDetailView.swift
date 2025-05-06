import SwiftUI

struct UserDetailView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: UserDetailViewModel
    
    init(username: String) {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.viewModelFactory.makeUserDetailViewModel(username: username))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2.0)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    GFEmptyStateView(message: errorMessage)
                } else if let user = viewModel.user {
                    UserInfoHeaderView(user: user)
                    
                    if let bio = user.bio, !bio.isEmpty {
                        Text(bio)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    infoCards(user: user)
                }
            }
        }
        .navigationTitle(viewModel.user?.login ?? "User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.user != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if viewModel.isAddedToFavorites {
                            viewModel.removeFromFavorites()
                        } else {
                            viewModel.addToFavorites()
                        }
                    }) {
                        Image(systemName: viewModel.isAddedToFavorites ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
    }
    
    private func infoCards(user: User) -> some View {
        VStack(spacing: 20) {
            HStack {
                statsView(title: "Public Repos", count: user.publicRepos, systemImage: "folder.fill")
                statsView(title: "Public Gists", count: user.publicGists, systemImage: "text.alignleft")
            }
            
            HStack {
                statsView(title: "Followers", count: user.followers, systemImage: "person.2.fill")
                statsView(title: "Following", count: user.following, systemImage: "person.badge.plus")
            }
            
            Link(destination: URL(string: user.htmlUrl)!) {
                HStack {
                    Image(systemName: "safari")
                    Text("View on GitHub")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func statsView(title: String, count: Int, systemImage: String) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 5) {
                Image(systemName: systemImage)
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}