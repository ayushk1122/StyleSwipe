//
//  StyleSwipeApp.swift
//  StyleSwipe
//
//  Created by Ayush Krishnappa on 9/13/24.
//
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct StyleSwipeApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate



    var body: some Scene {
        WindowGroup {
            LoginSignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }

    }
  }
}

