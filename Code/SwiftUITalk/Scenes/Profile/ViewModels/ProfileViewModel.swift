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

    init() {
        loadCurrentUser()
    }

    func loadCurrentUser() {
        email = AuthService.shared.currentUser?.email ?? ""
    }

    func logout() {
        do {
            try AuthService.shared.logout()
            UserSessionManager.shared.clearSession()
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
