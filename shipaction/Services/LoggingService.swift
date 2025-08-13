//
//  LoggingService.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import os.log

// MARK: - Logging Service Protocol

/// Protocol defining logging capabilities for dependency injection
protocol LoggingServiceProtocol {
    func logInfo(_ message: String)
    func logSignInSuccess(email: String)
    func logError(_ error: Error, context: String)
    func logWarning(_ message: String, context: String)
    func logNetworkRequest(url: String, method: String)
    func logNetworkResponse(url: String, statusCode: Int)
    func logDataOperation(operation: String, success: Bool)
    func logDataSave(entity: String)
    func logDataLoad(entity: String)
    func logUserDataCleared()
    func logNavigation(to destination: String)
    func logTabSelection(tab: String)
    func logButtonTap(button: String)
    func logViewAppeared(view: String)
}

// MARK: - Logging Service

/// Centralized logging service for the application
/// 
/// Provides structured logging with different levels and categories.
/// Automatically handles production vs development logging differences.
final class LoggingService: LoggingServiceProtocol {
    
    // MARK: - Shared Instance
    
    static let shared = LoggingService()
    
    // MARK: - Logger Categories
    
    private let authLogger = Logger(subsystem: "com.payaction.ios", category: "Authentication")
    private let navigationLogger = Logger(subsystem: "com.payaction.ios", category: "Navigation")
    private let dataLogger = Logger(subsystem: "com.payaction.ios", category: "Data")
    private let uiLogger = Logger(subsystem: "com.payaction.ios", category: "UI")
    private let networkLogger = Logger(subsystem: "com.payaction.ios", category: "Network")
    private let errorLogger = Logger(subsystem: "com.payaction.ios", category: "Error")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Protocol simple wrappers
    
    /// Protocol-required info logging without category
    /// Kept here (inside the type) to avoid any incremental-build flicker
    func logInfo(_ message: String) {
        authLogger.info("\(message)")
    }
    
    // MARK: - Authentication Logging
    
    func logAuthSuccess(method: String) {
        authLogger.info("Authentication successful: \(method)")
    }
    
    func logSignInSuccess(email: String) {
        let maskedEmail = maskEmail(email)
        authLogger.info("Sign in successful for: \(maskedEmail)")
    }
    
    func logAuthFailure(method: String, error: String) {
        authLogger.error("Authentication failed: \(method) - \(error)")
    }
    
    func logPasswordReset(email: String) {
        // Don't log full email in production for privacy
        let maskedEmail = maskEmail(email)
        authLogger.info("Password reset requested for: \(maskedEmail)")
    }
    
    func logSignOut() {
        authLogger.info("User signed out")
    }
    
    // MARK: - Data Logging
    
    func logDataOperation(operation: String, success: Bool) {
        if success {
            dataLogger.info("Data operation successful: \(operation)")
        } else {
            dataLogger.error("Data operation failed: \(operation)")
        }
    }
    
    func logDataSave(entity: String) {
        dataLogger.info("Data saved: \(entity)")
    }
    
    func logDataLoad(entity: String) {
        dataLogger.info("Data loaded: \(entity)")
    }
    
    func logUserDataCleared() {
        dataLogger.info("User data cleared")
    }
    
    // MARK: - Navigation Logging
    
    func logNavigation(to destination: String) {
        navigationLogger.debug("Navigating to: \(destination)")
    }
    
    func logTabSelection(tab: String) {
        navigationLogger.debug("Tab selected: \(tab)")
    }
    
    // MARK: - UI Logging
    
    func logButtonTap(button: String) {
        uiLogger.debug("Button tapped: \(button)")
    }
    
    func logViewAppeared(view: String) {
        uiLogger.debug("View appeared: \(view)")
    }
    
    // MARK: - Error Logging
    
    func logError(_ error: Error, context: String) {
        errorLogger.error("Error in \(context): \(error.localizedDescription)")
    }
    
    func logWarning(_ message: String, context: String) {
        errorLogger.warning("Warning in \(context): \(message)")
    }
    
    // MARK: - Network Logging
    
    func logNetworkRequest(url: String, method: String) {
        networkLogger.debug("Network request: \(method) \(url)")
    }
    
    func logNetworkResponse(url: String, statusCode: Int) {
        networkLogger.info("Network response: \(url) - Status: \(statusCode)")
    }
    
    // MARK: - Privacy Helpers
    
    /// Masks email for privacy-compliant logging
    private func maskEmail(_ email: String) -> String {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else { return "invalid@email.com" }
        
        let username = components[0]
        let domain = components[1]
        
        let maskedUsername = username.count > 2 ? 
            String(username.prefix(2)) + "***" : 
            "***"
        
        return "\(maskedUsername)@\(domain)"
    }
}

// MARK: - Log Level Extensions

extension LoggingService {
    /// Development-only logging that won't appear in production
    func logDebug(_ message: String, category: LogCategory = .general) {
        #if DEBUG
        print("🐛 DEBUG [\(category.rawValue)]: \(message)")
        #endif
    }
    
    /// Information logging for important events
    func logInfo(_ message: String, category: LogCategory = .general) {
        let logger = loggerForCategory(category)
        logger.info("\(message)")
    }
    
    /// Warning logging for non-critical issues
    func logWarning(_ message: String, category: LogCategory = .general) {
        let logger = loggerForCategory(category)
        logger.warning("\(message)")
    }
    
    /// Error logging for critical issues
    func logError(_ message: String, category: LogCategory = .general) {
        let logger = loggerForCategory(category)
        logger.error("\(message)")
    }
    
    private func loggerForCategory(_ category: LogCategory) -> Logger {
        switch category {
        case .authentication: return authLogger
        case .navigation: return navigationLogger
        case .data: return dataLogger
        case .ui: return uiLogger
        case .network: return networkLogger
        case .error: return errorLogger
        case .performance: return uiLogger // Use UI logger for performance
        case .general: return authLogger // Default
        }
    }
}

// MARK: - Log Categories

enum LogCategory: String {
    case authentication = "Auth"
    case navigation = "Nav"
    case data = "Data"
    case ui = "UI"
    case network = "Net"
    case error = "Error"
    case performance = "Performance"
    case general = "General"
}