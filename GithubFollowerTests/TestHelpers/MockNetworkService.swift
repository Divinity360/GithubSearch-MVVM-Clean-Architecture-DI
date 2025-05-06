import Foundation
import UIKit
@testable import GithubFollower

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockFollowers = TestData.mockFollowers
    var mockUser = TestData.mockUser
    var mockImage = UIImage(systemName: "person.fill")!
    
    var getFollowersWasCalled = false
    var getUserInfoWasCalled = false
    var downloadImageWasCalled = false
    
    var lastUsername: String?
    var lastPage: Int?
    var lastImageUrl: String?
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], NetworkError>) -> Void) {
        getFollowersWasCalled = true
        lastUsername = username
        lastPage = page
        
        if shouldSucceed {
            completion(.success(mockFollowers))
        } else {
            completion(.failure(.invalidData))
        }
    }
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        getUserInfoWasCalled = true
        lastUsername = username
        
        if shouldSucceed {
            completion(.success(mockUser))
        } else {
            completion(.failure(.invalidData))
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        downloadImageWasCalled = true
        lastImageUrl = urlString
        
        if shouldSucceed {
            completion(mockImage)
        } else {
            completion(nil)
        }
    }
}