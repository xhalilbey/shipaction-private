//
//  ProfileTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Profile Tab View

/// User profile management tab view
struct ProfileTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingSignOutAlert = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    profileHeader
                    quickActions
                    profileOptions
                    signOutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .background(backgroundColor)
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadUserProfile()
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                Task {
                    await viewModel.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    // MARK: - Components
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
                    .frame(height: 80)
            } else {
                VStack(spacing: 12) {
                    // Profile Picture
                    Circle()
                        .fill(primaryTokenBackground)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(userInitials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppConstants.Colors.primary)
                        )
                    
                    // User Info
                    VStack(spacing: 4) {
                        Text(viewModel.user?.name ?? "User")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(viewModel.user?.email ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(AppConstants.Colors.dynamicLogo(colorScheme))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
            Text("Profile")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppConstants.Colors.primary)
            }
            .buttonStyle(.plain)
            .allowsHitTesting(false)
            .accessibilityLabel("Settings")
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            QuickActionButton(icon: "person.fill.viewfinder", title: "Verify")
            QuickActionButton(icon: "creditcard.fill", title: "Billing")
            QuickActionButton(icon: "lock.shield", title: "Security")
        }
    }
    
    private var profileOptions: some View {
        VStack(spacing: 12) {
            ProfileOptionRow(
                icon: "person.circle",
                title: "Account Settings",
                action: {}
            )
            
            ProfileOptionRow(
                icon: "bell",
                title: "Notifications",
                action: {}
            )
            
            ProfileOptionRow(
                icon: "lock",
                title: "Privacy & Security",
                action: {}
            )
            
            ProfileOptionRow(
                icon: "questionmark.circle",
                title: "Help & Support",
                action: {}
            )
            
            ProfileOptionRow(
                icon: "info.circle",
                title: "About",
                action: {}
            )
        }
    }
    
    private var signOutSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.vertical, 8)
            
            Button(action: {
                showingSignOutAlert = true
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.red)
                    
                    Text("Sign Out")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.red)
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    // MARK: - Computed Properties
    
    private var userInitials: String {
        guard let name = viewModel.user?.name, !name.isEmpty else {
            return "U"
        }
        
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
}

// MARK: - Profile Option Row

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
            Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(primaryRowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Tokens
         private var primaryRowBackground: Color { AppConstants.Colors.primary }
}

// MARK: - Tokens
private extension ProfileTabView {
    var backgroundColor: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }

    var primaryTokenBackground: Color { AppConstants.Colors.primary.opacity(0.1) }
}

// MARK: - Quick Action Button
private struct QuickActionButton: View {
    let icon: String
    let title: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppConstants.Colors.primary)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppConstants.Colors.surface)
                )
                         Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
                 .background(
             RoundedRectangle(cornerRadius: 12, style: .continuous)
                 .fill(AppConstants.Colors.primary)
         )
    }
}

 