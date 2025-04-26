//
//  TabBarAccessor.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 20/04/25.
//


import UIKit
import SwiftUI

struct TabBarAccessor: UIViewControllerRepresentable {
    var shouldHide: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ✅ Called after make — ensures proper sync
        DispatchQueue.main.async {
            uiViewController.parent?.tabBarController?.tabBar.isHidden = shouldHide
        }
    }
}
