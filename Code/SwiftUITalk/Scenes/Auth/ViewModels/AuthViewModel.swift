//
//  AuthViewModel.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftChatKit

@MainActor
class AuthViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    @Published var authError: String?
    @Published var isLoading = false

    func login() {
        isLoading = true
        authError = nil
        AuthService.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.isAuthenticated = true
                    UserSessionManager.shared.startSession(userId: user.uid)
                    SwiftChat.shared.configure(uid: user.uid)
                case .failure(let error):
                    self?.authError = error.localizedDescription
                }
            }
        }
    }

    func signUp() {
        isLoading = true
        authError = nil

        AuthService.shared.signUp(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.authError = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        do {
            try AuthService.shared.logout()
            isAuthenticated = false
            email = ""
            password = ""
            UserSessionManager.shared.clearSession()
        } catch {
            authError = error.localizedDescription
        }
    }
}
