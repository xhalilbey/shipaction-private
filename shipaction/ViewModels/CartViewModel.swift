//
//  CartViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import Observation

// MARK: - Cart ViewModel

/// ViewModel for Shopping Cart tab
@Observable
final class CartViewModel {
    
    // MARK: - State
    
    var cartItems: [CartItem] = []
    var totalAmount: Double = 0.0
    var isLoading = false
    
    // MARK: - Dependencies
    
    private let userRepository: UserRepository
    
    // MARK: - Initialization
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    // MARK: - Actions
    
    @MainActor
    func loadCartItems() async {
        isLoading = true
        calculateTotal()
        isLoading = false
    }
    
    @MainActor
    private func calculateTotal() {
        totalAmount = cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    @MainActor
    func removeItem(_ item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
        calculateTotal()
    }
    
    /// Adds item to cart with quantity validation
    @MainActor
    func addItem(_ item: CartItem) {
        if let existingIndex = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[existingIndex].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
        calculateTotal()
    }
    
    /// Updates item quantity with validation
    @MainActor
    func updateItemQuantity(_ item: CartItem, quantity: Int) {
        guard quantity > 0 else {
            removeItem(item)
            return
        }
        
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = quantity
            calculateTotal()
        }
    }
}