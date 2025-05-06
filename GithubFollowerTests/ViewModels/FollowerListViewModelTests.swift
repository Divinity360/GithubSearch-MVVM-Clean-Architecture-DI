import XCTest
import Combine
@testable import GithubFollower

final class FollowerListViewModelTests: XCTestCase {
    
    var sut: FollowerListViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = FollowerListViewModel(username: TestData.username, networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInitialState() {
        // Given (setUp creates the ViewModel with default state)
        
        // Then
        XCTAssertEqual(sut.username, TestData.username, "Username should be set correctly")
        XCTAssertTrue(mockNetworkService.getFollowersWasCalled, "getFollowers should be called during initialization")
        XCTAssertEqual(mockNetworkService.lastUsername, TestData.username, "getFollowers should be called with correct username")
        XCTAssertEqual(mockNetworkService.lastPage, 1, "getFollowers should be called with page 1")
    }
    
    func testGetFollowers_WhenSuccessful_ShouldUpdateFollowersList() {
        // Given - initialization already calls getFollowers
        let followerCount = mockNetworkService.mockFollowers.count
        
        // Then
        XCTAssertEqual(sut.followers.count, followerCount, "Followers count should match mock data")
        XCTAssertEqual(sut.filteredFollowers.count, followerCount, "Filtered followers should initially match all followers")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNil(sut.errorMessage, "errorMessage should be nil on success")
    }
    
    func testGetFollowers_WhenFailed_ShouldSetErrorMessage() {
        // Given
        mockNetworkService.shouldSucceed = false
        
        // When - reset viewModel to trigger getFollowers again
        sut = FollowerListViewModel(username: TestData.username, networkService: mockNetworkService)
        
        // Then
        XCTAssertTrue(sut.followers.isEmpty, "Followers should be empty on error")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set on failure")
    }
    
    func testFilterFollowers_WithMatchingText_ShouldFilterCorrectly() {
        // Given
        let searchText = "user1" // Should match the first follower
        
        // When
        sut.searchText = searchText
        
        // Let the published property update
        let expectation = expectation(description: "Search text processed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        // Then
        XCTAssertEqual(sut.filteredFollowers.count, 1, "Should filter to just one matching follower")
        XCTAssertEqual(sut.filteredFollowers.first?.login, "user1", "Should match the correct follower")
    }
    
    func testFilterFollowers_WithNoMatch_ShouldReturnEmptyList() {
        // Given
        let searchText = "nonexistentuser"
        
        // When
        sut.searchText = searchText
        
        // Let the published property update
        let expectation = expectation(description: "Search text processed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        // Then
        XCTAssertTrue(sut.filteredFollowers.isEmpty, "Filtered list should be empty for non-matching search")
    }
    
    func testFilterFollowers_WhenSearchCleared_ShouldResetToAllFollowers() {
        // Given
        // First set a filter
        sut.searchText = "user1"
        
        // Let the published property update
        let filterExpectation = expectation(description: "Filter applied")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            filterExpectation.fulfill()
        }
        wait(for: [filterExpectation], timeout: 1)
        
        // When
        sut.searchText = ""
        
        // Let the published property update
        let clearExpectation = expectation(description: "Filter cleared")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            clearExpectation.fulfill()
        }
        wait(for: [clearExpectation], timeout: 1)
        
        // Then
        XCTAssertEqual(sut.filteredFollowers.count, mockNetworkService.mockFollowers.count, "All followers should be shown when search is cleared")
    }
    
    func testLoadMoreFollowersIfNeeded_WhenAtThreshold_ShouldCallGetFollowers() {
        // Given
        let thresholdFollower = mockNetworkService.mockFollowers.last!
        
        // Set up tracking of getFollowers calls
        var getFollowersCalls = 1 // It's called once in init
        mockNetworkService.getFollowersWasCalled = false // Reset the flag
        
        // When
        sut.loadMoreFollowersIfNeeded(currentFollower: thresholdFollower)
        
        // Then
        XCTAssertTrue(mockNetworkService.getFollowersWasCalled, "getFollowers should be called when at threshold")
        XCTAssertEqual(mockNetworkService.lastPage, 2, "Page should increment for the next request")
    }
}