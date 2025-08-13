//
//  LoadableState.swift
//  payaction-ios
//
//  Created by Assistant on 14.08.2025.
//

import Foundation

// MARK: - Loadable State

/// Generic enum representing the loading state of any async operation
/// 
/// Provides a consistent pattern for handling loading, success, and error states
/// across all ViewModels in the application
enum LoadableState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)
    
    // MARK: - Computed Properties
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    var isFailed: Bool {
        if case .failed = self { return true }
        return false
    }
    
    var value: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }
    
    var error: String? {
        if case .failed(let error) = self { return error }
        return nil
    }
}

// MARK: - Convenience Extensions

extension LoadableState {
    /// Maps the loaded value to a new type
    func map<U: Equatable>(_ transform: (T) -> U) -> LoadableState<U> {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case .loaded(let value):
            return .loaded(transform(value))
        case .failed(let error):
            return .failed(error)
        }
    }
    
    /// Returns the loaded value or a default
    func valueOr(_ defaultValue: T) -> T {
        value ?? defaultValue
    }
}
