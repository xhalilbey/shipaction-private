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
    
    private(set) var cartItems: [CartItem] = []
    private(set) var totalAmount: Double = 0.0
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private var hasLoaded = false
    
    // MARK: - Computed Properties
    
    var isEmpty: Bool {
        !isLoading && cartItems.isEmpty
    }
    
    var itemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "$0.00"
    }
    
    // MARK: - Dependencies
    
    private let userRepository: UserRepository
    
    // MARK: - Initialization
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    // MARK: - Actions
    
    @MainActor
    func loadCartItems() async {
        guard !isLoading && !hasLoaded else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            // Mock data - replace with actual repository call
            cartItems = [
                CartItem(
                    name: "GPT-4 API Access",
                    price: 29.99,
                    quantity: 1
                ),
                CartItem(
                    name: "Code Assistant Pro",
                    price: 19.99,
                    quantity: 2
                )
            ]
            calculateTotal()
            hasLoaded = true
        } catch {
            errorMessage = "Failed to load cart items. Please try again."
            print("CartViewModel.loadCartItems error: \(error)")
        }
        
        isLoading = false
    }
    
    @MainActor
    func refreshCart() async {
        errorMessage = nil
        hasLoaded = false
        await loadCartItems()
    }
    
    @MainActor
    private func calculateTotal() {
        totalAmount = cartItems.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    @MainActor
    func removeItem(_ item: CartItem) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else {
            errorMessage = "Item not found in cart"
            return
        }
        
        cartItems.remove(at: index)
        calculateTotal()
        // TODO: Persist to repository
    }
    
    /// Adds item to cart with quantity validation
    @MainActor
    func addItem(_ item: CartItem) {
        guard item.quantity > 0 else {
            errorMessage = "Invalid quantity"
            return
        }
        
        if let existingIndex = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[existingIndex].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
        calculateTotal()
        // TODO: Persist to repository
    }
    
    /// Updates item quantity with validation
    @MainActor
    func updateItemQuantity(_ item: CartItem, quantity: Int) {
        guard quantity >= 0 else {
            errorMessage = "Quantity cannot be negative"
            return
        }
        
        if quantity == 0 {
            removeItem(item)
            return
        }
        
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else {
            errorMessage = "Item not found in cart"
            return
        }
        
        cartItems[index].quantity = quantity
        calculateTotal()
        // TODO: Persist to repository
    }
    
    @MainActor
    func clearCart() {
        cartItems.removeAll()
        totalAmount = 0.0
        // TODO: Persist to repository
    }
    
    func clearError() {
        errorMessage = nil
    }
}