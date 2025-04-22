//
//  LoginView.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//
// Test Cred
// shubhambairagi294@gmail.com
// Shubh123

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showPassword = false
    @State private var shouldNavigate = false

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // Title
                VStack(spacing: 8) {
                    Text("Welcome back 👋")
                        .font(.largeTitle).bold()
                    Text("Login to continue to SwiftUITalk")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Card-style Form
                VStack(spacing: 16) {
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

                // Login Button
                Button(action: {
                    viewModel.login()
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Login")
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

                // Signup Link
                NavigationLink("Don't have an account? Sign up", destination: SignupView())
                    .font(.footnote)

                
                    .fullScreenCover(isPresented: $shouldNavigate) {
                        ChatTabView()
                    }
            }
            .padding(.top, -100)
            .navigationBarHidden(true)
            .onChange(of: viewModel.isAuthenticated) { newValue in
                if newValue {
                    shouldNavigate = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
