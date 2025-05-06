import XCTest
import Combine
@testable import GithubFollower

final class UserDetailViewModelTests: XCTestCase {
    
    var sut: UserDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockPersistenceService: MockPersistenceService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockPersistenceService = MockPersistenceService()
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockPersistenceService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInitialState() {
        // Given (setUp creates the ViewModel with default state)
        
        // Then
        XCTAssertTrue(mockNetworkService.getUserInfoWasCalled, "getUserInfo should be called during initialization")
        XCTAssertEqual(mockNetworkService.lastUsername, TestData.username, "getUserInfo should be called with correct username")
        
        XCTAssertTrue(mockPersistenceService.isFavoriteWasCalled, "isFavorite should be called during initialization")
        XCTAssertEqual(mockPersistenceService.lastUsername, TestData.username, "isFavorite should be called with correct username")
    }
    
    func testGetUserInfo_WhenSuccessful_ShouldUpdateUserData() {
        // Given - initialization already calls getUserInfo
        
        // Then
        XCTAssertNotNil(sut.user, "User should be set after successful request")
        XCTAssertEqual(sut.user?.login, mockNetworkService.mockUser.login, "User login should match mock data")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNil(sut.errorMessage, "errorMessage should be nil on success")
    }
    
    func testGetUserInfo_WhenFailed_ShouldSetErrorMessage() {
        // Given
        mockNetworkService.shouldSucceed = false
        
        // When - reset viewModel to trigger getUserInfo again
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // Then
        XCTAssertNil(sut.user, "User should be nil on error")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set on failure")
    }
    
    func testAddToFavorites_ShouldCallPersistenceService() {
        // Given
        
        // When
        sut.addToFavorites()
        
        // Then
        XCTAssertTrue(mockPersistenceService.saveFavoriteWasCalled, "saveFavorite should be called")
        XCTAssertEqual(mockPersistenceService.lastFavorite?.login, TestData.username, "Favorite should have correct login")
        XCTAssertTrue(sut.isAddedToFavorites, "isAddedToFavorites should be true after adding")
    }
    
    func testAddToFavorites_WhenFailed_ShouldSetErrorMessage() {
        // Given
        mockPersistenceService.shouldSucceed = false
        
        // When
        sut.addToFavorites()
        
        // Then
        XCTAssertFalse(sut.isAddedToFavorites, "isAddedToFavorites should remain false on error")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set on failure")
    }
    
    func testRemoveFromFavorites_ShouldCallPersistenceService() {
        // Given
        mockPersistenceService.isFavoriteValue = true
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // When
        sut.removeFromFavorites()
        
        // Then
        XCTAssertTrue(mockPersistenceService.removeFavoriteWasCalled, "removeFavorite should be called")
        XCTAssertEqual(mockPersistenceService.lastFavorite?.login, TestData.username, "Favorite should have correct login")
        XCTAssertFalse(sut.isAddedToFavorites, "isAddedToFavorites should be false after removing")
    }
    
    func testRemoveFromFavorites_WhenFailed_ShouldSetErrorMessage() {
        // Given
        mockPersistenceService.isFavoriteValue = true
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        mockPersistenceService.shouldSucceed = false
        
        // When
        sut.removeFromFavorites()
        
        // Then
        XCTAssertTrue(sut.isAddedToFavorites, "isAddedToFavorites should remain true on error")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set on failure")
    }
    
    func testCheckIfFavorite_WhenIsFavorite_ShouldUpdateState() {
        // Given
        mockPersistenceService.isFavoriteValue = true
        
        // When - reset viewModel to trigger checkIfFavorite again
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // Then
        XCTAssertTrue(sut.isAddedToFavorites, "isAddedToFavorites should be true when is favorite")
    }
    
    func testCheckIfFavorite_WhenNotFavorite_ShouldUpdateState() {
        // Given
        mockPersistenceService.isFavoriteValue = false
        
        // When - reset viewModel to trigger checkIfFavorite again
        sut = UserDetailViewModel(
            username: TestData.username,
            networkService: mockNetworkService,
            persistenceService: mockPersistenceService
        )
        
        // Then
        XCTAssertFalse(sut.isAddedToFavorites, "isAddedToFavorites should be false when not favorite")
    }
}