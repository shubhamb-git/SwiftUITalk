//
//  ChatService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//

import Foundation
import FirebaseFirestore

final class ChatService: ChatServiceProtocol {
    private let firestore: FirestoreChatServiceProtocol
    private let local: ChatMessageDataStoreProtocol

    init(firestore: FirestoreChatServiceProtocol = FirestoreService(),
         local: ChatMessageDataStoreProtocol = ChatDataStore.shared) {
        self.firestore = firestore
        self.local = local
    }

    func listenToMessages(
        chatId: String,
        currentUserId: String,
        completion: @escaping ([Message]) -> Void
    ) {
        let cached = local.fetchCachedMessages(for: chatId)
        completion(cached)

        firestore.listenToMessages(chatId: chatId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let messages):
                self.local.saveMessages(messages, for: chatId)
                completion(messages)

                for message in messages {
                    if message.senderId != currentUserId,
                       message.isDelivered == false,
                       let messageId = message.id {
                        self.markMessageAsDelivered(chatId: chatId, messageId: messageId)
                    }
                }

            case .failure(let error):
                print("❌ Firestore listen error:", error.localizedDescription)
            }
        }
    }

    func sendMessage(chatId: String, message: Message, completion: ((Error?) -> Void)? = nil) {
        var message = message

        if message.id == nil {
            message.id = UUID().uuidString
        }

        local.saveMessages([message], for: chatId)

        firestore.sendMessage(chatId: chatId, message: message) { error in
            completion?(error)
        }
    }

    func createChatIfNeeded(chatId: String, participants: [String]) {
        firestore.createChatIfNeeded(chatId: chatId, participants: participants)
    }

    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool) {
        firestore.updateTypingStatus(chatId: chatId, userId: userId, isTyping: isTyping)
    }

    func listenToTypingStatus(
        chatId: String,
        currentUserId: String,
        onTypingChanged: @escaping (Bool) -> Void
    ) {
        firestore.listenToTypingStatus(chatId: chatId, currentUserId: currentUserId, onTypingChanged: onTypingChanged)
    }

    func markMessageAsDelivered(chatId: String, messageId: String) {
        firestore.markMessageAsDelivered(chatId: chatId, messageId: messageId)
        local.updateMessageStatus(chatId: chatId, messageId: messageId, isRead: nil, isDelivered: true)
    }

    func markMessageAsRead(chatId: String, messageId: String) {
        firestore.markMessageAsRead(chatId: chatId, messageId: messageId)
        local.updateMessageStatus(chatId: chatId, messageId: messageId, isRead: true, isDelivered: nil)
    }

    func clearAllData() {
        if let localStore = local as? ChatDataStore {
            localStore.clearAllData()
        }
    }
}
