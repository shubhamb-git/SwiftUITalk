//
//  MockAuthService.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//
@testable import SwiftUITalk
import XCTest

class MockAuthService: AuthServicable {
   
    var userId: String?
    var currentUserEmail: String?
    var currentUserId: String? { userId }
    
    var shouldFail = false
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "LoginError", code: 1)))
        } else {
            completion(.success("123"))
        }
    }

    func signUp(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "SignupError", code: 2)))
        } else {
            completion(.success("456"))
        }
    }

    func logout() throws {}
}
