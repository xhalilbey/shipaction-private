//
//  ForgotPasswordSheet.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

struct ForgotPasswordSheet: View {
    @State var viewModel: AuthenticationViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AuthenticationViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEmailFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.forgotPasswordSent {
                    successView
                } else {
                    forgotPasswordForm
                }
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear {
            viewModel.resetForgotPasswordState()
        }
    }
    
    // MARK: - Success View
    
    private var successView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success Icon (brand aligned)
            ZStack {
                Circle()
                    .fill(AppConstants.Colors.primary.opacity(0.08))
                    .frame(width: 90, height: 90)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 44))
                    .foregroundColor(AppConstants.Colors.primary)
            }
            
            // Success Message
            VStack(spacing: 16) {
                Text("Email Sent!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("We've sent password reset instructions to")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.forgotPasswordEmail)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Check your email and follow the link to reset your password.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Done Button (Unified)
            UnifiedButton(title: "Done", style: .primary) {
                dismiss()
            }
            .frame(height: 50)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Forgot Password Form
    
    private var forgotPasswordForm: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "lock.rotation")
                    .font(.system(size: 48))
                    .foregroundColor(AppConstants.Colors.primary)
                
                VStack(spacing: 8) {
                    Text("Forgot your password?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Enter your email address and we'll send you instructions to reset your password.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            
            // Email Input and Button
            VStack(spacing: 24) {
                CustomTextField(
                    title: "Email Address",
                    placeholder: "Enter your email address",
                    text: $viewModel.forgotPasswordEmail,
                    type: .email,
                    validationMessage: viewModel.forgotPasswordError,
                    showValidation: viewModel.forgotPasswordError != nil
                )
                .focused($isEmailFocused)
                .submitLabel(.send)
                
                // Send Button
                Button(action: {
                    Task {
                        await viewModel.sendForgotPasswordEmail()
                    }
                }) {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .controlSize(.small)
                                .tint(.white)
                        }
                        Text("Send Reset Instructions")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background(
                        viewModel.forgotPasswordEmail.isEmpty ? 
                        Color.gray.opacity(0.3) : AppConstants.Colors.primary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(viewModel.forgotPasswordEmail.isEmpty || viewModel.isLoading)
                
                // Back to Sign In
                Button("Back to Sign In") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.primary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .onSubmit {
            if !viewModel.forgotPasswordEmail.isEmpty {
                Task {
                    await viewModel.sendForgotPasswordEmail()
                }
            }
        }
        .task {
            // Focus email field when sheet appears
            isEmailFocused = true
        }
    }
}

#Preview {
    let navigationManager = NavigationManager()
    let dependencies = DependencyContainer(navigationManager: navigationManager)
    
    return ForgotPasswordSheet(viewModel: dependencies.makeAuthenticationViewModel())
}