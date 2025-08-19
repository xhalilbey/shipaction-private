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
    
    private(set) var savedItems: [SavedItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private var hasLoaded = false
    
    // Selection mode for batch actions
    private(set) var isSelectionMode = false
    private(set) var selectedIds = Set<String>()
    
    // MARK: - Computed Properties
    
    var isEmpty: Bool {
        !isLoading && savedItems.isEmpty
    }
    
    var itemCount: Int {
        savedItems.count
    }
    
    // MARK: - Dependencies
    
    private let userRepository: UserRepository
    
    // MARK: - Initialization
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    // MARK: - Actions
    
    @MainActor
    func loadSavedItems() async {
        guard !isLoading && !hasLoaded else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network delay for now
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Mock data - replace with actual repository call
            savedItems = [
                SavedItem(
                    title: "GPT-4 Assistant",
                    description: "Advanced AI language model",
                    imageURL: nil
                ),
                SavedItem(
                    title: "Code Reviewer",
                    description: "Automated code review assistant",
                    imageURL: nil
                ),
                SavedItem(
                    title: "Data Analyst",
                    description: "Data analysis and visualization",
                    imageURL: nil
                )
            ]
            hasLoaded = true
        } catch {
            errorMessage = "Failed to load saved items. Please try again."
            print("LibraryViewModel.loadSavedItems error: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func refreshItems() async {
        errorMessage = nil
        
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 500_000_000)
            
            // Refresh logic here
            // For now, just reload
            hasLoaded = false
            await loadSavedItems()
        } catch {
            errorMessage = "Failed to refresh items."
        }
    }
    
    @MainActor
    func removeItem(_ item: SavedItem) {
        savedItems.removeAll { $0.id == item.id }
        // TODO: Persist removal to repository
    }
    
    @MainActor
    func toggleSave(for item: SavedItem) {
        if savedItems.contains(where: { $0.id == item.id }) {
            removeItem(item)
        } else {
            savedItems.append(item)
            // TODO: Persist addition to repository
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Selection API
    func toggleSelectionMode() {
        isSelectionMode.toggle()
        if !isSelectionMode { selectedIds.removeAll() }
    }
    
    func toggleSelection(for item: SavedItem) {
        if selectedIds.contains(item.id) {
            selectedIds.remove(item.id)
        } else {
            selectedIds.insert(item.id)
        }
    }
    
    func deleteSelected() {
        guard !selectedIds.isEmpty else { return }
        savedItems.removeAll { selectedIds.contains($0.id) }
        selectedIds.removeAll()
        // TODO: Persist deletions to repository when backend is ready
    }
}