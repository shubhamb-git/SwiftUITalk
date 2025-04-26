//
//  UserServiceProtocol.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//
import Foundation

protocol UserServiceProtocol {
    func createUserIfNeeded(uid: String, name: String, email: String, completion: @escaping (Error?) -> Void)
    func fetchAllUsers(excluding uid: String, completion: @escaping (Result<[ChatUser], Error>) -> Void)
}
