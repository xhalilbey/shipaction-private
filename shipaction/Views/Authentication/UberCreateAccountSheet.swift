//
//  UberCreateAccountSheet.swift
//  payaction-ios
//
//  Created by Halil Eren on 16.06.2025.
//
//  Apple Design Award 2024 standardında Create Account tasarımı
//  Glassmorphism, Ultra-smooth animations, Premium UX

import SwiftUI
import LocalAuthentication

struct UberCreateAccountSheet: View {
    @State private var viewModel: AuthenticationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, email, password
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // Background
                    AppConstants.Colors.dynamicBackground(colorScheme)
                        .ignoresSafeArea(.all)
                    
                    ScrollView {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 24) {
                // App icon - solid brand color (no gradient)
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppConstants.Colors.primary)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Join PayAction and start your financial journey")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            // Google Sign-In Button (Apple HIG + Google branding)
            VStack(spacing: 12) {
                Button(action: {
                    Task {
                        await viewModel.signInWithGoogle()
                    }
                }) {
                    HStack(spacing: 12) {
                        Group {
                            if let _ = UIImage(named: "google-icon") {
                                Image("google-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "globe")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        Text("Continue with Google")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppConstants.Colors.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Continue with Google")
            }
            .padding(.horizontal, 24)
            
            // Divider
            HStack {
                Rectangle()
                    .fill(Color(.separator))
                    .frame(height: 0.5)
                
                Text("or")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .fill(Color(.separator))
                    .frame(height: 0.5)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            
            // Form
            VStack(spacing: 16) {
                // Full Name
                CustomTextField(
                    title: "Full Name",
                    placeholder: "Enter your full name",
                    text: $viewModel.createAccountForm.fullName,
                    type: .name,
                    validationMessage: viewModel.fullNameValidationMessage,
                    showValidation: !viewModel.createAccountForm.fullName.isEmpty
                )
                .focused($focusedField, equals: .fullName)
                .submitLabel(.next)
                
                // Email
                CustomTextField(
                    title: "Email",
                    placeholder: "Enter your email address",
                    text: $viewModel.createAccountForm.email,
                    type: .email,
                    validationMessage: viewModel.createAccountEmailValidationMessage,
                    showValidation: !viewModel.createAccountForm.email.isEmpty
                )
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                
                // Password
                CustomTextField(
                    title: "Password",
                    placeholder: "Create a password",
                    text: $viewModel.createAccountForm.password,
                    type: .password,
                    isSecure: true,
                    validationMessage: viewModel.createAccountPasswordValidationMessage,
                    showValidation: !viewModel.createAccountForm.password.isEmpty
                )
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                

            }
            .padding(.horizontal, 24)
            

            
            // Actions
            VStack(spacing: 16) {
                // Create Account Button
                Button(action: {
                    Task {
                        await viewModel.createAccount()
                        // Hesap oluşturma başarılı olduğunda direkt ana sayfaya yönlendirilecek
                        // ViewModel içindeki navigateToMain() çağrılıyor
                    }
                }) {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .controlSize(.small)
                                .tint(.white)
                        }
                        Text("Create Account")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(AppConstants.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 32))
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                    
                    // Modern Error Toast
                    if let errorMessage = viewModel.errorMessage {
                        ModernErrorToast(message: errorMessage) {
                            viewModel.clearErrors()
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                        .zIndex(1)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $viewModel.showEmailVerificationSent) {
            EmailVerificationSentSheet(
                email: viewModel.verificationEmail,
                onBackToLogin: {
                    viewModel.showEmailVerificationSent = false
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .onSubmit {
            switch focusedField {
            case .fullName:
                focusedField = .email
            case .email:
                focusedField = .password
            case .password:
                Task {
                    await viewModel.createAccount()
                }
            case .none:
                break
            }
        }
    }
}

#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return UberCreateAccountSheet(viewModel: dependencies.makeAuthenticationViewModel())
}