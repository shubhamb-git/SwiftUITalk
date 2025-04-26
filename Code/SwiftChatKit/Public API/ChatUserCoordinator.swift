//
//  ChatUserCoordinator.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 24/04/25.
//

import Foundation

public protocol ChatUserCoordinator {
    func registerUser(uid: String, name: String, email: String, completion: @escaping (Bool) -> Void)
    func fetchUsers(excluding uid: String, completion: @escaping ([ChatUser]) -> Void)
}
