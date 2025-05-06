import SwiftUI

struct GFEmptyStateView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
        }
    }
}