import Foundation

struct Follower: Codable, Hashable, Equatable {

    let login: String
    let id: Int
    let avatarUrl: String
    let url: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
