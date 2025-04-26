//
//  ChatCoordinator.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//

import Foundation

public protocol ChatCoordinator {
    func startChatSession(with user: ChatUser, onMessagesUpdate: @escaping ([Message]) -> Void) -> String
    func sendMessage(chatId: String, text: String)
    func updateTypingStatus(with user: ChatUser, isTyping: Bool)
    func listenToTypingStatus(with user: ChatUser, onTypingChanged: @escaping (Bool) -> Void)
    func markMessageAsRead(chatId: String, messageId: String)
}
