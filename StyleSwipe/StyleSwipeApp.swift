//
//  StyleSwipeApp.swift
//  StyleSwipe
//
//  Created by Ayush Krishnappa on 9/13/24.
//

import SwiftUI
import FirebaseCore

@main
struct StyleSwipeApp: App {
    let persistenceController = PersistenceController.shared

    // Initialize Firebase and UserDefaults when the app starts
    init() {
        FirebaseApp.configure()
        initializeDefaultPreferences()
    }

    var body: some Scene {
        WindowGroup {
            LoginSignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    // Method to initialize default UserDefaults preferences
    private func initializeDefaultPreferences() {
        if UserDefaults.standard.dictionary(forKey: "userPreferences") == nil {
            let defaultPreferences: [String: Any] = [
                "sizes": ["XS", "S", "M", "L", "XL", "XXL"], // All sizes
                "clothingTypes": ["Shorts", "Pants", "Jackets", "Shoes", "Shirts", "Hats", "Tops", "Jeans", "Other"], // All types
                "gender": ["Male", "Female", "Neutral"], // All genders
                "price": 200 // Default max price
            ]
            UserDefaults.standard.set(defaultPreferences, forKey: "userPreferences")
            print("Default preferences initialized:", defaultPreferences)
        } else {
            print("Preferences already set:", UserDefaults.standard.dictionary(forKey: "userPreferences") ?? [:])
        }
    }
}
