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
    private var colorScheme: ColorScheme { .light }
    @State private var showingSignOutAlert = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    profileOptions
                    signOutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
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
            HStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            
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
                .padding(.horizontal, 16)
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
                    .foregroundStyle(AppConstants.Colors.primary)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(primaryRowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Tokens
    private var primaryRowBackground: Color { AppConstants.Colors.primary.opacity(0.08) }
}

// MARK: - Tokens
private extension ProfileTabView {
    var backgroundColor: Color { AppConstants.Colors.background }

    var primaryTokenBackground: Color { AppConstants.Colors.primary.opacity(0.1) }
}

 