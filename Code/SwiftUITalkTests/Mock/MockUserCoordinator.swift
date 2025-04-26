//
//  MockUserCoordinator.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//
@testable import SwiftChatKit
@testable import SwiftUITalk

class MockUserCoordinator: ChatUserCoordinator {
   
    var shouldReturn: [ChatUser] = []
    var fetchCalledWith: String?

    func registerUser(uid: String, name: String, email: String, completion: @escaping (Bool) -> Void) {
        //
    }
    
    func fetchUsers(excluding uid: String, completion: @escaping ([ChatUser]) -> Void) {
        fetchCalledWith = uid
        completion(shouldReturn)
    }
}
