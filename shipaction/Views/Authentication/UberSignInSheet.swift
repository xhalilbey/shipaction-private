//
//  UberSignInSheet.swift
//  payaction-ios
//
//  Created by Halil Eren on 16.06.2025.
//
//  Modern Apple HIG uyumlu Sign In tasarımı

import SwiftUI

struct UberSignInSheet: View {
    @State private var viewModel: AuthenticationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
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
                    
                    Image(systemName: "creditcard.and.123")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                    
                    Text("Sign in to your PayAction account")
                        .font(.subheadline)
                        .foregroundStyle(AppConstants.Colors.dynamicSecondaryText(colorScheme))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
            
            // Social Sign In
            VStack(spacing: 12) {
                // Google Sign-In Button (styled like Apple button)
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
                                    .frame(width: 18, height: 18)
                            } else {
                                Image(systemName: "globe")
                                    .font(.system(size: 18, weight: .medium))
                            }
                        }
                        .foregroundStyle(AppConstants.Colors.primary)
                        Text("Google ile giriş yapın")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(AppConstants.Colors.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(AppConstants.Colors.dynamicBackground(colorScheme))
                            .stroke(AppConstants.Colors.primary, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Google ile giriş yapın")
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
                // Email
                CustomTextField(
                    title: "Email",
                    placeholder: "Enter your email address",
                    text: $viewModel.signInCredentials.email,
                    type: .email,
                    validationMessage: viewModel.emailValidationMessage,
                    showValidation: viewModel.emailFieldTouched && !viewModel.signInCredentials.email.isEmpty
                )
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onTapGesture {
                    viewModel.markEmailFieldTouched()
                }
                
                // Password
                CustomTextField(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $viewModel.signInCredentials.password,
                    type: .password,
                    isSecure: true,
                    validationMessage: viewModel.passwordValidationMessage,
                    showValidation: viewModel.passwordFieldTouched && !viewModel.signInCredentials.password.isEmpty
                )
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onTapGesture {
                    viewModel.markPasswordFieldTouched()
                }
                

            }
            .padding(.horizontal, 24)
            

            
            // Actions
            VStack(spacing: 16) {
                // Sign In Button
                Button(action: {
                    Task {
                        await viewModel.signIn()
                        // Login başarılı olduğunda direkt ana sayfaya yönlendirecek
                        // dismiss() çağrısı kaldırıldı, navigationManager.navigateToMain() 
                        // ViewModel içinde çağrılıyor
                    }
                }) {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .controlSize(.small)
                                .tint(.white)
                        }
                        Text("Sign In")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(AppConstants.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(viewModel.isLoading)
                
                // Forgot Password
                Button("Forgot Password?") {
                    viewModel.showForgotPassword()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppConstants.Colors.primary)
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
        .sheet(isPresented: $viewModel.showForgotPasswordSheet) {
            ForgotPasswordSheet(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    .onSubmit {
            switch focusedField {
            case .email:
                focusedField = .password
            case .password:
                if viewModel.isSignInValid {
                    Task {
                        await viewModel.signIn()
                        // NavigateToMain ViewModel içinde çağrılıyor
                    }
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
    
    return UberSignInSheet(viewModel: dependencies.makeAuthenticationViewModel())
}