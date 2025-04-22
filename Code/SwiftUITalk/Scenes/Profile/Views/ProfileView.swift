//
//  ProfileView 2.swift
//  SwiftUITalk
//
//  Created by Priya Vaishnav on 19/04/25.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Logged in as: \(viewModel.email)")
                    .font(.headline)

                Button("Log Out") {
                    viewModel.logout()
                }
                .foregroundColor(.red)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
