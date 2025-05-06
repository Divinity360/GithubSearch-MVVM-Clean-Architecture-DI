import SwiftUI

struct FavoritesView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: FavoritesViewModel
    @State private var showUserDetails = false
    @State private var selectedUsername: String = ""
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.viewModelFactory.makeFavoritesViewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2.0)
                } else if let errorMessage = viewModel.errorMessage {
                    GFEmptyStateView(message: errorMessage)
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.getFavorites()
            }
            .background(
                NavigationLink(
                    destination: UserDetailView(username: selectedUsername),
                    isActive: $showUserDetails
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    private var favoritesList: some View {
        List {
            ForEach(viewModel.favorites, id: \.id) { favorite in
                Button(action: {
                    selectedUsername = favorite.login
                    showUserDetails = true
                }) {
                    HStack {
                        GFAvatarImageView(urlString: favorite.avatarUrl)
                            .frame(width: 60, height: 60)
                        
                        Text(favorite.login)
                            .font(.headline)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete(perform: viewModel.removeFavorite)
        }
    }
}