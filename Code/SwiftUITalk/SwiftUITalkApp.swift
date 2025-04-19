//
//  SwiftUITalkApp.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//

import SwiftUI

@main
struct SwiftUITalkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
