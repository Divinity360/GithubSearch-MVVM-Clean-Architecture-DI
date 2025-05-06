import SwiftUI

struct SearchView: View {
    @Environment(\.diContainer) private var diContainer
    @StateObject private var viewModel: SearchViewModel
    @State private var showFollowersList = false
    @State private var showSettings = false
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.viewModelFactory.makeSearchViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.blue)
                    
                    Text("Search for a GitHub user")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                GFTextField(placeholder: "Enter a username", text: $viewModel.username)
                    .padding(.horizontal)
                
                NavigationLink(
                    destination: FollowerListView(username: viewModel.username),
                    isActive: $showFollowersList
                ) {
                    EmptyView()
                }
                
                GFButton(title: "Get Followers", backgroundColor: .blue) {
                    if !viewModel.username.isEmpty {
                        showFollowersList = true
                    }
                }
                .padding(.horizontal)
                .disabled(!viewModel.isUsernameValid)
                .opacity(viewModel.isUsernameValid ? 1.0 : 0.5)
                
                Spacer()
            }
            .padding()
            .navigationTitle("GitHub Followers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .task {
                await viewModel.testTaskGroup()
            }
        }
    }
}
