//
//  MockFirestoreUserService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation
@testable import SwiftChatKit

class MockFirestoreUserService: FirestoreUserServiceProtocol {
    var shouldUserExist = true
    var shouldFail = false
    var mockUsers: [ChatUser] = []

    func getUserDocument(uid: String, completion: @escaping (Result<ChatUser, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockFail", code: 1)))
        } else if shouldUserExist {
            let user = ChatUser(id: uid, name: "Test User", email: "test@example.com")
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "NoData", code: 404)))
        }
    }

    func fetchAllUsers(completion: @escaping (Result<[ChatUser], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "MockFetchFail", code: 2)))
        } else {
            completion(.success(mockUsers))
        }
    }

    func createUser(uid: String, user: ChatUser, completion: @escaping (Error?) -> Void) {
        if shouldFail {
            completion(NSError(domain: "MockWriteFail", code: 3))
        } else {
            mockUsers.append(user)
            completion(nil)
        }
    }
}
