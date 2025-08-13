//
//  EmailVerificationSentSheet.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - Email Verification Sent Sheet

/// Modern email verification sent confirmation sheet
/// 
/// Shows success message after account creation and guides user to check email
/// Similar design to forgot password sheet for consistency
struct EmailVerificationSentSheet: View {
    
    // MARK: - Properties
    
    let email: String
    let onBackToLogin: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with success animation
                        VStack(spacing: 32) {
                            // Success Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [AppConstants.Colors.success, AppConstants.Colors.success.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isAnimating)
                                
                                Image(systemName: "envelope.badge.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundStyle(.white)
                                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)
                            }
                            .shadow(color: AppConstants.Colors.success.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            // Success Message
                            VStack(spacing: 16) {
                                Text("Verification Email Sent!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.center)
                                
                                VStack(spacing: 8) {
                                    Text("To verify your account, please")
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(email)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(AppConstants.Colors.primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(AppConstants.Colors.primary.opacity(0.1))
                                        )
                                    
                                    Text("check the verification link sent to this address.")
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                                .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                        
                        // Instructions
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Next Steps:")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                InstructionRow(
                                    number: "1",
                                    text: "Check your email inbox"
                                )
                                
                                InstructionRow(
                                    number: "2", 
                                    text: "Click the verification link"
                                )
                                
                                InstructionRow(
                                    number: "3",
                                    text: "Sign in and start using the app"
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            // Back to Login Button
                            Button(action: {
                                onBackToLogin()
                                dismiss()
                            }) {
                                Text("Back to Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .foregroundStyle(.white)
                                    .background(AppConstants.Colors.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            
                            // Help Text
                            Text("Didn't receive the email? Check your spam folder.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 32))
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(AppConstants.Colors.primary)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Instruction Row Component

/// Individual instruction step component
private struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Step Number
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(AppConstants.Colors.primary)
                )
            
            // Step Text
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    EmailVerificationSentSheet(
        email: "demo@payaction.com",
        onBackToLogin: {}
    )
}