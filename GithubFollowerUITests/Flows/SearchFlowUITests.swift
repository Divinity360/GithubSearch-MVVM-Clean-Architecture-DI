import XCTest
@testable import GithubFollower

final class SearchFlowUITests: XCTestCase {
    
    var app: XCUIApplication!
    var searchScreen: SearchScreen!
    var followerListScreen: FollowerListScreen!
    var userDetailScreen: UserDetailScreen!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        searchScreen = SearchScreen(app: app)
        followerListScreen = FollowerListScreen(app: app)
        userDetailScreen = UserDetailScreen(app: app)
    }

    override func tearDownWithError() throws {
        app = nil
        searchScreen = nil
        followerListScreen = nil
        userDetailScreen = nil
    }
    
    @MainActor
    func testSearchScreenInitialState() throws {
        // Verify that the search screen is displayed
        XCTAssertTrue(searchScreen.isDisplayed(), "Search screen should be displayed")
        
        // Verify that the Get Followers button is disabled initially
        XCTAssertFalse(searchScreen.isGetFollowersButtonEnabled(), "Get Followers button should be disabled when username is empty")
    }
    
    @MainActor
    func testGetFollowersButtonEnablesWithInput() throws {
        // Verify that the Get Followers button is disabled initially
        XCTAssertFalse(searchScreen.isGetFollowersButtonEnabled(), "Get Followers button should be disabled when username is empty")
        
        // Enter a username
        searchScreen.enterUsername("octocat")
        
        // Verify that the Get Followers button is now enabled
        XCTAssertTrue(searchScreen.isGetFollowersButtonEnabled(), "Get Followers button should be enabled when username is entered")
    }
    
    @MainActor
    func testSearchForValidUserNavigatesToFollowersList() throws {
        // Enter a valid username and tap Get Followers
        searchScreen.searchForUser("octocat")
        
        // Verify that we navigated to the followers list screen
        XCTAssertTrue(followerListScreen.isDisplayed(), "Should navigate to followers list screen")
        
        // Wait for loading to complete
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: followerListScreen.loadingIndicator
        )
        wait(for: [expectation], timeout: 10)
        
        // Verify that followers are displayed
        XCTAssertTrue(followerListScreen.hasFollowers(), "Should display followers for valid user")
    }
    
    @MainActor
    func testSearchForInvalidUserShowsEmptyState() throws {
        // Enter an invalid username and tap Get Followers
        searchScreen.searchForUser("abcdefghijklmnopqrstuvwxyz123invaliduser")
        
        // Verify that we navigated to the followers list screen
        XCTAssertTrue(followerListScreen.isDisplayed(), "Should navigate to followers list screen")
        
        // Wait for loading to complete
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: followerListScreen.loadingIndicator
        )
        wait(for: [expectation], timeout: 10)
        
        // Verify that empty state is displayed
        XCTAssertTrue(followerListScreen.isEmptyStateDisplayed(), "Should display empty state for invalid user")
    }
    
    @MainActor
    func testFilterFollowers() throws {
        // Search for a user with many followers
        searchScreen.searchForUser("octocat")
        
        // Wait for loading to complete
        let loadingExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: followerListScreen.loadingIndicator
        )
        wait(for: [loadingExpectation], timeout: 10)
        
        // Get the initial follower count
        let initialCount = followerListScreen.followersCount()
        
        // Search for a specific follower
        followerListScreen.searchForFollower("a") // Search for followers with 'a' in username
        
        // Wait for filtered results
        sleep(1) // Give time for filter to apply
        
        // Get the filtered count
        let filteredCount = followerListScreen.followersCount()
        
        // The filtered count should be less than or equal to the initial count
        // It could be equal if all followers contain 'a'
        XCTAssertLessThanOrEqual(filteredCount, initialCount, "Filtered followers count should be less than or equal to initial count")
        
        // Clear the search
        followerListScreen.clearSearch()
        
        // Wait for results to reset
        sleep(1)
        
        // The count should be back to the initial count
        XCTAssertEqual(followerListScreen.followersCount(), initialCount, "Follower count should reset after clearing search")
    }
    
    @MainActor
    func testTapFollowerNavigatesToUserDetail() throws {
        // Search for a user with followers
        searchScreen.searchForUser("octocat")
        
        // Wait for loading to complete
        let loadingExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: followerListScreen.loadingIndicator
        )
        wait(for: [loadingExpectation], timeout: 10)
        
        // Verify there are followers
        XCTAssertTrue(followerListScreen.hasFollowers(), "Should have followers to tap on")
        
        // Tap the first follower
        followerListScreen.tapFollower(at: 0)
        
        // Verify we navigate to user detail screen
        XCTAssertTrue(userDetailScreen.isDisplayed(), "Should navigate to user detail screen")
    }
}