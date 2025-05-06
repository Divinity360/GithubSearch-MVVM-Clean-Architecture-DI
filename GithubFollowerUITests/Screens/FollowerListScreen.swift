import XCTest

class FollowerListScreen {
    private let app: XCUIApplication
    
    // UI Elements
    var searchBar: XCUIElement { app.searchFields.firstMatch }
    var followerCells: XCUIElement { app.scrollViews.otherElements.containing(.image, identifier: "FollowerCell").element }
    var loadingIndicator: XCUIElement { app.activityIndicators.firstMatch }
    var emptyStateView: XCUIElement { app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'followers'")).firstMatch }
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // Actions
    func searchForFollower(_ username: String) {
        searchBar.tap()
        searchBar.typeText(username)
    }
    
    func tapFollower(at index: Int) {
        let cells = app.scrollViews.otherElements.children(matching: .button)
        if cells.count > index {
            cells.element(boundBy: index).tap()
        }
    }
    
    func clearSearch() {
        if searchBar.buttons["Clear text"].exists {
            searchBar.buttons["Clear text"].tap()
        } else {
            searchBar.clearText()
        }
    }
    
    // Verifications
    func isDisplayed() -> Bool {
        return searchBar.waitForExistence()
    }
    
    func isLoading() -> Bool {
        return loadingIndicator.exists
    }
    
    func hasFollowers() -> Bool {
        return followerCells.exists
    }
    
    func isEmptyStateDisplayed() -> Bool {
        return emptyStateView.exists
    }
    
    func followersCount() -> Int {
        return app.scrollViews.otherElements.children(matching: .button).count
    }
}