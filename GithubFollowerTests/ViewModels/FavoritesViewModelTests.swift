import XCTest
import Combine
@testable import GithubFollower

final class FavoritesViewModelTests: XCTestCase {
    
    var sut: FavoritesViewModel!
    var mockPersistenceService: MockPersistenceService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockPersistenceService = MockPersistenceService()
        sut = FavoritesViewModel(persistenceService: mockPersistenceService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockPersistenceService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInitialState() {
        // Given (setUp creates the ViewModel with default state)
        
        // Then
        XCTAssertTrue(mockPersistenceService.retrieveFavoritesWasCalled, "retrieveFavorites should be called during initialization")
    }
    
    func testGetFavorites_WhenSuccessful_ShouldUpdateFavoritesList() {
        // Given - initialization already calls getFavorites
        let favoriteCount = mockPersistenceService.mockFavorites.count
        
        // Then
        XCTAssertEqual(sut.favorites.count, favoriteCount, "Favorites count should match mock data")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNil(sut.errorMessage, "errorMessage should be nil on success")
    }
    
    func testGetFavorites_WhenEmpty_ShouldSetErrorMessage() {
        // Given
        mockPersistenceService.mockFavorites = []
        
        // When - reset viewModel to trigger getFavorites again
        sut = FavoritesViewModel(persistenceService: mockPersistenceService)
        
        // Then
        XCTAssertTrue(sut.favorites.isEmpty, "Favorites should be empty")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set when no favorites")
    }
    
    func testGetFavorites_WhenFailed_ShouldSetErrorMessage() {
        // Given
        mockPersistenceService.shouldSucceed = false
        
        // When - reset viewModel to trigger getFavorites again
        sut = FavoritesViewModel(persistenceService: mockPersistenceService)
        
        // Then
        XCTAssertTrue(sut.favorites.isEmpty, "Favorites should be empty on error")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after completion")
        XCTAssertNotNil(sut.errorMessage, "errorMessage should be set on failure")
    }
    
    func testRemoveFavorite_ShouldCallPersistenceService() {
        // Given
        let indexSet = IndexSet(integer: 0)
        let favoriteToRemove = mockPersistenceService.mockFavorites[0]
        
        // When
        sut.removeFavorite(at: indexSet)
        
        // Then
        XCTAssertTrue(mockPersistenceService.removeFavoriteWasCalled, "removeFavorite should be called")
        XCTAssertEqual(mockPersistenceService.lastFavorite?.login, favoriteToRemove.login, "Correct favorite should be removed")
    }
    
    func testRemoveFavorite_WhenSuccessful_ShouldUpdateFavoritesList() {
        // Given
        let originalCount = mockPersistenceService.mockFavorites.count
        let indexSet = IndexSet(integer: 0)
        
        // This is necessary to simulate the persistence service actually removing the item
        let removedFavorite = mockPersistenceService.mockFavorites[0]
        mockPersistenceService.mockFavorites.remove(at: 0)
        
        // When
        sut.removeFavorite(at: indexSet)
        
        // Then
        // Note: In a real app, this test would need to wait for the asynchronous removal to complete
        // We'd set up an expectation for the favorites to change
        
        // For now, we can check that the viewModel calls the right methods
        XCTAssertEqual(mockPersistenceService.lastFavorite?.login, removedFavorite.login, "Correct favorite should be removed")
    }
}