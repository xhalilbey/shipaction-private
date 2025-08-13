//
//  Transaction.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Transaction Models

/// Account balance information for dashboard
struct AccountBalance {
    let totalBalance: Double
    let monthlyIncome: Double
    let monthlyExpenses: Double
}

/// Transaction data model for dashboard display
struct Transaction: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let amount: Double
    let icon: String
    let date: Date
    
    /// Formatted amount string with currency
    var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : ""
        return "\(prefix)₺\(String(format: "%.2f", abs(amount)))"
    }
    
    /// Color for amount display
    var amountColor: String {
        return amount >= 0 ? "green" : "red"
    }
}