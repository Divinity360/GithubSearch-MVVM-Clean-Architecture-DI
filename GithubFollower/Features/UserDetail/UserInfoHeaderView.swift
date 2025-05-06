import SwiftUI

struct UserInfoHeaderView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 20) {
            GFAvatarImageView(urlString: user.avatarUrl)
                .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name ?? "N/A")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.login)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(user.location ?? "No Location")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Joined \(formatDate(date: user.createdAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
}