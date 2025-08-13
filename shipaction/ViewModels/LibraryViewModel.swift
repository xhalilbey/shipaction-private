//
//  LibraryViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Library ViewModel

/// ViewModel for Library/Saved Items tab
@Observable
final class LibraryViewModel {
    
    // MARK: - State
    
    var savedItems: [SavedItem] = []
    var isLoading = false
    
    // MARK: - Dependencies
    
    private let userRepository: UserRepository
    
    // MARK: - Initialization
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    // MARK: - Actions
    
    @MainActor
    func loadSavedItems() async {
        isLoading = true
        isLoading = false
    }
}