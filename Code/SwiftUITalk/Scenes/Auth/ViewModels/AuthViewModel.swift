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

    private let authService: AuthServicable
    private let sessionManager: UserSessionManagable
    private let chatConfigurable: ChatConfigurable
    
    init(authService: AuthServicable = AuthService.shared,
         sessionManager: UserSessionManagable = UserSessionManager.shared,
         chatConfigurable: ChatConfigurable = SwiftChat.shared) {
        self.authService = authService
        self.sessionManager = sessionManager
        self.chatConfigurable = chatConfigurable
    }
    
    func login() {
        isLoading = true
        authError = nil
        authService.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let userId):
                    self.isAuthenticated = true
                    self.sessionManager.startSession(userId: userId)
                    self.chatConfigurable.configure(uid: userId)
                case .failure(let error):
                    self.authError = error.localizedDescription
                }
            }
        }
    }

    func signUp() {
        isLoading = true
        authError = nil

        authService.signUp(name: name, email: email, password: password) { [weak self] result in
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
            try authService.logout()
            isAuthenticated = false
            email = ""
            password = ""
            self.sessionManager.clearSession()
        } catch {
            authError = error.localizedDescription
        }
    }
}
