//
//  MockUserService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation
@testable import SwiftChatKit

class MockUserService: UserServiceProtocol {
    var createUserHandler: ((String, String, String, @escaping (Error?) -> Void) -> Void)?
    var fetchUsersHandler: ((String, @escaping (Result<[ChatUser], Error>) -> Void) -> Void)?

    func createUserIfNeeded(uid: String, name: String, email: String, completion: @escaping (Error?) -> Void) {
        createUserHandler?(uid, name, email, completion)
    }

    func fetchAllUsers(excluding uid: String, completion: @escaping (Result<[ChatUser], Error>) -> Void) {
        fetchUsersHandler?(uid, completion)
    }
}
