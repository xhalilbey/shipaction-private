//
//  User.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - User Model

/// Represents a user entity within the application.
/// 
/// This model contains all essential user information including
/// authentication status and profile data. Conforms to `Identifiable`
/// for SwiftUI list operations, `Codable` for JSON serialization,
/// and `Equatable` for comparison operations.
/// Uses Firebase UID as the primary identifier.
struct User: Identifiable, Codable, Equatable {
    /// Unique identifier for the user (Firebase UID)
    let id: String
    
    /// User's email address (used for authentication)
    let email: String
    
    /// User's display name
    let name: String
    
    /// Optional URL to user's profile image
    let profileImageURL: String?
    
    /// Whether the user's email has been verified
    let isEmailVerified: Bool
    
    /// Timestamp when the user account was created
    let createdAt: Date
    
    // MARK: - Initializer
    
    /// Creates a new User instance with the provided information.
    /// 
    /// - Parameters:
    ///   - id: Firebase UID (if not provided, generates UUID for local testing)
    ///   - email: User's email address
    ///   - name: User's display name
    ///   - profileImageURL: Optional profile image URL
    ///   - isEmailVerified: Email verification status (defaults to false)
    init(id: String? = nil, email: String, name: String, profileImageURL: String? = nil, isEmailVerified: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.email = email
        self.name = name
        self.profileImageURL = profileImageURL
        self.isEmailVerified = isEmailVerified
        self.createdAt = Date()
    }
    
    // MARK: - Static Sample Data
    
    /// Sample user instance for SwiftUI previews and testing.
    /// 
    /// - Note: Use this for development purposes only
    static let sampleUser = User(
        email: "demo@payaction.com",
        name: "Demo Kullanıcı",
        isEmailVerified: true
    )
}

// MARK: - Login Credentials

/// Encapsulates user login credentials with validation logic.
/// 
/// This structure provides built-in validation for email format
/// and password strength requirements.
struct LoginCredentials {
    /// User's email address
    var email: String = ""
    
    /// User's password
    var password: String = ""
    
    // MARK: - Validation
    
    /// Determines if both email and password meet validation requirements.
    /// 
    /// - Returns: `true` if both email format and password strength are valid
    var isValid: Bool {
        return ValidationService.isValidEmail(email) && ValidationService.isValidPassword(password)
    }
} 
