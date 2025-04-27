//
//  SwiftChatTests.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import XCTest
@testable import SwiftChatKit

final class SwiftChatTests: XCTestCase {
    
    private var mockUserService: MockUserService!
    private var mockChatService: MockChatService!
    private var mockFirestoreService: MockFirestoreService!
    private var userDefaults: UserDefaults!
    private var swiftChat: SwiftChat!

    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        mockChatService = MockChatService()
        mockFirestoreService = MockFirestoreService()
        userDefaults = UserDefaults(suiteName: "com.swiftchat.tests")!
        
        SwiftChat.configureForTesting(
            userService: mockUserService,
            chatService: mockChatService,
            firestore: mockFirestoreService,
            userDefaults: userDefaults
        )
        swiftChat = SwiftChat.shared
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "com.swiftchat.tests")
        userDefaults = nil
        mockUserService = nil
        mockChatService = nil
        mockFirestoreService = nil
        swiftChat = nil
        super.tearDown()
    }
    
    func testConfigure_withSameUser_shouldNotClearData() {
        userDefaults.set("user123", forKey: "LastLoggedInUserId")
        mockFirestoreService.mockResult = .success(ChatUser(id: "user123", name: "Test User", email: "test@test.com"))
        
        swiftChat.configure(uid: "user123")
        
        XCTAssertFalse(mockChatService.didClearData)
    }
    
    func testConfigure_withNewUser_shouldClearData() {
        userDefaults.set("oldUser", forKey: "LastLoggedInUserId")
        mockFirestoreService.mockResult = .success(ChatUser(id: "newUser", name: "New User", email: "new@test.com"))
        
        swiftChat.configure(uid: "newUser")
        
        XCTAssertTrue(mockChatService.didClearData)
        XCTAssertEqual(userDefaults.string(forKey: "LastLoggedInUserId"), "newUser")
    }
    
    func testRegisterUser_callsCreateUser() {
        let exp = expectation(description: "Register user called")
        mockUserService.createUserHandler = { uid, name, email, completion in
            completion(nil)
            exp.fulfill()
        }
        
        swiftChat.registerUser(uid: "user123", name: "Test", email: "test@test.com") { success in
            XCTAssertTrue(success)
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testFetchUsers_callsFetchAllUsers() {
        let exp = expectation(description: "Fetch users called")
        mockUserService.fetchUsersHandler = { excludingUid, completion in
            completion(.success([
                ChatUser(id: "1", name: "Mock", email: "mock@test.com")
            ]))
            exp.fulfill()
        }
        
        swiftChat.fetchUsers(excluding: "currentUser123") { users in
            XCTAssertEqual(users.count, 1)
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func testStartChatSession_createsAndListens() {
        swiftChat.currentUser = ChatUser(id: "me", name: "Self", email: "me@test.com")
        
        var receivedMessages: [Message] = []
        let otherUser = ChatUser(id: "other", name: "Other", email: "other@test.com")
        
        let chatId = swiftChat.startChatSession(with: otherUser) { messages in
            receivedMessages = messages
        }
        
        XCTAssertEqual(chatId, "me_other")
        XCTAssertTrue(mockChatService.createdChatIds.contains("me_other"))
        XCTAssertTrue(mockChatService.listenedChatIds.contains("me_other"))
    }
    
    func testSendMessage_sendsCorrectly() {
        swiftChat.currentUser = ChatUser(id: "me", name: "Self", email: "me@test.com")
        
        swiftChat.sendMessage(chatId: "chat123", text: "Hello world")
        
        XCTAssertEqual(mockChatService.sentMessages.first?.chatId, "chat123")
        XCTAssertEqual(mockChatService.sentMessages.first?.message.text, "Hello world")
    }
    
    func testUpdateTypingStatus_updatesCorrectly() {
        swiftChat.currentUser = ChatUser(id: "me", name: "Self", email: "me@test.com")
        
        let user = ChatUser(id: "other", name: "Other", email: "other@test.com")
        
        swiftChat.updateTypingStatus(with: user, isTyping: true)
        
        XCTAssertEqual(mockChatService.typingUpdates.first?.isTyping, true)
    }
    
    func testListenTypingStatus_startsListening() {
        swiftChat.currentUser = ChatUser(id: "me", name: "Self", email: "me@test.com")
        
        let user = ChatUser(id: "other", name: "Other", email: "other@test.com")
        
        swiftChat.listenToTypingStatus(with: user) { isTyping in
            XCTAssertNotNil(isTyping) // minimal validation
        }
        
        XCTAssertTrue(mockChatService.listenedChatIds.contains("me_other"))
    }
}
