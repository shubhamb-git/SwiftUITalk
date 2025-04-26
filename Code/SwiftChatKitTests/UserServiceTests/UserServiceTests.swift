//
//  UserServiceTests.swift
//  SwiftUITalk
//
//  Created by Shubham Bairagi on 26/04/25.
//

import XCTest
@testable import SwiftChatKit

final class UserServiceTests: XCTestCase {
    var mockFirestore: MockFirestoreUserService!
    var mockLocalStore: MockChatDataStore!
    var service: UserService!

    override func setUp() {
        super.setUp()
        mockFirestore = MockFirestoreUserService()
        mockLocalStore = MockChatDataStore()
        service = UserService(firestore: mockFirestore, local: mockLocalStore)
    }

    override func tearDown() {
        mockFirestore = nil
        mockLocalStore = nil
        service = nil
        super.tearDown()
    }

    func testCreateUserIfExists_shouldNotCreateAgain() {
        mockFirestore.shouldUserExist = true

        let expectation = expectation(description: "User already exists")

        service.createUserIfNeeded(uid: "uid123", name: "Shubham", email: "shubham@gmail.com") { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.mockFirestore.mockUsers.count, 0, "Should not create new user if already exists")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testCreateUserIfNotExists_shouldCreateNew() {
        mockFirestore.shouldUserExist = false

        let expectation = expectation(description: "Create new user")

        service.createUserIfNeeded(uid: "uid123", name: "Shubham", email: "shubham@gmail.com") { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.mockFirestore.mockUsers.count, 1, "Should create new user when not existing")
            XCTAssertEqual(self.mockFirestore.mockUsers.first?.name, "Shubham")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchCachedUsersImmediately() {
        mockLocalStore.cachedUsers = [
            ChatUser(id: "1", name: "Test User", email: "test@gmail.com")
        ]

        let expectation = expectation(description: "Cached users returned")
        var fulfilled = false

        service.fetchAllUsers(excluding: "99") { result in
            if fulfilled { return }

            switch result {
            case .success(let users):
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.name, "Test User")
            case .failure:
                XCTFail("Should not fail fetching cached users")
            }

            expectation.fulfill()
            fulfilled = true
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchAllUsers_successfulRefresh() {
        mockFirestore.shouldUserExist = false
        mockFirestore.mockUsers = [
            ChatUser(id: "2", name: "MockUser", email: "mock@example.com")
        ]

        let expectation = expectation(description: "Fetched users from Firestore")
        var fulfilled = false

        service.fetchAllUsers(excluding: "99") { result in
            if fulfilled { return } // ✅ ignore second call
            switch result {
            case .success(let users):
                // ✅ Make sure the correct users come
                if users.first?.email == "mock@example.com" {
                    XCTAssertEqual(users.count, 1)
                    XCTAssertEqual(users.first?.email, "mock@example.com")
                    fulfilled = true
                    expectation.fulfill()
                }
            case .failure:
                XCTFail("Should not fail fetching Firestore users")
            }
        }

        waitForExpectations(timeout: 2)
    }


}
