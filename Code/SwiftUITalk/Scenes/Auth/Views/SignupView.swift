//
//  SignupView.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showPassword = false
    @State private var showSuccessAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 32) {
            // Title
            VStack(spacing: 8) {
                Text("Get Started 🚀")
                    .font(.largeTitle).bold()
                Text("Create your SwiftUITalk account")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Card-style Form
            VStack(spacing: 16) {
                TextField("Full Name", text: $viewModel.name)
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                    }
                    .textContentType(.password)
                    .autocapitalization(.none)

                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

                if let error = viewModel.authError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.signUp()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal)
        }
        .padding(.top, -100)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Account Created 🎉"),
                message: Text("You can now log in to SwiftUITalk."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onChange(of: viewModel.isAuthenticated) { newValue in
            if newValue {
                showSuccessAlert = true
            }
        }
    }
}

#Preview {
    SignupView()
}
