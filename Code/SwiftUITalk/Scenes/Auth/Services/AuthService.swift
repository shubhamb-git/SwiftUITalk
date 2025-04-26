//
//  AuthService.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import Foundation
import FirebaseAuth
import SwiftChatKit

protocol AuthServicable {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func logout() throws
    
    var currentUserId: String? { get }
    var currentUserEmail: String? { get }
}

final class AuthService: AuthServicable {
    static let shared = AuthService()

    private init() {}

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                SwiftChat.shared.registerUser(uid: user.uid, name: name, email: email) { success in
                    if success {
                        completion(.success(user.uid))
                    } else {
                        completion(.failure(NSError(domain: "AuthService", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to register user in Firestore"])))
                    }
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user.uid))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var currentUserId: String? {
        return currentUser?.uid
    }
    
    var currentUserEmail: String? {
        return currentUser?.email
    }
}
