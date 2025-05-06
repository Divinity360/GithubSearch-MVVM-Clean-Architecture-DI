import XCTest

class FavoritesScreen {
    private let app: XCUIApplication
    
    // UI Elements
    var favoriteCells: XCUIElementQuery { app.tables.cells }
    var emptyStateView: XCUIElement { app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'No favorites'")).firstMatch }
    var favoritesTab: XCUIElement { app.tabBars.buttons["Favorites"] }
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // Actions
    func tapFavoritesTab() {
        favoritesTab.tap()
    }
    
    func tapFavorite(at index: Int) {
        if favoriteCells.count > index {
            favoriteCells.element(boundBy: index).tap()
        }
    }
    
    func swipeToDeleteFavorite(at index: Int) {
        if favoriteCells.count > index {
            let cell = favoriteCells.element(boundBy: index)
            cell.swipeLeft()
            app.buttons["Delete"].tap()
        }
    }
    
    // Verifications
    func isDisplayed() -> Bool {
        return favoritesTab.exists && (hasFavorites() || isEmptyStateDisplayed())
    }
    
    func hasFavorites() -> Bool {
        return favoriteCells.count > 0
    }
    
    func isEmptyStateDisplayed() -> Bool {
        return emptyStateView.exists
    }
    
    func favoritesCount() -> Int {
        return favoriteCells.count
    }
}