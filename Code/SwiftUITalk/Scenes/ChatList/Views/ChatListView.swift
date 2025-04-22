//
//  ChatListView.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import SwiftUI
import SwiftChatKit

struct ChatListView: View {
    @StateObject private var viewModel = ChatListViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading chats...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.users.isEmpty {
                    Text("No users found 💤")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: ChatView(chatUser: user)) {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Text(user.name.prefix(1).uppercased())
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.name)
                                        .font(.headline)
                                    Text(user.email)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Chats")
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
}
