//
//  UserProfileView.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - User Profile View

/// Modern user profile view with glassmorphism design
struct UserProfileView: View {
    
    // MARK: - Properties
    
    /// Main ViewModel reference for logout functionality
    let mainViewModel: MainViewModel
    
    /// Environment dependencies
    @Environment(DependencyContainer.self) private var dependencies
    
    /// Current user data from UserRepository
    @State private var currentUser: User?
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Profile Header
                VStack(spacing: 20) {
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppConstants.Colors.primary, AppConstants.Colors.primary.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        if let profileImageURL = currentUser?.profileImageURL, !profileImageURL.isEmpty {
                            AsyncImage(url: URL(string: profileImageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                        }
                    }
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    
                    // User Info
                    VStack(spacing: 8) {
                        Text(currentUser?.name ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text(currentUser?.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        // Email verification status
                        if let user = currentUser, !user.isEmailVerified {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundStyle(.orange)
                                    .font(.caption)
                                Text("Email Not Verified")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange.opacity(0.1))
                            )
                        }
                    }
                }
                .padding(.top, 32)
                
                // Menu Items
                VStack(spacing: 16) {
                    // Account Settings
                    MenuItemView(
                        icon: "gearshape.fill",
                        title: "Account Settings",
                        subtitle: "Manage your account preferences"
                    ) {
                        // Navigate to settings
                    }
                    
                    // Security
                    MenuItemView(
                        icon: "lock.shield.fill",
                        title: "Security & Privacy",
                        subtitle: "Password, 2FA, and privacy settings"
                    ) {
                        // Navigate to security settings
                    }
                    
                    // Support
                    MenuItemView(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help or contact support"
                    ) {
                        // Navigate to support
                    }
                    
                    // About
                    MenuItemView(
                        icon: "info.circle.fill",
                        title: "About PayAction",
                        subtitle: "Version, terms, and more"
                    ) {
                        // Navigate to about
                    }
                }
                .padding(.horizontal, 20)
                
                // Sign Out Button
                VStack(spacing: 12) {
                    Button(action: {
                        Task {
                            await signOut()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Sign Out")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .foregroundStyle(.white)
                        .background(
                            LinearGradient(
                                colors: [.red, .red.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("You'll be signed out from all devices")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadUserData()
        }
    }
    
    // MARK: - Actions
    
    /// Loads current user data
    @MainActor
    private func loadUserData() async {
        do {
            currentUser = try await dependencies.userRepository.loadUser()
        } catch {
            dependencies.loggingService.logError(error, context: "Loading user profile data")
        }
    }
    
    /// Signs out the current user
    @MainActor
    private func signOut() async {
        do {
            try await mainViewModel.signOut()
            HapticFeedbackManager.shared.playSuccess()
        } catch let error as AuthenticationError {
            // Show specific error message based on error type
            if case .networkError = error {
                LoggingService.shared.logError(error, context: "Sign out failed - no internet connection")
            } else {
                LoggingService.shared.logError(error, context: "User profile sign out")
            }
            HapticFeedbackManager.shared.playError()
        } catch {
            LoggingService.shared.logError(error, context: "User profile sign out")
            HapticFeedbackManager.shared.playError()
        }
    }
}

// MARK: - Menu Item View

/// Reusable menu item component
struct MenuItemView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppConstants.Colors.surfaceStrong)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(AppConstants.Colors.primary)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppConstants.Colors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppConstants.Colors.primary.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return UserProfileView(mainViewModel: dependencies.makeMainViewModel())
        .environment(dependencies)
}