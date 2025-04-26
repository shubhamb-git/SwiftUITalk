//
//  MockChatCoordinator.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//
@testable import SwiftChatKit
@testable import SwiftUITalk

class MockChatCoordinator: ChatCoordinator {
    var lastSentText: String?
    var typingUpdates: [Bool] = []
    var readMessageCalls: [(chatId: String, messageId: String)] = []
    var simulatedMessagesCallback: (([Message]) -> Void)?
    var chatId = "mock_chat_123"
    
    func startChatSession(with user: ChatUser, onMessagesUpdate: @escaping ([Message]) -> Void) -> String {
        simulatedMessagesCallback = onMessagesUpdate
        return chatId
    }
    
    func sendMessage(chatId: String, text: String) {
        lastSentText = text
    }
    
    func updateTypingStatus(with user: ChatUser, isTyping: Bool) {
        typingUpdates.append(isTyping)
    }
    
    func listenToTypingStatus(with user: ChatUser, onTypingChanged: @escaping (Bool) -> Void) {
        // Stubbed
    }
    
    func markMessageAsRead(chatId: String, messageId: String) {
        readMessageCalls.append((chatId, messageId))
    }
}
