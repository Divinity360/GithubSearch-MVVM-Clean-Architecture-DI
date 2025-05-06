import SwiftUI

struct FollowerCell: View {
    let follower: Follower
    
    var body: some View {
        VStack {
            GFAvatarImageView(urlString: follower.avatarUrl)
                .frame(width: 100, height: 100)
            
            Text(follower.login)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding()
        .frame(width: 120, height: 140)
    }
}