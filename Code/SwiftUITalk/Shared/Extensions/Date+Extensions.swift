//
//  Date+Extensions.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 20/04/25.
//
import Foundation

extension Date {
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
}
