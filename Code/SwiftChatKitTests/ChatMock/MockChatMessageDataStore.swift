//
//  MockChatMessageDataStore.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

@testable import SwiftChatKit

final class MockChatMessageDataStore: ChatMessageDataStoreProtocol {
    var savedMessages: [(messages: [Message], chatId: String)] = []
    var updatedStatuses: [(chatId: String, messageId: String, isRead: Bool?, isDelivered: Bool?)] = []

    func saveMessages(_ messages: [Message], for chatId: String) {
        savedMessages.append((messages, chatId))
    }

    func fetchCachedMessages(for chatId: String) -> [Message] {
        return []
    }

    func updateMessageStatus(chatId: String, messageId: String, isRead: Bool?, isDelivered: Bool?) {
        updatedStatuses.append((chatId, messageId, isRead, isDelivered))
    }
}
