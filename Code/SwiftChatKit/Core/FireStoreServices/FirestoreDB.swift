//
//  FirestoreDB.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//
import Foundation
import FirebaseFirestore
import FirebaseCore

final class FirebaseDB {
   static var db: Firestore {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return Firestore.firestore()
    }
}
