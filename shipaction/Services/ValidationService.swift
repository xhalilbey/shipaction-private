//
//  ValidationService.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Validation Service

/// Centralized validation logic for form inputs and user data.
/// 
/// Provides reusable validation methods for common input types
/// including email addresses, passwords, names, and other user data.
/// All validation rules are centralized for consistency across the app.
struct ValidationService {
    
    // MARK: - Email Validation
    
    /// Validates email address format using regular expression.
    /// 
    /// - Parameter email: Email address string to validate
    /// - Returns: `true` if email format is valid, `false` otherwise
    /// 
    /// Example usage:
    /// ```swift
    /// let isValid = ValidationService.isValidEmail("user@example.com") // true
    /// let isInvalid = ValidationService.isValidEmail("invalid-email") // false
    /// ```
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
    
    /// Returns email validation error message if invalid.
    /// 
    /// - Parameter email: Email address to validate
    /// - Returns: Error message string or nil if valid
    static func emailValidationMessage(for email: String) -> String? {
        guard !email.isEmpty else { return nil }
        return isValidEmail(email) ? nil : "Please enter a valid email address"
    }
    
    // MARK: - Password Validation
    
    /// Validates password meets minimum security requirements.
    /// 
    /// - Parameter password: Password string to validate
    /// - Returns: `true` if password meets requirements, `false` otherwise
    /// 
    /// Current requirements:
    /// - Minimum 6 characters length
    /// 
    /// - Note: Consider implementing stronger requirements in production
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    /// Returns password validation error message if invalid.
    /// 
    /// - Parameter password: Password to validate
    /// - Returns: Error message string or nil if valid
    static func passwordValidationMessage(for password: String) -> String? {
        guard !password.isEmpty else { return nil }
        return isValidPassword(password) ? nil : "Password must be at least 6 characters"
    }
    
    /// Validates password confirmation matches original password.
    /// 
    /// - Parameters:
    ///   - password: Original password
    ///   - confirmPassword: Confirmation password to compare
    /// - Returns: `true` if passwords match and are valid, `false` otherwise
    static func isValidConfirmPassword(_ confirmPassword: String, matching password: String) -> Bool {
        return confirmPassword == password && !password.isEmpty
    }
    
    /// Returns password confirmation validation error message if invalid.
    /// 
    /// - Parameters:
    ///   - confirmPassword: Confirmation password to validate
    ///   - password: Original password to match against
    /// - Returns: Error message string or nil if valid
    static func confirmPasswordValidationMessage(for confirmPassword: String, matching password: String) -> String? {
        guard !confirmPassword.isEmpty else { return nil }
        return isValidConfirmPassword(confirmPassword, matching: password) ? nil : "Passwords do not match"
    }
    
    // MARK: - Name Validation
    
    /// Validates full name meets minimum requirements.
    /// 
    /// - Parameter fullName: Full name string to validate
    /// - Returns: `true` if name is valid, `false` otherwise
    /// 
    /// Requirements:
    /// - Minimum 2 characters after trimming whitespace
    static func isValidFullName(_ fullName: String) -> Bool {
        return fullName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
    
    /// Returns full name validation error message if invalid.
    /// 
    /// - Parameter fullName: Full name to validate
    /// - Returns: Error message string or nil if valid
    static func fullNameValidationMessage(for fullName: String) -> String? {
        guard !fullName.isEmpty else { return nil }
        return isValidFullName(fullName) ? nil : "Please enter your full name"
    }
}