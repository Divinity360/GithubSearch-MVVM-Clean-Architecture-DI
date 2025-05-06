import Foundation
@testable import GithubFollower

struct TestData {
    static let mockFollower = Follower(
        login: "testUser",
        id: 123,
        avatarUrl: "https://example.com/avatar.png",
        url: "https://api.github.com/users/testUser"
    )
    
    static let mockFollowers = [
        Follower(login: "user1", id: 1, avatarUrl: "https://example.com/avatar1.png", url: "https://api.github.com/users/user1"),
        Follower(login: "user2", id: 2, avatarUrl: "https://example.com/avatar2.png", url: "https://api.github.com/users/user2"),
        Follower(login: "user3", id: 3, avatarUrl: "https://example.com/avatar3.png", url: "https://api.github.com/users/user3")
    ]
    
    static let mockUser = User(
        login: "testUser",
        id: 123,
        avatarUrl: "https://example.com/avatar.png",
        name: "Test User",
        location: "Test Location",
        bio: "Test bio",
        publicRepos: 10,
        publicGists: 5,
        htmlUrl: "https://github.com/testUser",
        following: 20,
        followers: 30,
        createdAt: Date()
    )
    
    static let username = "testUser"
    static let errorMessage = "Test error"
}