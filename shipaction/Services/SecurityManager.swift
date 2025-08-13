//
//  SecurityManager.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Security Manager Protocol

/// Protocol defining security operations for the application
protocol SecurityManaging {
    func recordFailedLoginAttempt(email: String)
    func isAccountLocked(email: String) -> Bool
    func resetFailedAttempts(email: String)
    func getRemainingLockoutTime(email: String) -> TimeInterval
    func startSessionTimer()
    func stopSessionTimer()
    func isSessionExpired() -> Bool
    var onSessionExpired: (() -> Void)? { get set }
}

// MARK: - Security Manager

/// Manages security features like rate limiting, account lockout, and session timeout
@Observable
final class SecurityManager: SecurityManaging {
    
    // MARK: - Constants
    
    private enum SecurityConstants {
        static let maxFailedAttempts = 5
        static let lockoutDuration: TimeInterval = 15 * 60 // 15 minutes
        static let sessionTimeout: TimeInterval = 30 * 60 // 30 minutes
    }
    
    // MARK: - Properties
    
    private var failedAttempts: [String: Int] = [:]
    private var lockoutTimes: [String: Date] = [:]
    private var lastActivityTime: Date = Date()
    private var sessionTimer: Timer?
    
    /// Callback for session expiration
    var onSessionExpired: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        startSessionTimer()
    }
    
    deinit {
        stopSessionTimer()
    }
    
    // MARK: - Rate Limiting & Account Lockout
    
    /// Records a failed login attempt for the given email
    /// - Parameter email: Email address that failed authentication
    func recordFailedLoginAttempt(email: String) {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        failedAttempts[normalizedEmail, default: 0] += 1
        
        if failedAttempts[normalizedEmail, default: 0] >= SecurityConstants.maxFailedAttempts {
            lockoutTimes[normalizedEmail] = Date()
            print("Account locked due to failed attempts: \(normalizedEmail)")
        }
    }
    
    /// Checks if an account is currently locked
    /// - Parameter email: Email address to check
    /// - Returns: true if account is locked, false otherwise
    func isAccountLocked(email: String) -> Bool {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let lockoutTime = lockoutTimes[normalizedEmail] else {
            return false
        }
        
        let timeSinceLockout = Date().timeIntervalSince(lockoutTime)
        
        if timeSinceLockout >= SecurityConstants.lockoutDuration {
            // Lockout period expired, remove lockout
            lockoutTimes.removeValue(forKey: normalizedEmail)
            failedAttempts.removeValue(forKey: normalizedEmail)
            return false
        }
        
        return true
    }
    
    /// Resets failed login attempts for successful authentication
    /// - Parameter email: Email address to reset
    func resetFailedAttempts(email: String) {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        failedAttempts.removeValue(forKey: normalizedEmail)
        lockoutTimes.removeValue(forKey: normalizedEmail)
    }
    
    /// Gets remaining lockout time for an email
    /// - Parameter email: Email to check
    /// - Returns: Remaining lockout time in seconds, 0 if not locked
    func getRemainingLockoutTime(email: String) -> TimeInterval {
        let normalizedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let lockoutTime = lockoutTimes[normalizedEmail] else {
            return 0
        }
        
        let timeSinceLockout = Date().timeIntervalSince(lockoutTime)
        let remainingTime = SecurityConstants.lockoutDuration - timeSinceLockout
        
        return max(0, remainingTime)
    }
    
    // MARK: - Session Management
    
    /// Starts the session timeout timer
    func startSessionTimer() {
        stopSessionTimer() // Stop any existing timer
        lastActivityTime = Date()
        
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkSessionTimeout()
        }
    }
    
    /// Stops the session timeout timer
    func stopSessionTimer() {
        sessionTimer?.invalidate()
        sessionTimer = nil
    }
    
    /// Updates last activity time to extend session
    func recordActivity() {
        lastActivityTime = Date()
    }
    
    /// Checks if current session has expired
    /// - Returns: true if session expired, false otherwise
    func isSessionExpired() -> Bool {
        let timeSinceLastActivity = Date().timeIntervalSince(lastActivityTime)
        return timeSinceLastActivity >= SecurityConstants.sessionTimeout
    }
    
    /// Internal method to check session timeout
    private func checkSessionTimeout() {
        if isSessionExpired() {
            print("Session expired due to inactivity")
            onSessionExpired?()
        }
    }
    
    // MARK: - Security Errors
    
    enum SecurityError: LocalizedError {
        case accountLocked(remainingTime: TimeInterval)
        case sessionExpired
        case tooManyAttempts
        
        var errorDescription: String? {
            switch self {
            case .accountLocked(let remainingTime):
                let minutes = Int(remainingTime / 60)
                return "🔒 Account temporarily locked. Try again in \(minutes) minutes."
            case .sessionExpired:
                return "⏰ Session expired. Please sign in again."
            case .tooManyAttempts:
                return "⚠️ Too many failed attempts. Please wait a few minutes."
            }
        }
    }
}