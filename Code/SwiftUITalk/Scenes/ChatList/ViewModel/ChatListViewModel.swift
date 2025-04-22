//
//  ChatListViewModel.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//


import SwiftUI
import SwiftChatKit
import FirebaseAuth

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var users: [ChatUser] = []
    @Published var isLoading = false

    func loadUsers() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        isLoading = true
        SwiftChat.shared.fetchUsers(excluding: currentUid) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.users = result
            }
        }
    }
}
