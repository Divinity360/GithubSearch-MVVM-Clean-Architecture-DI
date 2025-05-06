import XCTest
@testable import GithubFollower

final class PersistenceServiceTests: XCTestCase {
    
    var sut: PersistenceService!
    var userDefaults: UserDefaults!
    
    private let testKey = "test_favorites"
    
    override func setUp() {
        super.setUp()
        
        // Create a UserDefaults for testing with a unique suite name
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        
        sut = PersistenceService()
        
        // Use a subclass of PersistenceService that uses our test UserDefaults
        // In a real implementation, make PersistenceService accept UserDefaults in constructor
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
        userDefaults = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testSaveFavorite_ShouldSaveToUserDefaults() {
        // Given
        let follower = TestData.mockFollower
        let saveExpectation = expectation(description: "Save favorite completed")
        var resultError: Error?
        
        // When
        sut.saveFavorite(follower) { error in
            resultError = error
            saveExpectation.fulfill()
        }
        
        // Then
        wait(for: [saveExpectation], timeout: 1)
        XCTAssertNil(resultError, "Save should not result in error")
        
        // Verify by retrieving
        var retrievedFollowers: [Follower] = []
        let retrieveExpectation = expectation(description: "Retrieve favorites completed")
        
        sut.retrieveFavorites { result in
            if case .success(let followers) = result {
                retrievedFollowers = followers
            }
            retrieveExpectation.fulfill()
        }
        
        wait(for: [retrieveExpectation], timeout: 1)
        XCTAssertTrue(retrievedFollowers.contains(where: { $0.id == follower.id }), "Retrieved favorites should contain the saved follower")
    }
    
    func testRemoveFavorite_WhenExisting_ShouldRemoveFromUserDefaults() {
        // Given
        let follower = TestData.mockFollower
        let saveExpectation = expectation(description: "Save favorite completed")
        
        // First save the follower
        sut.saveFavorite(follower) { _ in
            saveExpectation.fulfill()
        }
        
        wait(for: [saveExpectation], timeout: 1)
        
        // When
        let removeExpectation = expectation(description: "Remove favorite completed")
        var resultError: Error?
        
        sut.removeFavorite(follower) { error in
            resultError = error
            removeExpectation.fulfill()
        }
        
        // Then
        wait(for: [removeExpectation], timeout: 1)
        XCTAssertNil(resultError, "Remove should not result in error")
        
        // Verify by retrieving
        var retrievedFollowers: [Follower] = []
        let retrieveExpectation = expectation(description: "Retrieve favorites completed")
        
        sut.retrieveFavorites { result in
            if case .success(let followers) = result {
                retrievedFollowers = followers
            }
            retrieveExpectation.fulfill()
        }
        
        wait(for: [retrieveExpectation], timeout: 1)
        XCTAssertFalse(retrievedFollowers.contains(where: { $0.id == follower.id }), "Retrieved favorites should not contain the removed follower")
    }
    
    func testRetrieveFavorites_WhenEmpty_ShouldReturnEmptyArray() {
        // Given
        let retrieveExpectation = expectation(description: "Retrieve favorites completed")
        var retrievedFollowers: [Follower] = []
        
        // When
        sut.retrieveFavorites { result in
            if case .success(let followers) = result {
                retrievedFollowers = followers
            }
            retrieveExpectation.fulfill()
        }
        
        // Then
        wait(for: [retrieveExpectation], timeout: 1)
        XCTAssertTrue(retrievedFollowers.isEmpty, "Retrieved favorites should be empty when no favorites are saved")
    }
    
    func testIsFavorite_WhenFavoriteExists_ShouldReturnTrue() {
        // Given
        let follower = TestData.mockFollower
        let saveExpectation = expectation(description: "Save favorite completed")
        
        // First save the follower
        sut.saveFavorite(follower) { _ in
            saveExpectation.fulfill()
        }
        
        wait(for: [saveExpectation], timeout: 1)
        
        // When
        let checkExpectation = expectation(description: "Check favorite completed")
        var isFavorite = false
        
        sut.isFavorite(username: follower.login) { result in
            isFavorite = result
            checkExpectation.fulfill()
        }
        
        // Then
        wait(for: [checkExpectation], timeout: 1)
        XCTAssertTrue(isFavorite, "User should be a favorite after being saved")
    }
    
    func testIsFavorite_WhenFavoriteDoesNotExist_ShouldReturnFalse() {
        // Given
        let nonExistentUsername = "nonexistentuser"
        
        // When
        let checkExpectation = expectation(description: "Check favorite completed")
        var isFavorite = true
        
        sut.isFavorite(username: nonExistentUsername) { result in
            isFavorite = result
            checkExpectation.fulfill()
        }
        
        // Then
        wait(for: [checkExpectation], timeout: 1)
        XCTAssertFalse(isFavorite, "Non-existent user should not be a favorite")
    }
}