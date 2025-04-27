//
//  MockSessionManager.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 24/04/25.
//

@testable import SwiftChatKit

class MockChatConfigurator: ChatConfigurable {
    var configuredUID: String?
  
    func configure(uid: String) {
        configuredUID = uid
    }
}
