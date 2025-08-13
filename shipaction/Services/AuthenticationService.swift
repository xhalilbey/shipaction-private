//
//  AuthenticationService.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

// MARK: - Authentication Service Protocol

/// Protocol defining authentication operations for dependency injection and testing
/// 
/// This protocol enables clean architecture by allowing dependency injection
/// and makes the service easily testable through mock implementations
protocol AuthenticationService {
    /// Authenticates user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated User object
    /// - Throws: AuthenticationError for various failure cases
    func signIn(email: String, password: String) async throws -> User
    
    /// Authenticates user with Google Sign-In
    /// - Returns: Authenticated User object from Google account
    /// - Throws: AuthenticationError for authentication failures
    func signInWithGoogle() async throws -> User
    
    /// Signs out the current user
    /// - Throws: AuthenticationError if sign out fails
    func signOut() async throws
    
    /// Creates a new user account
    /// - Parameters:
    ///   - fullName: User's full name
    ///   - email: User's email address
    ///   - password: User's chosen password
    /// - Returns: Newly created User object
    /// - Throws: AuthenticationError for creation failures
    func createAccount(fullName: String, email: String, password: String) async throws -> User
    

    
    /// Sends password reset email to user
    /// - Parameter email: Email address to send reset link to
    /// - Throws: AuthenticationError if email sending fails
    func sendPasswordResetEmail(email: String) async throws
    
    /// Sends verification email to the currently signed-in user
    /// - Throws: AuthenticationError if there is no user or sending fails
    func sendEmailVerification() async throws
    
    /// Refreshes the current user's authentication token
    /// - Throws: AuthenticationError if refresh fails
    func refreshToken() async throws
    
    /// Checks if current user session is valid and verified
    /// - Returns: Boolean indicating if session is valid
    /// - Throws: AuthenticationError if check fails
    func isSessionValid() async throws -> Bool
}

// MARK: - Authentication Errors

/// Special error type for Google Sign-In cancellation (not shown to user)
struct GoogleSignInCancelled: Error {}

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case networkError
    case userAlreadyExists
    case emailNotVerified
    case weakPassword
    case invalidEmail
    case userNotFound
    case emailAlreadyInUse
    case tooManyRequests
    case operationNotAllowed
    case userDisabled
    case invalidPhoneNumber
    case invalidVerificationCode
    case accountExistsWithDifferentCredential
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "🔐 Email or password is incorrect. Please check your credentials and try again."
        case .networkError:
            return "🌐 Please check your internet connection and try again."
        case .userAlreadyExists, .emailAlreadyInUse:
            return "📧 An account with this email already exists. Try signing in instead."
        case .emailNotVerified:
            return "✉️ Please verify your email address. Check your inbox for the verification link."
        case .weakPassword:
            return "🔒 Your password must be at least 6 characters long and strong."
        case .invalidEmail:
            return "📧 Please enter a valid email address."
        case .userNotFound:
            return "👤 No account found with this email address. Try creating an account."
        case .tooManyRequests:
            return "⏰ Too many attempts. Please wait a few minutes and try again."
        case .operationNotAllowed:
            return "🚫 This operation is not currently allowed. Please try again later."
        case .userDisabled:
            return "⛔ This account has been disabled. Please contact support."
        case .invalidPhoneNumber:
            return "📱 Please enter a valid phone number."
        case .invalidVerificationCode:
            return "🔢 Invalid verification code. Please check and try again."
        case .accountExistsWithDifferentCredential:
            return "🔄 This email is registered with a different sign-in method. Please use that method to sign in."
        case .unknown(let error):
            return "❌ An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}

// MARK: - Live Authentication Service

final class LiveAuthenticationService: AuthenticationService {
    private let userRepository: UserRepository
    private let auth = Auth.auth()
    private let securityManager: SecurityManaging

    init(
        userRepository: UserRepository, 
        securityManager: SecurityManaging = SecurityManager(),
        networkManager: NetworkMonitoring = NetworkManager.shared,
        loggingService: LoggingServiceProtocol = LoggingService.shared
    ) {
        self.userRepository = userRepository
        self.securityManager = securityManager
    }

