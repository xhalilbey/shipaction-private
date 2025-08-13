//
//  AuthenticationViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Authentication View Model

/// ViewModel for authentication flows using iOS 17 @Observable
/// 
/// Handles sign-in, account creation, and form validation
/// Following 2024 SwiftUI MVVM best practices with proper separation of concerns
@Observable
final class AuthenticationViewModel {
    
    // MARK: - State Properties
    
    /// Sign-in form credentials
    var signInCredentials = LoginCredentials()
    
    /// Account creation form data
    var createAccountForm = CreateAccountForm()
    
    /// Loading state for authentication operations
    var isLoading = false
    
    /// Error message to display to user
    var errorMessage: String?
    
    /// Success state for navigation triggers
    var authenticationSucceeded = false
    
    /// Email verification state
    var showEmailVerificationSent = false
    var verificationEmail = ""
    
    /// Forgot password state
    var showForgotPasswordSheet = false
    var forgotPasswordEmail = ""
    var forgotPasswordSent = false
    var forgotPasswordError: String?
    
    /// Field touch states for validation timing
    var emailFieldTouched = false
    var passwordFieldTouched = false
    var createAccountEmailTouched = false
    var createAccountPasswordTouched = false
    var createAccountNameTouched = false
    
    // MARK: - Dependencies
    
    private let authenticationService: AuthenticationService
    private let navigationManager: NavigationManager
    
    // MARK: - Initialization
    
    init(
        authenticationService: AuthenticationService,
        navigationManager: NavigationManager
    ) {
        self.authenticationService = authenticationService
        self.navigationManager = navigationManager
    }
    
    // MARK: - Validation Properties
    
    /// Validates sign-in form
    var isSignInValid: Bool {
        ValidationService.isValidEmail(signInCredentials.email) &&
        ValidationService.isValidPassword(signInCredentials.password)
    }
    
    /// Validates account creation form
    var isCreateAccountValid: Bool {
        ValidationService.isValidFullName(createAccountForm.fullName) &&
        ValidationService.isValidEmail(createAccountForm.email) &&
        ValidationService.isValidPassword(createAccountForm.password)
    }
    
    // MARK: - Validation Messages
    
    var emailValidationMessage: String? {
        ValidationService.emailValidationMessage(for: signInCredentials.email)
    }
    
    var passwordValidationMessage: String? {
        ValidationService.passwordValidationMessage(for: signInCredentials.password)
    }
    
    var createAccountEmailValidationMessage: String? {
        ValidationService.emailValidationMessage(for: createAccountForm.email)
    }
    
    var createAccountPasswordValidationMessage: String? {
        ValidationService.passwordValidationMessage(for: createAccountForm.password)
    }
    
    /// Checks if password has both letter and number
    var hasLetterAndNumber: Bool {
        let password = createAccountForm.password
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        return hasLetter && hasNumber
    }
    
    var confirmPasswordValidationMessage: String? {
        ValidationService.confirmPasswordValidationMessage(
            for: createAccountForm.confirmPassword,
            matching: createAccountForm.password
        )
    }
    
    var fullNameValidationMessage: String? {
        ValidationService.fullNameValidationMessage(for: createAccountForm.fullName)
    }
    
    // MARK: - Actions
    
    /// Performs sign-in authentication
    @MainActor
    func signIn() async {
        guard isSignInValid else { return }
        
        await performAuthenticationAction { [self] in
            try await authenticationService.signIn(
                email: signInCredentials.email,
                password: signInCredentials.password
            )
        }
    }
    
    /// Creates new user account
    @MainActor
    func createAccount() async {
        guard isCreateAccountValid else { return }
        
        await performCreateAccountAction { [self] in
            try await authenticationService.createAccount(
                fullName: createAccountForm.fullName,
                email: createAccountForm.email,
                password: createAccountForm.password
            )
        }
    }
    
    /// Signs in user with Google account
    @MainActor
    func signInWithGoogle() async {
        await performAuthenticationAction { [self] in
            try await authenticationService.signInWithGoogle()
        }
    }
    
