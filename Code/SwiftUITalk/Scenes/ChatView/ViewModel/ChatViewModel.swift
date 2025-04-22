//
//  ChatViewModel.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import SwiftUI
import SwiftChatKit
import FirebaseAuth

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessage: String = ""
    @Published var isUserTyping = false

    let chatUser: ChatUser
    private(set) var chatId: String = ""
    private var typingTimer: Timer?
    private var readMessages: Set<String> = []

    init(chatUser: ChatUser) {
        self.chatUser = chatUser
        let userCopy = chatUser

        self.chatId = SwiftChat.shared.startChatSession(
            with: userCopy
        ) { [weak self] messages in
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }

        SwiftChat.shared.listenToTypingStatus(with: userCopy) { [weak self] isTyping in
            DispatchQueue.main.async {
                self?.isUserTyping = isTyping
            }
        }
    }

    func sendMessage() {
        let text = newMessage.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        SwiftChat.shared.sendMessage(chatId: chatId, text: text)
        newMessage = ""
    }

    func userStartedTyping() {
        let userCopy = chatUser

        guard !newMessage.isEmpty else { return }
        SwiftChat.shared.updateTypingStatus(with: userCopy, isTyping: true)

        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            SwiftChat.shared.updateTypingStatus(with: userCopy, isTyping: false)
        }
    }

    func markMessageAsReadIfNeeded(message: Message) {
        guard
            message.senderId != AuthService.shared.currentUser?.uid,
            !message.isRead,
            let messageId = message.id,
            !readMessages.contains(messageId)
        else { return }

        SwiftChat.shared.markMessageAsRead(chatId: chatId, messageId: messageId)
        readMessages.insert(messageId)
    }
}
