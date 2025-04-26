//
//  FirestoreServiceProtocol.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import Foundation

protocol FirestoreUserServiceProtocol {
    func getUserDocument(uid: String, completion: @escaping (Result<ChatUser, Error>) -> Void)
    func fetchAllUsers(completion: @escaping (Result<[ChatUser], Error>) -> Void)
    func createUser(uid: String, user: ChatUser, completion: @escaping (Error?) -> Void)
}
