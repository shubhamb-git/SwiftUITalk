//
//  SwiftChat.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import Foundation

final public class SwiftChat {
    public static let shared = SwiftChat()

    private let userService = UserService()
    private let chatService = ChatService()

    private(set) var currentUser: ChatUser?

    private init() {}

    public func configure(uid: String) {
        guard !uid.isEmpty else { return }
        FirebaseDB.db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch current user: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data(),
                  let name = data["name"] as? String,
                  let email = data["email"] as? String else {
                print("❌ Invalid user document format")
                return
            }

            self.currentUser = ChatUser(id: uid, name: name, email: email)
            print("✅ SwiftTalk current user loaded: \(name)")
        }
    }

    public func registerUser(
        uid: String,
        name: String,
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        userService.createUserIfNeeded(uid: uid, name: name, email: email) { error in
            completion(error == nil)
        }
    }

    public func fetchUsers(
        excluding uid: String,
        completion: @escaping ([ChatUser]) -> Void
    ) {
        userService.fetchAllUsers(excluding: uid) { result in
            switch result {
            case .success(let users):
                completion(users)
            case .failure(let error):
                print("❌ Failed to fetch users:", error.localizedDescription)
                completion([])
            }
        }
    }

    public func startChatSession(
        with user: ChatUser,
        onMessagesUpdate: @escaping ([Message]) -> Void
    ) -> String {
        guard let currentUid = currentUser?.id else {
            print("❌ SwiftTalk: currentUser is nil")
            return ""
        }

        let otherUid = user.id ?? ""
        let chatId = [currentUid, otherUid].sorted().joined(separator: "_")

        chatService.createChatIfNeeded(chatId: chatId, participants: [currentUid, otherUid])
        chatService.listenToMessages(chatId: chatId, currentUserId: currentUid) { messages in
            onMessagesUpdate(messages)
        }
        return chatId
    }

    public func sendMessage(
        chatId: String,
        text: String
    ) {
        guard let senderId = currentUser?.id else { return }
        let message = Message(text: text, senderId: senderId, timestamp: Date())
        chatService.sendMessage(chatId: chatId, message: message)
    }

    public func markMessageAsRead(chatId: String, messageId: String) {
        chatService.markMessageAsRead(chatId: chatId, messageId: messageId)
    }

    public func updateTypingStatus(with user: ChatUser, isTyping: Bool) {
        guard let currentUid = currentUser?.id else {
            print("❌ SwiftTalk: currentUser is nil")
            return
        }

        let otherUid = user.id ?? ""
        let chatId = [currentUid, otherUid].sorted().joined(separator: "_")

        chatService.updateTypingStatus(chatId: chatId, userId: currentUid, isTyping: isTyping)
    }

    public func listenToTypingStatus(
        with user: ChatUser,
        onTypingChanged: @escaping ((Bool)) -> Void
    ) {
        guard let currentUid = currentUser?.id else {
            print("❌ SwiftTalk: currentUser is nil")
            return
        }

        let otherUid = user.id ?? ""
        let chatId = [currentUid, otherUid].sorted().joined(separator: "_")

        chatService.listenToTypingStatus(chatId: chatId,
                                         currentUserId: currentUid,
                                         onTypingChanged: onTypingChanged)
    }
}