    // MARK: - Email/Password Authentication

    func signIn(email: String, password: String) async throws -> User {
        // Check internet connection before Firebase operation
        guard NetworkManager.shared.hasInternetConnection() else {
            throw AuthenticationError.networkError
        }
        
        // SECURITY: Check if account is locked due to failed attempts
        if securityManager.isAccountLocked(email: email) {
            let remainingTime = securityManager.getRemainingLockoutTime(email: email)
            throw SecurityManager.SecurityError.accountLocked(remainingTime: remainingTime)
        }
        
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let firebaseUser = authResult.user
            
            // Check if email is verified
            guard firebaseUser.isEmailVerified else {
                // Attempt to send verification email before sign-out so it actually gets delivered
                do {
                    try await firebaseUser.sendEmailVerification()
                    LoggingService.shared.logInfo("Verification email re-sent to: \(email)")
                } catch {
                    LoggingService.shared.logError(error, context: "Resend verification during signIn")
                }
                // Sign out the unverified user
                try auth.signOut()
                throw AuthenticationError.emailNotVerified
            }
            
            let user = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? email,
                name: firebaseUser.displayName ?? "User",
                isEmailVerified: firebaseUser.isEmailVerified
            )
            
            try await userRepository.saveUser(user)
            
            // SECURITY: Reset failed attempts on successful login
            securityManager.resetFailedAttempts(email: email)
            securityManager.startSessionTimer()
            
            LoggingService.shared.logSignInSuccess(email: user.email)
            
