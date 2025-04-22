//
//  ChatService.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import Foundation
import FirebaseFirestore

final class ChatService {
    private let db: Firestore
    private let local: ChatDataStore

    init(db: Firestore = FirebaseDB.db, local: ChatDataStore = ChatDataStore.shared) {
        self.db = db
        self.local = local
    }

    func listenToMessages(
        chatId: String,
        currentUserId: String,
        completion: @escaping ([Message]) -> Void
    ) {
        // ✅ First send cached messages immediately
        let cached = local.fetchCachedMessages(for: chatId)
        completion(cached)

        // 🔁 Then listen for real-time updates from Firestore
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ Firestore listen failed: \(String(describing: error?.localizedDescription))")
                    return
                }

                let messages = documents.compactMap {
                    try? $0.data(as: Message.self)
                }

                // ✅ Save to Core Data
                self.local.saveMessages(messages, for: chatId)

                // ✅ Pass to caller
                completion(messages)

                // ✅ Mark as delivered if needed
                for doc in documents {
                    if let message = try? doc.data(as: Message.self),
                       message.senderId != currentUserId,
                       message.isDelivered == false,
                       let id = doc.documentID as String? {
                        self.markMessageAsDelivered(chatId: chatId, messageId: id)
                    }
                }
            }
    }

    func sendMessage(chatId: String, message: Message, completion: ((Error?) -> Void)? = nil) {
        // ✅ Save locally first (optimistic)
        local.saveMessages([message], for: chatId)

        // ✅ Then push to Firestore
        do {
            _ = try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)

            completion?(nil)
        } catch {
            print("❌ Failed to send message: \(error.localizedDescription)")
            completion?(error)
        }
    }

    func createChatIfNeeded(chatId: String, participants: [String]) {
        let chatRef = db.collection("chats").document(chatId)
        chatRef.getDocument { doc, error in
            if let doc = doc, !doc.exists {
                chatRef.setData([
                    "users": participants,
                    "createdAt": FieldValue.serverTimestamp()
                ])
            }
        }
    }

    func updateTypingStatus(chatId: String, userId: String, isTyping: Bool) {
        let field = "typingStatus.\(userId)"
        db.collection("chats").document(chatId).updateData([
            field: isTyping
        ])
    }

    func listenToTypingStatus(
        chatId: String,
        currentUserId: String,
        onTypingChanged: @escaping (Bool) -> Void
    ) {
        db.collection("chats").document(chatId)
            .addSnapshotListener { snapshot, error in
                guard let data = snapshot?.data(),
                      let typingStatus = data["typingStatus"] as? [String: Bool] else {
                    onTypingChanged(false)
                    return
                }

                let othersAreTyping = typingStatus
                    .filter { $0.key != currentUserId }
                    .contains(where: { $0.value == true })

                onTypingChanged(othersAreTyping)
            }
    }

    func markMessageAsDelivered(chatId: String, messageId: String) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document(messageId)
            .updateData(["isDelivered": true])

        ChatDataStore.shared.updateMessageStatus(chatId: chatId, messageId: messageId, isDelivered: true)
    }

    func markMessageAsRead(chatId: String, messageId: String) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document(messageId)
            .updateData(["isRead": true])

        ChatDataStore.shared.updateMessageStatus(chatId: chatId, messageId: messageId, isRead: true)
    }
}
