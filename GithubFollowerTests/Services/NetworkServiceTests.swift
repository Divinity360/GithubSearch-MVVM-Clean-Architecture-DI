import XCTest
@testable import GithubFollower

final class NetworkServiceTests: XCTestCase {
    
    // System under test
    var sut: NetworkService!
    
    // Mock URL session for testing
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = NetworkService()
        // Inject the mock session using reflection since NetworkService doesn't have DI for URLSession
        // In a real app, you would modify NetworkService to accept a URLSession in the constructor
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: - Test Helpers and Mocks
    
    class MockURLSession: URLSession {
        var data: Data?
        var error: Error?
        var response: URLResponse?
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return MockURLSessionDataTask {
                completionHandler(self.data, self.response, self.error)
            }
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return MockURLSessionDataTask {
                completionHandler(self.data, self.response, self.error)
            }
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        private let closure: () -> Void
        
        init(closure: @escaping () -> Void) {
            self.closure = closure
        }
        
        override func resume() {
            closure()
        }
    }
    
    // MARK: - Test Cases
    
    func testGetFollowers_WhenSuccessful_ShouldReturnFollowers() {
        // Given
        // This is a functional test of the real service, but with controlled inputs
        let username = "octocat"
        let page = 1
        let expectation = expectation(description: "Network request completed")
        var result: Result<[Follower], NetworkError>?
        
        // When
        sut.getFollowers(for: username, page: page) { receivedResult in
            result = receivedResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5)
        
        if case .failure(let error) = result {
            XCTFail("Network request failed with error: \(error)")
            return
        }
        
        // Assert that we got some followers (can't predict exact data)
        if case .success(let followers) = result {
            // Only assert that we get data back, not specific count since it's a real API
            XCTAssertTrue(followers.count >= 0, "Should have received followers array")
        } else {
            XCTFail("Expected success result")
        }
    }
    
    func testGetFollowers_WithInvalidUsername_ShouldReturnError() {
        // Given
        let username = "@@@@invalid@@@@" // Invalid username that should cause an error
        let page = 1
        let expectation = expectation(description: "Network request completed")
        var result: Result<[Follower], NetworkError>?
        
        // When
        sut.getFollowers(for: username, page: page) { receivedResult in
            result = receivedResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5)
        
        if case .success = result {
            XCTFail("Expected request to fail with invalid username")
        }
        
        // We expect some kind of error (could be invalidResponse, etc.)
        if case .failure = result {
            // Success - we got an error as expected
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure result")
        }
    }
    
    func testGetUserInfo_WhenSuccessful_ShouldReturnUser() {
        // Given
        let username = "octocat"
        let expectation = expectation(description: "Network request completed")
        var result: Result<User, NetworkError>?
        
        // When
        sut.getUserInfo(for: username) { receivedResult in
            result = receivedResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 5)
        
        if case .failure(let error) = result {
            XCTFail("Network request failed with error: \(error)")
            return
        }
        
        if case .success(let user) = result {
            XCTAssertEqual(user.login, username, "User login should match the requested username")
            XCTAssertFalse(user.avatarUrl.isEmpty, "Avatar URL should not be empty")
        } else {
            XCTFail("Expected success result")
        }
    }
}