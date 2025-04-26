//
//  MockFirestoreService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation
@testable import SwiftChatKit

class MockFirestoreService: FirestoreUserServiceProtocol {
    var mockResult: Result<ChatUser, Error> = .success(ChatUser(id: "user123", name: "Default", email: "default@example.com"))

    func getUserDocument(uid: String, completion: @escaping (Result<ChatUser, Error>) -> Void) {
        completion(mockResult)
    }

    func fetchAllUsers(completion: @escaping (Result<[ChatUser], Error>) -> Void) {
        completion(.success([
            ChatUser(id: "user1", name: "Mock User 1", email: "mock1@example.com"),
            ChatUser(id: "user2", name: "Mock User 2", email: "mock2@example.com")
        ]))
    }

    func createUser(uid: String, user: ChatUser, completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
}
