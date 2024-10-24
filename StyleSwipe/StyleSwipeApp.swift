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
    
    // Initialize Firebase when the app starts
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LoginSignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
