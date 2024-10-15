//
//  StyleSwipeApp.swift
//  StyleSwipe
//
//  Created by Ayush Krishnappa on 9/13/24.
//

import SwiftUI

@main
struct StyleSwipeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginSignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
