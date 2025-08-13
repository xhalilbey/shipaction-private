//
//  AuthenticationSheets.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - Sign In Sheet
/// Bottom sheet for user sign in with email and password
struct SignInSheet: View {
    /// Authentication ViewModel injected from parent
    @State private var viewModel: AuthenticationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Focus State
    @FocusState private var focusedField: AuthField?
    
    enum AuthField {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Handle indicator
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color(.systemGray4))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)
                    
                    // Title and subtitle
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(.label))
                        
                        Text("Sign in to your PayAction account")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Form
                VStack(spacing: 20) {
                    // Email field
                    CustomTextField(
                        title: "Email",
                        placeholder: "Enter your email",
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
                    
                    // Password field
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
                
                // Error message
                if let errorMessage = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundStyle(AppConstants.Colors.primary)
                            .font(.system(size: 14))
                        
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(AppConstants.Colors.primary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                // Action buttons
                VStack(spacing: 16) {
                    // Sign In button
                    UnifiedButton(
                        title: "Sign In",
                        style: .primary,
                        isLoading: viewModel.isLoading,
                        isEnabled: !viewModel.isLoading
                    ) {
                        Task {
                            await viewModel.signIn()
                            if viewModel.authenticationSucceeded {
                                dismiss()
                            }
                        }
                    }
                    .frame(height: 54)
                    
                    // Forgot password
                    Button("Forgot Password?") {
                        viewModel.showForgotPassword()
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(.systemBlue))
                }
                .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 32))
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.showForgotPasswordSheet) {
            ForgotPasswordSheet(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .onSubmit {
            handleSubmit()
        }
        .onChange(of: viewModel.authenticationSucceeded) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    // MARK: - Actions
    private func handleSubmit() {
        switch focusedField {
        case .email:
            focusedField = .password
        case .password:
            if viewModel.isSignInValid {
                Task {
                    await viewModel.signIn()
                }
            }
        case .none:
            break
        }
    }
}

// MARK: - Create Account Sheet
/// Bottom sheet for new user registration
struct CreateAccountSheet: View {
    /// Authentication ViewModel injected from parent
    @State private var viewModel: AuthenticationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Focus State
    @FocusState private var focusedField: CreateAccountField?
    
    enum CreateAccountField {
        case fullName, email, password, confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        // Handle indicator
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color(.systemGray4))
                            .frame(width: 36, height: 5)
                            .padding(.top, 8)
                        
                        // Title and subtitle
                        VStack(spacing: 8) {
                            Text("Create Account")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(.label))
                            
                            Text("Join PayAction and start your financial journey")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(Color(.secondaryLabel))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Full Name field
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
                        
                        // Email field
                        CustomTextField(
                            title: "Email",
                            placeholder: "Enter your email",
                            text: $viewModel.createAccountForm.email,
                            type: .email,
                            validationMessage: viewModel.createAccountEmailValidationMessage,
                            showValidation: !viewModel.createAccountForm.email.isEmpty
                        )
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        
                        // Password field
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
                        .submitLabel(.next)
                        
                        // Confirm Password field
                        CustomTextField(
                            title: "Confirm Password",
                            placeholder: "Confirm your password",
                            text: $viewModel.createAccountForm.confirmPassword,
                            type: .password,
                            isSecure: true,
                            validationMessage: viewModel.confirmPasswordValidationMessage,
                            showValidation: !viewModel.createAccountForm.confirmPassword.isEmpty
                        )
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                    }
                    .padding(.horizontal, 24)
                    
                    // Terms and conditions
                    HStack(alignment: .top, spacing: 12) {
                        Button(action: { viewModel.createAccountForm.agreeToTerms.toggle() }) {
                            Image(systemName: viewModel.createAccountForm.agreeToTerms ? "checkmark.square.fill" : "square")
                                .font(.system(size: 20))
                                .foregroundColor(viewModel.createAccountForm.agreeToTerms ? AppConstants.Colors.primary : Color(.systemGray3))
                        }
                        
                        Text("I agree to the **Terms of Service** and **Privacy Policy**")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(Color(.secondaryLabel))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Error message
                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .foregroundStyle(AppConstants.Colors.primary)
                                .font(.system(size: 14))
                            
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(AppConstants.Colors.primary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Action button
                    VStack(spacing: 16) {
                        UnifiedButton(
                            title: "Create Account",
                            style: .primary,
                            isLoading: viewModel.isLoading,
                            isEnabled: !viewModel.isLoading
                        ) {
                            Task {
                                await viewModel.createAccount()
                                if viewModel.authenticationSucceeded {
                                    dismiss()
                                }
                            }
                        }
                        .frame(height: 54)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
        }
        .onSubmit {
            handleSubmit()
        }
        .onChange(of: viewModel.authenticationSucceeded) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    // MARK: - Actions
    private func handleSubmit() {
        switch focusedField {
        case .fullName:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = .confirmPassword
        case .confirmPassword:
            if viewModel.isCreateAccountValid {
                Task {
                    await viewModel.createAccount()
                }
            }
        case .none:
            break
        }
    }
}

// MARK: - Preview
#Preview("Sign In Sheet") {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return SignInSheet(viewModel: dependencies.makeAuthenticationViewModel())
}

#Preview("Create Account Sheet") {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return CreateAccountSheet(viewModel: dependencies.makeAuthenticationViewModel())
} 