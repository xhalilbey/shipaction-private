//
//  UserRepository.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import FirebaseAuth

// MARK: - User Repository Protocol

/// Protocol defining user data persistence operations
protocol UserRepository {
    func saveUser(_ user: User) async throws
    func loadUser() async throws -> User?
    func clearUserData() async throws
    func clearUser() async throws
    func isOnboardingCompleted() async -> Bool
    func setOnboardingCompleted(_ completed: Bool) async
}

// MARK: - Repository Error

/// Custom errors for repository operations
enum RepositoryError: LocalizedError {
    case saveFailed
    case loadFailed
    case dataNotFound
    case corruptedData
    case unauthorized
    case networkError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .dataNotFound:
            return "Data not found"
        case .corruptedData:
            return "Data is corrupted"
        case .unauthorized:
            return "User not authorized"
        case .networkError:
            return "Network connection failed"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - User Repository Implementation

/// Concrete implementation of user data repository using local storage only
/// 
/// Handles user data persistence using UserDefaults for local storage.
/// Firebase Auth handles user authentication, local storage handles user data.
/// Separated from business logic for better testability and maintainability.
final class LiveUserRepository: UserRepository {
    
    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    // MARK: - Storage Keys
    
    private enum StorageKey {
        static let currentUser = "shipaction.current_user"
        static let onboardingCompleted = "shipaction.onboarding_completed"
    }
    
    // MARK: - Initialization
    
    /// Initializes repository with UserDefaults for local storage
    /// 
    /// - Parameter userDefaults: UserDefaults instance for local data storage
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    // MARK: - User Data Methods
    
    /// Saves user data to local storage
    /// 
    /// - Parameter user: User object to save
    /// - Throws: RepositoryError.saveFailed if encoding or saving fails
    func saveUser(_ user: User) async throws {
        do {
            let data = try encoder.encode(user)
            userDefaults.set(data, forKey: StorageKey.currentUser)
            LoggingService.shared.logDataSave(entity: "User (local)")
        } catch {
            LoggingService.shared.logError(error, context: "Saving user data locally")
            throw RepositoryError.saveFailed
        }
    }
    
    /// Loads user data from local storage
    /// 
    /// - Returns: User object if found, nil otherwise
    /// - Throws: RepositoryError if data is corrupted or loading fails
    func loadUser() async throws -> User? {
        // Load from local storage
        guard let data = userDefaults.data(forKey: StorageKey.currentUser) else {
            return nil
        }
        
        do {
            let user = try decoder.decode(User.self, from: data)
            LoggingService.shared.logDataLoad(entity: "User (local)")
            return user
        } catch {
            LoggingService.shared.logError(error, context: "Loading user from local storage")
            throw RepositoryError.corruptedData
        }
    }
    
    /// Clears all user data from local storage
    /// 
    /// Removes both user data and onboarding completion status
    func clearUserData() async throws {
        userDefaults.removeObject(forKey: StorageKey.currentUser)
        userDefaults.removeObject(forKey: StorageKey.onboardingCompleted)
        LoggingService.shared.logDataSave(entity: "User data cleared (local)")
    }
    
    /// Clears user data from local storage only
    /// 
    /// Removes user data but keeps onboarding completion status
    func clearUser() async throws {
        userDefaults.removeObject(forKey: StorageKey.currentUser)
        LoggingService.shared.logDataSave(entity: "User cleared (local)")
    }
    
    // MARK: - Onboarding Methods
    
    /// Checks if user has completed onboarding
    /// 
    /// - Returns: true if onboarding is completed, false otherwise
    func isOnboardingCompleted() async -> Bool {
        return userDefaults.bool(forKey: StorageKey.onboardingCompleted)
    }
    
    /// Sets onboarding completion status
    /// 
    /// - Parameter completed: Completion status to set
    func setOnboardingCompleted(_ completed: Bool) async {
        userDefaults.set(completed, forKey: StorageKey.onboardingCompleted)
    }
}
