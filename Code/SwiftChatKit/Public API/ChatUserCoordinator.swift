//
//  ChatUserCoordinator.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//

import Foundation

public protocol ChatUserCoordinator {
    func registerUser(uid: String, name: String, email: String, completion: @escaping (Bool) -> Void)
    func fetchUsers(excluding uid: String, completion: @escaping ([ChatUser]) -> Void)
}
