//
//  MockDocumentSnapshot.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

struct MockDocumentSnapshot {
    let data: [String: Any]?
    var exists: Bool {
        return data != nil
    }
}
