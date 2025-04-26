//
//  FirestoreService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import FirebaseFirestore

class FirestoreService {
    fileprivate let db = FirebaseDB.db
}

extension FirestoreService: FirestoreUserServiceProtocol {
    
    func getUserDocument(uid: String, completion: @escaping (Result<ChatUser, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot, snapshot.exists {
                if let user = try? snapshot.data(as: ChatUser.self) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "DataDecoding", code: -1)))
                }
            } else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
            }
        }
    }

    func fetchAllUsers(completion: @escaping (Result<[ChatUser], Error>) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let documents = snapshot?.documents ?? []
                let users = documents.compactMap { try? $0.data(as: ChatUser.self) }
                completion(.success(users))
            }
        }
    }

    func createUser(uid: String, user: ChatUser, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

extension FirestoreService: FirestoreChatServiceProtocol {

    func listenToMessages(chatId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    return completion(.failure(error))
                }

                guard let documents = snapshot?.documents else {
                    return completion(.success([]))
                }

                let messages = documents.compactMap {
                    try? $0.data(as: Message.self)
                }
                completion(.success(messages))
            }
    }

    func sendMessage(chatId: String, message: Message, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)
            completion(nil)
        } catch {
            completion(error)
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

    func listenToTypingStatus(chatId: String, currentUserId: String, onTypingChanged: @escaping (Bool) -> Void) {
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
    }

    func markMessageAsRead(chatId: String, messageId: String) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .document(messageId)
            .updateData(["isRead": true])
    }
}
