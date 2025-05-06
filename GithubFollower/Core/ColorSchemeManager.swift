import SwiftUI

class ColorSchemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme?
    
    static let shared = ColorSchemeManager()
    
    private init() {
        if let savedScheme = UserDefaults.standard.string(forKey: "colorScheme") {
            colorScheme = savedScheme == "dark" ? .dark : savedScheme == "light" ? .light : nil
        } else {
            colorScheme = nil
        }
    }
    
    func setColorScheme(_ scheme: ColorScheme?) {
        colorScheme = scheme
        UserDefaults.standard.set(
            scheme == .dark ? "dark" : scheme == .light ? "light" : "system",
            forKey: "colorScheme"
        )
    }
}