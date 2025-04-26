//
//  SwiftChat.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//

import Foundation

final public class SwiftChat {
    public static let shared = SwiftChat()

    private var userService: UserServiceProtocol
    private var chatService: ChatServiceProtocol
    private var firestore: FirestoreUserServiceProtocol
    private var userDefaults: UserDefaults
    
    var currentUser: ChatUser?
    private let kLastLoggedInUserId = "LastLoggedInUserId"

    // Production init
    private init(
        userService: UserServiceProtocol = UserService(),
        chatService: ChatServiceProtocol = ChatService(),
        firestore: FirestoreUserServiceProtocol = FirestoreService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.userService = userService
        self.chatService = chatService
        self.firestore = firestore
        self.userDefaults = userDefaults
    }
    
    // Special initializer only for tests
    #if DEBUG
    static func configureForTesting(
        userService: UserServiceProtocol,
        chatService: ChatServiceProtocol,
        firestore: FirestoreUserServiceProtocol,
        userDefaults: UserDefaults = .standard
    ) {
        shared.userService = userService
        shared.chatService = chatService
        shared.firestore = firestore
        shared.userDefaults = userDefaults
    }
    #endif
}

extension SwiftChat: ChatConfigurable {
    public func configure(uid: String) {
        guard !uid.isEmpty else { return }
        
        let savedUid = userDefaults.string(forKey: kLastLoggedInUserId)
        
        if let savedUid = savedUid, savedUid != uid {
            print("🔁 User changed from \(savedUid) to \(uid). Clearing local data...")
            chatService.clearAllData()
        }
        
        userDefaults.set(uid, forKey: kLastLoggedInUserId)
        
        firestore.getUserDocument(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
                print("✅ SwiftTalk current user loaded: \(user.name)")
            case .failure(let error):
                print("❌ Failed to fetch current user: \(error.localizedDescription)")
            }
        }
    }
}

extension SwiftChat: ChatUserCoordinator {
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
}

extension SwiftChat: ChatCoordinator {
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

    public func sendMessage(chatId: String, text: String) {
        guard let senderId = currentUser?.id else { return }
        let message = Message(text: text, senderId: senderId, timestamp: Date())
        chatService.sendMessage(chatId: chatId, message: message, completion: nil)
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
