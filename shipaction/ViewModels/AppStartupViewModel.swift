//
//  AppStartupViewModel.swift
//  payaction-ios
//
//  Created by Assistant on 06.08.2025.
//

import Foundation
import SwiftUI
import Observation
import FirebaseAuth

// MARK: - App Startup State

/// Represents the different states during app startup
enum AppStartupState: Equatable {
    case initializing
    case loadingUserData
    case checkingConnectivity
    case ready(flow: AppFlow)
    case noInternet
}

// MARK: - App Startup ViewModel

/// ViewModel responsible for handling app initialization logic
/// 
/// Centralizes startup logic including authentication state checking,
/// user data loading, and connectivity verification to keep Views clean
@Observable
final class AppStartupViewModel {
    
    // MARK: - Published State
    
    /// Current startup state
    var currentState: AppStartupState = .initializing
    
    /// Whether the app startup is complete
    var isStartupComplete: Bool {
        switch currentState {
        case .ready, .noInternet:
            return true
        default:
            return false
        }
    }
    
    /// Current app flow if startup is complete
    var currentFlow: AppFlow? {
        switch currentState {
        case .ready(let flow):
            return flow
        default:
            return nil
        }
    }
    
    /// Whether internet connection is required for current operation
    var requiresInternet: Bool {
        switch currentState {
        case .ready(let flow):
            return flow == .main
        default:
            return false
        }
    }
    
    // MARK: - Dependencies
    
    private let navigationManager: NavigationManager
    private let userRepository: UserRepository
    private let networkManager: NetworkMonitoring
    private let loggingService: LoggingServiceProtocol

    /// Firebase auth state listener handle to manage lifecycle
    private var authListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    
    init(
        navigationManager: NavigationManager,
        userRepository: UserRepository,
        networkManager: NetworkMonitoring,
        loggingService: LoggingServiceProtocol
    ) {
        self.navigationManager = navigationManager
        self.userRepository = userRepository
        self.networkManager = networkManager
        self.loggingService = loggingService
    }
    
    // MARK: - Startup Actions
    
    /// Performs app startup sequence
    @MainActor
    func performStartup() async {
        // Show loading screen for minimum duration for smooth UX
        await showInitialLoadingScreen()
        
        // Load app state based on authentication (avoid blocking on connectivity at cold start)
        await loadInitialAppState()
        
        // Perform connectivity check in the background and update if needed
        Task { @MainActor in
            await checkConnectivity()
        }
    }
    
    /// Shows initial loading screen for minimum duration
    @MainActor
    private func showInitialLoadingScreen() async {
        currentState = .initializing
        
        // Show loading screen for minimum duration (UX requirement)
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        loggingService.logInfo("App startup initialization completed")
    }
    
    /// Checks network connectivity
    @MainActor
    private func checkConnectivity() async {
        currentState = .checkingConnectivity
        
        // Test actual internet access for accuracy
        let hasInternet = await networkManager.testInternetAccess()
        
        if !hasInternet {
            loggingService.logWarning("No internet connection detected during startup", context: "AppStartup")
        }
    }
    
    /// Loads initial app state based on Firebase Auth state
    @MainActor
    private func loadInitialAppState() async {
        currentState = .loadingUserData
        
        // Listen to Firebase Auth state changes for automatic state management
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                await self?.handleAuthStateChange(user: user)
            }
        }
    }
    
    /// Handles Firebase Auth state changes
    @MainActor
    private func handleAuthStateChange(user: FirebaseAuth.User?) async {
        guard let user = user else {
            // No user signed in, go to onboarding
            await handleNoUserSignedIn()
            return
        }
        
        // User is signed in, verify email and proceed
        await handleUserSignedIn(user: user)
    }
    
    /// Handles case when no user is signed in
    @MainActor
    private func handleNoUserSignedIn() async {
        do {
            try await userRepository.clearUserData()
            navigationManager.navigateToOnboarding()
            currentState = .ready(flow: .onboarding)
            loggingService.logInfo("No user signed in, showing onboarding")
        } catch {
            loggingService.logError(error, context: "Clearing user data during startup")
            navigationManager.navigateToOnboarding()
            currentState = .ready(flow: .onboarding)
        }
    }
    
    /// Handles case when user is signed in
    @MainActor
    private func handleUserSignedIn(user: FirebaseAuth.User) async {
        do {
            // SECURITY: Check email verification before allowing access
            guard user.isEmailVerified else {
                loggingService.logInfo("Unverified user attempted auto-signin, signing out: \(user.email ?? "unknown")")
                try Auth.auth().signOut()
                try await userRepository.clearUserData()
                navigationManager.navigateToOnboarding()
                currentState = .ready(flow: .onboarding)
                return
            }
            
            // Create User object from Firebase user
            let appUser = User(
                id: user.uid,
                email: user.email ?? "",
                name: user.displayName ?? "User",
                isEmailVerified: user.isEmailVerified
            )
            
            try await userRepository.saveUser(appUser)
            
            // Check internet requirement for main app
            if networkManager.isConnected {
                navigationManager.navigateToMain()
                currentState = .ready(flow: .main)
                loggingService.logInfo("Verified user auto-signed in: \(user.email ?? "unknown")")
            } else {
                // User is authenticated but no internet - show appropriate state
                currentState = .noInternet
                loggingService.logWarning("User signed in but no internet connection", context: "AppStartup")
            }
            
        } catch {
            loggingService.logError(error, context: "Loading signed-in user during startup")
            try? Auth.auth().signOut()
            try? await userRepository.clearUserData()
            navigationManager.navigateToOnboarding()
            currentState = .ready(flow: .onboarding)
        }
    }
    
    /// Handles connectivity state changes during app usage
    @MainActor
    func handleConnectivityChange() {
        switch currentState {
        case .ready(let flow):
            if flow == .main && !networkManager.isConnected {
                // Keep user in main, but UI can present offline states per-screen.
                loggingService.logInfo("Main app lost internet connection; staying in app")
            }
        case .noInternet:
            if networkManager.isConnected {
                // If connection restored, prefer onboarding (if not logged in) or main depending on auth
                // Let performStartup() recalc state
                Task { @MainActor in
                    await performStartup()
                }
            }
        default:
            break
        }
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
}
