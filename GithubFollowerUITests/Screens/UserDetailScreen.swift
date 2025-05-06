import XCTest

class UserDetailScreen {
    private let app: XCUIApplication
    
    // UI Elements
    var userAvatar: XCUIElement { app.images.firstMatch }
    var favoriteButton: XCUIElement { app.buttons["FavoriteButton"] }
    var userLogin: XCUIElement { app.staticTexts.element(matching: .any, identifier: "UserLoginLabel") }
    var githubProfileLink: XCUIElement { app.buttons["View on GitHub"] }
    var backButton: XCUIElement { app.navigationBars.buttons.element(boundBy: 0) }
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // Actions
    func tapFavoriteButton() {
        favoriteButton.tap()
    }
    
    func tapBackButton() {
        backButton.tap()
    }
    
    // Verifications
    func isDisplayed() -> Bool {
        return userAvatar.waitForExistence() && githubProfileLink.waitForExistence()
    }
    
    func isFavorited() -> Bool {
        return favoriteButton.exists && favoriteButton.label.contains("Remove from Favorites")
    }
    
    func userName() -> String? {
        return userLogin.exists ? userLogin.label : nil
    }
}