            return user
            
        } catch {
            LoggingService.shared.logError(error, context: "Firebase signIn")
            
            // SECURITY: Record failed login attempt
            securityManager.recordFailedLoginAttempt(email: email)
            
            throw mapFirebaseError(error as NSError)
        }
    }

    func createAccount(fullName: String, email: String, password: String) async throws -> User {
        // Check internet connection before Firebase operation
        guard NetworkManager.shared.hasInternetConnection() else {
            throw AuthenticationError.networkError
        }
        
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            let firebaseUser = authResult.user
            
            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            // Send email verification
            try await firebaseUser.sendEmailVerification()
            
            // Sign out the user immediately - they need to verify email first
            try auth.signOut()
            
            let user = User(
                id: firebaseUser.uid,
                email: email,
                name: fullName,
                isEmailVerified: false // Always false for new accounts
            )
            
            LoggingService.shared.logInfo("Account created and verification email sent to: \(email)")
            
            // Don't save user to repository - they're not verified yet
            return user
            
        } catch {
            LoggingService.shared.logError(error, context: "Firebase createUser")
            throw mapFirebaseError(error as NSError)
        }
    }

    // MARK: - Google Sign-In

    @MainActor
    func signInWithGoogle() async throws -> User {
        // Check internet connection before Firebase operation
        guard NetworkManager.shared.hasInternetConnection() else {
            throw AuthenticationError.networkError
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let presentingViewController = window.rootViewController else {
            throw AuthenticationError.unknown(NSError(domain: "NoViewController", code: -1, userInfo: nil))
        }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                throw AuthenticationError.unknown(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"]))
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let authResult = try await auth.signIn(with: credential)
            let firebaseUser = authResult.user
            
            let appUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                name: firebaseUser.displayName ?? user.profile?.name ?? "Google User",
                isEmailVerified: firebaseUser.isEmailVerified
            )
            
            try await userRepository.saveUser(appUser)
            LoggingService.shared.logSignInSuccess(email: appUser.email)
            
            return appUser
            
        } catch {
            // Check if it's a Google Sign-In cancellation first (don't log this as error)
            if let googleError = error as? GIDSignInError {
                switch googleError.code {
                case .canceled:
                    // User cancelled Google Sign-In - this is normal behavior, don't log as error
                    throw GoogleSignInCancelled()
                case .keychain:
                    LoggingService.shared.logError(error, context: "Google Sign-In Keychain")
                    throw AuthenticationError.userNotFound
                default:
                    LoggingService.shared.logError(error, context: "Google Sign-In")
                    throw AuthenticationError.networkError
                }
            }
            
            // Log other types of errors
            LoggingService.shared.logError(error, context: "Google Sign-In")
            
            if let authError = error as NSError? {
                throw mapFirebaseError(authError)
            }
            
            throw AuthenticationError.unknown(error)
        }
    }

    // MARK: - Sign Out

    func signOut() async throws {
        // Check internet connection before Firebase operation
        guard NetworkManager.shared.hasInternetConnection() else {
            throw AuthenticationError.networkError
        }
        
        do {
            try auth.signOut()
            try await userRepository.clearUserData()
            
            // SECURITY: Stop session timer and clear security state
            securityManager.stopSessionTimer()
            
            LoggingService.shared.logSignOut()
        } catch {
            LoggingService.shared.logError(error, context: "Firebase signOut")
            throw AuthenticationError.unknown(error)
        }
    }

    // MARK: - Token Management
    
    /// Refreshes the current user's authentication token
    /// 
    /// Should be called periodically to maintain valid session
    func refreshToken() async throws {
        guard let currentUser = auth.currentUser else {
            throw AuthenticationError.userNotFound
        }
        
        do {
            // Force token refresh using continuation
            let _: String = try await withCheckedThrowingContinuation { continuation in
                currentUser.getIDTokenForcingRefresh(true) { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: token ?? "")
                    }
                }
            }
            LoggingService.shared.logInfo("Token refreshed successfully for user: \(currentUser.email ?? "unknown")")
        } catch {
            LoggingService.shared.logError(error, context: "Token refresh")
            throw mapFirebaseError(error as NSError)
        }
    }
    
    /// Checks if current user session is valid and verified
    /// 
    /// - Returns: true if user is authenticated and email is verified
    func isSessionValid() async throws -> Bool {
        guard let currentUser = auth.currentUser else {
            return false
        }
        
        // Reload user to get latest verification status
        try await currentUser.reload()
        
        return currentUser.isEmailVerified
    }

    // MARK: - Password Reset

    func sendPasswordResetEmail(email: String) async throws {
        // Check internet connection before Firebase operation
        guard NetworkManager.shared.hasInternetConnection() else {
            throw AuthenticationError.networkError
        }
        
        do {
            try await auth.sendPasswordReset(withEmail: email)
            LoggingService.shared.logInfo("Password reset email sent to: \(email)")
        } catch {
            LoggingService.shared.logError(error, context: "Password reset")
            throw mapFirebaseError(error as NSError)
        }
    }

    // MARK: - Email Verification
    func sendEmailVerification() async throws {
        guard let currentUser = auth.currentUser else {
            throw AuthenticationError.userNotFound
        }
        do {
            try await currentUser.sendEmailVerification()
            LoggingService.shared.logInfo("Verification email sent to: \(currentUser.email ?? "unknown")")
        } catch {
            LoggingService.shared.logError(error, context: "sendEmailVerification")
            throw mapFirebaseError(error as NSError)
        }
    }



    // MARK: - Error Mapping

    private func mapFirebaseError(_ error: NSError) -> AuthenticationError {
        guard let authErrorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknown(error)
        }

        switch authErrorCode {
        case .userNotFound:
            return .userNotFound
        case .wrongPassword, .invalidCredential:
            return .invalidCredentials
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmail
        case .weakPassword:
            return .weakPassword
        case .networkError:
            return .networkError
        case .userDisabled:
            return .userDisabled
        case .tooManyRequests:
            return .tooManyRequests
        case .operationNotAllowed:
            return .operationNotAllowed
        case .invalidPhoneNumber:
            return .invalidPhoneNumber
        case .invalidVerificationCode:
            return .invalidVerificationCode
        case .accountExistsWithDifferentCredential:
            return .accountExistsWithDifferentCredential
        default:
            return .unknown(error)
        }
    }
}