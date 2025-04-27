//
//  ChatDataStoreProtocol.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation

protocol ChatUserDataStoreProtocol {
    func fetchCachedUsers() -> [ChatUser]
    func saveUsers(_ users: [ChatUser])
}

protocol ChatMessageDataStoreProtocol {
    func saveMessages(_ messages: [Message], for chatId: String)
    func fetchCachedMessages(for chatId: String) -> [Message]
    func updateMessageStatus(chatId: String, messageId: String, isRead: Bool?, isDelivered: Bool?)
}
