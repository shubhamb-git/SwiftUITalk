//
//  FirestoreChatServiceProtocol.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

protocol FirestoreChatServiceProtocol {
    func listenToMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void)
    func sendMessage(chatId: String, message: Message, completion: @escaping (Error?) -> Void)
    func createChatIfNeeded(chatId: String, participants: [String])
    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool)
    func listenToTypingStatus(chatId: String, currentUserId: String, onTypingChanged: @escaping (Bool) -> Void)
    func markMessageAsDelivered(chatId: String, messageId: String)
    func markMessageAsRead(chatId: String, messageId: String)
}
