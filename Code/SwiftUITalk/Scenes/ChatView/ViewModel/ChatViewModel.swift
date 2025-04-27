//
//  ChatViewModel.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
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

    private let chatCoordinator: ChatCoordinator

    init(chatUser: ChatUser, chatCoordinator: ChatCoordinator = SwiftChat.shared) {
        self.chatUser = chatUser
        self.chatCoordinator = chatCoordinator

        let userCopy = chatUser

        self.chatId = chatCoordinator.startChatSession(with: userCopy) { [weak self] messages in
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }

        chatCoordinator.listenToTypingStatus(with: userCopy) { [weak self] isTyping in
            DispatchQueue.main.async {
                self?.isUserTyping = isTyping
            }
        }
    }

    func sendMessage() {
        let text = newMessage.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        chatCoordinator.sendMessage(chatId: chatId, text: text)
        newMessage = ""
    }

    func userStartedTyping() {
        let userCopy = chatUser

        guard !newMessage.isEmpty else { return }
        chatCoordinator.updateTypingStatus(with: userCopy, isTyping: true)

        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {[weak self] _ in
            Task { @MainActor in
                    self?.chatCoordinator.updateTypingStatus(with: userCopy, isTyping: false)
                }
        }
    }

    func markMessageAsReadIfNeeded(message: Message) {
        guard
            message.senderId != AuthService.shared.currentUser?.uid,
            !message.isRead,
            let messageId = message.id,
            !readMessages.contains(messageId)
        else { return }

        chatCoordinator.markMessageAsRead(chatId: chatId, messageId: messageId)
        readMessages.insert(messageId)
    }
}
