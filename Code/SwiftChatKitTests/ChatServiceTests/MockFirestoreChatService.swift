//
//  MockFirestoreChatService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

@testable import SwiftChatKit

final class MockFirestoreChatService: FirestoreChatServiceProtocol {
    var listenMessagesCalled = false
    var sendMessageCalled = false
    var createChatCalled = false
    var typingStatusUpdates: [(chatId: String, userId: String, isTyping: Bool)] = []
    var deliveredUpdates: [(chatId: String, messageId: String)] = []
    var readUpdates: [(chatId: String, messageId: String)] = []

    func listenToMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        listenMessagesCalled = true
        completion(.success([]))
    }

    func sendMessage(chatId: String, message: Message, completion: @escaping (Error?) -> Void) {
        sendMessageCalled = true
        completion(nil)
    }

    func createChatIfNeeded(chatId: String, participants: [String]) {
        createChatCalled = true
    }

    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool) {
        typingStatusUpdates.append((chatId, userId, isTyping))
    }

    func listenToTypingStatus(chatId: String, currentUserId: String, onTypingChanged: @escaping (Bool) -> Void) {
        onTypingChanged(true) // simulate someone typing
    }

    func markMessageAsDelivered(chatId: String, messageId: String) {
        deliveredUpdates.append((chatId, messageId))
    }

    func markMessageAsRead(chatId: String, messageId: String) {
        readUpdates.append((chatId, messageId))
    }
}
