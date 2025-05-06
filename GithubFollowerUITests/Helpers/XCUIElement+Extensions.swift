import XCTest

extension XCUIElement {
    func waitForExistence(timeout: TimeInterval = 5) -> Bool {
        return self.waitForExistence(timeout: timeout)
    }
    
    func clearText() {
        guard self.exists else { return }
        // Select all text and delete it
        self.tap()
        self.press(forDuration: 1.0)
        self.buttons["Select All"].tap()
        self.typeText(XCUIKeyboardKey.delete.rawValue)
    }
    
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
    }
    
    // Add this convenience getter for better test readability
    var isDisplayed: Bool {
        return self.exists && self.isHittable
    }
    
    // Helper to handle keyboard appearance/disappearance
    func typeTextAndDismissKeyboard(_ text: String) {
        self.tap()
        self.typeText(text)
        XCUIApplication().keyboards.buttons["Return"].tap()
    }
}

extension XCUIKeyboardKey {
    static let delete = XCUIKeyboardKey("delete")
}