    /// Resets form state and errors efficiently
    func resetState() {
        // Clear credentials
        signInCredentials = LoginCredentials()
        createAccountForm = CreateAccountForm()
        
        // Reset state flags
        errorMessage = nil
        authenticationSucceeded = false
        showEmailVerificationSent = false
        verificationEmail = ""
        
        // Reset validation flags efficiently
        resetTouchStates()
        resetForgotPasswordState()
    }
    
    /// Clears error messages (used by ModernErrorToast)
    func clearErrors() {
        errorMessage = nil
        forgotPasswordError = nil
    }
    
    /// Efficiently resets all touch states
    private func resetTouchStates() {
        emailFieldTouched = false
        passwordFieldTouched = false
        createAccountEmailTouched = false
        createAccountPasswordTouched = false
        createAccountNameTouched = false
    }
    

    
    // MARK: - Forgot Password Actions
    
    /// Shows forgot password sheet
    func showForgotPassword() {
        resetForgotPasswordState()
        forgotPasswordEmail = signInCredentials.email // Pre-fill with sign-in email if available
        showForgotPasswordSheet = true
    }
    
    /// Sends forgot password email
    @MainActor
    func sendForgotPasswordEmail() async {
        guard isValidEmail(forgotPasswordEmail) else {
            forgotPasswordError = "Please enter a valid email address"
            return
        }
        
        isLoading = true
        forgotPasswordError = nil
        
        do {
            try await authenticationService.sendPasswordResetEmail(email: forgotPasswordEmail)
            forgotPasswordSent = true
            isLoading = false
        } catch let error as AuthenticationError {
            forgotPasswordError = error.errorDescription
            isLoading = false
        } catch {
            forgotPasswordError = "Failed to send reset email. Please try again."
            isLoading = false
        }
    }
    
    /// Resets forgot password state
    func resetForgotPasswordState() {
        forgotPasswordEmail = ""
        forgotPasswordSent = false
        forgotPasswordError = nil
        showForgotPasswordSheet = false
    }
    
    // MARK: - Field Touch Actions
    
    /// Marks email field as touched for validation
    func markEmailFieldTouched() {
        emailFieldTouched = true
    }
    
    /// Marks password field as touched for validation
    func markPasswordFieldTouched() {
        passwordFieldTouched = true
    }
    
    /// Marks create account email field as touched
    func markCreateAccountEmailTouched() {
        createAccountEmailTouched = true
    }
    
    /// Marks create account password field as touched
    func markCreateAccountPasswordTouched() {
        createAccountPasswordTouched = true
    }
    
    /// Marks create account name field as touched
    func markCreateAccountNameTouched() {
        createAccountNameTouched = true
    }
    
    // MARK: - Helper Methods
    
    /// Validates email format using centralized ValidationService
    private func isValidEmail(_ email: String) -> Bool {
        return ValidationService.isValidEmail(email)
    }
    
    /// Performs authentication action with common error handling and loading state management
    /// - Parameter action: The authentication action to perform
    @MainActor
    private func performAuthenticationAction(_ action: @escaping () async throws -> User) async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await action()
            
            // Success - trigger navigation
            authenticationSucceeded = true
            navigationManager.navigateToMain()
            
        } catch let error as AuthenticationError {
            errorMessage = error.errorDescription
        } catch is GoogleSignInCancelled {
            // User cancelled Google Sign-In - don't show error, just stop loading
            // This is normal behavior, not an error
        } catch {
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
    
    /// Performs create account action with email verification handling
    /// - Parameter action: The create account action to perform
    @MainActor
    private func performCreateAccountAction(_ action: @escaping () async throws -> User) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await action()
            
            // Success - show email verification sent page
            verificationEmail = user.email
            showEmailVerificationSent = true
            
        } catch let error as AuthenticationError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        isLoading = false
    }
}

// MARK: - Create Account Form

/// Data structure for account creation form
struct CreateAccountForm {
    var fullName = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var agreeToTerms = true
}