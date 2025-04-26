//
//  ProfileViewModel.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var email: String = ""

    private let authService: AuthServicable
    private let sessionManager: UserSessionManagable

    init(authService: AuthServicable = AuthService.shared,
         sessionManager: UserSessionManagable = UserSessionManager.shared) {
        self.authService = authService
        self.sessionManager = sessionManager
        loadCurrentUser()
    }

    func loadCurrentUser() {
        email = authService.currentUserEmail ?? ""
    }

    func logout() {
        do {
            try authService.logout()
            sessionManager.clearSession()
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
