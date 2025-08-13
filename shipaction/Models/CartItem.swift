//
//  CartItem.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Cart Item Model

/// Model representing an item in the shopping cart
struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    var quantity: Int  // Made mutable for cart operations
    let imageURL: String?
}