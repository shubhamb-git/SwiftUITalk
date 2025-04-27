//
//  ChatServiceProtocol.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation

protocol ChatServiceProtocol {
    func createChatIfNeeded(chatId: String, participants: [String])
    func listenToMessages(chatId: String, currentUserId: String, completion: @escaping ([Message]) -> Void)
    func sendMessage(chatId: String, message: Message, completion: ((Error?) -> Void)?)
    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool)
    func listenToTypingStatus(chatId: String, currentUserId: String, onTypingChanged: @escaping (Bool) -> Void)
    func markMessageAsRead(chatId: String, messageId: String)
    func clearAllData()
}
