//
//  GithubFollowerApp.swift
//  GithubFollower
//
//  Created by mac on 05/05/2025.
//

import SwiftUI

@main
struct GithubFollowerApp: App {
    @ObservedObject private var colorSchemeManager = ColorSchemeManager.shared
    @ObservedObject private var diContainer = DIContainer.shared
    
    init() {
        // Configure global services
        setupTestingParameters()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .preferredColorScheme(colorSchemeManager.colorScheme)
                .withDIContainer(diContainer)
        }
    }
    
    private func setupTestingParameters() {
        // Check for UI test arguments
        let arguments = ProcessInfo.processInfo.arguments
        
        // Clear favorites for UI testing if needed
        if arguments.contains("-clearFavorites") {
            UserDefaults.standard.removeObject(forKey: "favorites")
        }
    }
}
