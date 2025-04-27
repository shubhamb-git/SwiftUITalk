//
//  MockChatService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation
@testable import SwiftChatKit

class MockChatService: ChatServiceProtocol {
    var createdChatIds: [String] = []
    var sentMessages: [(chatId: String, message: Message)] = []
    var markedAsReadMessages: [(chatId: String, messageId: String)] = []
    var typingUpdates: [(chatId: String, isTyping: Bool)] = []
    var listenedChatIds: [String] = []
    var didClearData = false

    func createChatIfNeeded(chatId: String, participants: [String]) {
        createdChatIds.append(chatId)
    }

    func listenToMessages(chatId: String, currentUserId: String, completion: @escaping ([Message]) -> Void) {
        listenedChatIds.append(chatId)
        completion([])
    }

    func sendMessage(chatId: String, message: Message, completion: ((Error?) -> Void)?) {
        sentMessages.append((chatId, message))
        completion?(nil)
    }

    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool) {
        typingUpdates.append((chatId, isTyping))
    }

    func listenToTypingStatus(chatId: String, currentUserId: String, onTypingChanged: @escaping (Bool) -> Void) {
        listenedChatIds.append(chatId)
    }

    func markMessageAsRead(chatId: String, messageId: String) {
        markedAsReadMessages.append((chatId, messageId))
    }

    func clearAllData() {
        didClearData = true
    }
}
