//
//  ChatListViewModel.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//


import SwiftUI
import SwiftChatKit
import FirebaseAuth

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var users: [ChatUser] = []
    @Published var isLoading = false

    private let userCoordinator: ChatUserCoordinator
    private let authService: AuthServicable

    init(authService: AuthServicable = AuthService.shared,
         userCoordinator: ChatUserCoordinator = SwiftChat.shared) {
        self.userCoordinator = userCoordinator
        self.authService = authService
    }
    
    func loadUsers() {
        guard let currentUid = authService.currentUserId else { return }

        isLoading = true
        userCoordinator.fetchUsers(excluding: currentUid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.users = result
            }
        }
    }
}
