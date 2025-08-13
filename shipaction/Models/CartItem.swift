//
//  CartItem.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Cart Item Model

/// Model representing an item in the shopping cart
struct CartItem: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let price: Double
    var quantity: Int  // Made mutable for cart operations
    let imageURL: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        price: Double,
        quantity: Int = 1,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.imageURL = imageURL
    }
}