//
//  payaction_iosApp.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

// MARK: - App Delegate for Firebase Setup

/// AppDelegate for Firebase configuration
/// 
/// Using UIApplicationDelegateAdaptor for proper Firebase initialization
/// in SwiftUI app lifecycle
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Configure Google Sign-In
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientId = plist["CLIENT_ID"] as? String else {
            print("GoogleService-Info.plist not found or CLIENT_ID missing")
            return true
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        print("Firebase and Google Sign-In configured successfully")
        return true
    }
}

// MARK: - PayAction iOS App

/// Main app entry point following 2024 SwiftUI best practices
/// 
/// Properly initializes Firebase via AppDelegate and manages app state
@main
struct payaction_iosApp: App {
    
    // MARK: - App Delegate
    
    /// Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - App State
    
    /// Navigation manager created directly to avoid circular dependency
    private let navigationManager = NavigationManager()
    
    /// Dependency container with injected navigation manager
    @State private var dependencyContainer: DependencyContainer?
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(navigationManager)
                .environment(dependencyContainer ?? DependencyContainer(navigationManager: navigationManager))
                // Global tint for navigation/back controls
                .tint(AppConstants.Colors.primary)
                // Follow system color scheme preference (dark/light mode)
                .onAppear {
                    if dependencyContainer == nil {
                        dependencyContainer = DependencyContainer(navigationManager: navigationManager)
                    }
                }
        }
    }
}
