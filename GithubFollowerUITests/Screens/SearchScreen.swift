import XCTest

class SearchScreen {
    private let app: XCUIApplication
    
    // UI Elements
    var usernameTextField: XCUIElement { app.textFields["Enter a username"] }
    var getFollowersButton: XCUIElement { app.buttons["Get Followers"] }
    var searchTitle: XCUIElement { app.staticTexts["Search for a GitHub user"] }
    var settingsButton: XCUIElement { app.buttons["SettingsButton"] }
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // Actions
    func enterUsername(_ username: String) {
        usernameTextField.tap()
        usernameTextField.clearText()
        usernameTextField.typeText(username)
    }
    
    func tapGetFollowers() {
        getFollowersButton.tap()
    }
    
    func searchForUser(_ username: String) {
        enterUsername(username)
        tapGetFollowers()
    }
    
    func openSettings() {
        settingsButton.tap()
    }
    
    // Verifications
    func isDisplayed() -> Bool {
        return searchTitle.waitForExistence()
    }
    
    func isGetFollowersButtonEnabled() -> Bool {
        return getFollowersButton.isEnabled
    }
}