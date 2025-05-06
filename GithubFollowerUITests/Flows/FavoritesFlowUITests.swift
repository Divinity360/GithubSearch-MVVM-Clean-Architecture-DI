import XCTest
@testable import GithubFollower

final class FavoritesFlowUITests: XCTestCase {
    
    var app: XCUIApplication!
    var searchScreen: SearchScreen!
    var followerListScreen: FollowerListScreen!
    var userDetailScreen: UserDetailScreen!
    var favoritesScreen: FavoritesScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Clear UserDefaults for favorites between test runs to ensure consistent state
        app.launchArguments = ["-clearFavorites"]
        app.launch()
        
        searchScreen = SearchScreen(app: app)
        followerListScreen = FollowerListScreen(app: app)
        userDetailScreen = UserDetailScreen(app: app)
        favoritesScreen = FavoritesScreen(app: app)
    }

    override func tearDownWithError() throws {
        app = nil
        searchScreen = nil
        followerListScreen = nil
        userDetailScreen = nil
        favoritesScreen = nil
    }
    
    @MainActor
    func testFavoritesTabEmptyStateInitially() throws {
        // Go to favorites tab
        favoritesScreen.tapFavoritesTab()
        
        // Verify empty state is shown
        XCTAssertTrue(favoritesScreen.isDisplayed(), "Favorites screen should be displayed")
        XCTAssertTrue(favoritesScreen.isEmptyStateDisplayed(), "Empty state should be displayed initially")
        XCTAssertFalse(favoritesScreen.hasFavorites(), "Should not have any favorites initially")
    }
    
    @MainActor
    func testAddUserToFavorites() throws {
        // Search for a user
        searchScreen.searchForUser("octocat")
        
        // Wait for loading to complete
        let loadingExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: followerListScreen.loadingIndicator
        )
        wait(for: [loadingExpectation], timeout: 10)
        
        // Tap on a follower to go to user details
        followerListScreen.tapFollower(at: 0)
        
        // Wait for user detail screen to load
        XCTAssertTrue(userDetailScreen.isDisplayed(), "User detail screen should be displayed")
        
        // Add user to favorites
        userDetailScreen.tapFavoriteButton()
        
        // Verify user is added to favorites
        XCTAssertTrue(userDetailScreen.isFavorited(), "User should be marked as favorite")
        
        // Go back to the search screen
        userDetailScreen.tapBackButton()
        
        // Go to favorites tab
        favoritesScreen.tapFavoritesTab()
        
        // Verify the user is in favorites
        XCTAssertTrue(favoritesScreen.hasFavorites(), "User should be in favorites")
        XCTAssertEqual(favoritesScreen.favoritesCount(), 1, "Should have one favorite")
    }
    
    @MainActor
    func testRemoveUserFromFavorites() throws {
        // First add a user to favorites
        try testAddUserToFavorites()
        
        // Verify we have a favorite
        XCTAssertTrue(favoritesScreen.hasFavorites(), "Should have a favorite to remove")
        
        // Remove the favorite
        favoritesScreen.swipeToDeleteFavorite(at: 0)
        
        // Verify the favorite is removed
        XCTAssertFalse(favoritesScreen.hasFavorites(), "Favorite should be removed")
        XCTAssertTrue(favoritesScreen.isEmptyStateDisplayed(), "Empty state should be displayed after removing favorite")
    }
    
    @MainActor
    func testTapFavoriteNavigatesToUserDetail() throws {
        // First add a user to favorites
        try testAddUserToFavorites()
        
        // Tap on the favorite
        favoritesScreen.tapFavorite(at: 0)
        
        // Verify user detail screen is displayed
        XCTAssertTrue(userDetailScreen.isDisplayed(), "User detail screen should be displayed")
    }
    
    @MainActor
    func testRemoveFavoriteFromUserDetail() throws {
        // First add a user to favorites
        try testAddUserToFavorites()
        
        // Tap on the favorite to go to user detail
        favoritesScreen.tapFavorite(at: 0)
        
        // Verify user detail screen is displayed and user is favorited
        XCTAssertTrue(userDetailScreen.isDisplayed(), "User detail screen should be displayed")
        XCTAssertTrue(userDetailScreen.isFavorited(), "User should be marked as favorite")
        
        // Remove from favorites
        userDetailScreen.tapFavoriteButton()
        
        // Verify user is no longer favorited
        XCTAssertFalse(userDetailScreen.isFavorited(), "User should not be marked as favorite")
        
        // Go back to favorites screen
        userDetailScreen.tapBackButton()
        
        // Verify the favorite is removed
        XCTAssertFalse(favoritesScreen.hasFavorites(), "Favorite should be removed")
        XCTAssertTrue(favoritesScreen.isEmptyStateDisplayed(), "Empty state should be displayed after removing favorite")
    }
}