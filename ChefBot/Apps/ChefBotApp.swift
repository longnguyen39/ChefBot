//
//  ChefBotApp.swift
//  ChefBot
//
//  Created by Long Nguyen on 4/26/25.
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
struct ChefBotApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage(UserDe.userID) var userID: String?
    
    var body: some Scene {
        WindowGroup {
            if userID == nil {
                OnboardingScreen()
            } else {
                NavigationStack {
                    HomeScreen()
                }
            }
        }
    }
}

