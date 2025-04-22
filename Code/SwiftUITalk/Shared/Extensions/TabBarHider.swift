//
//  TabBarHider.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//

import SwiftUI

struct TabBarHider: ViewModifier {
    let shouldHide: Bool

    func body(content: Content) -> some View {
        content
            .background(TabBarAccessor(shouldHide: shouldHide))
    }
}

extension View {
    func tabBarHidden(_ shouldHide: Bool) -> some View {
        self.modifier(TabBarHider(shouldHide: shouldHide))
    }
}
