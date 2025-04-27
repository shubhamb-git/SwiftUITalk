![Simulator Screenshot - iPhone 16 - 2025-04-27 at 19 36 32](https://github.com/user-attachments/assets/e7d451db-9348-405a-96d5-0820366e6142)
# SwiftChatKit + SwiftUITalk 🚀

A modular, real-time chat framework built with SwiftUI, Swift, Firebase, and Core Data.

---

## ✨ Features

- ✅ Real-time messaging powered by Firestore
- ✅ Typing indicators with debounce handling
- ✅ Message "sent", "delivered", "read" status tracking
- ✅ Offline caching using Core Data
- ✅ Optimistic UI updates (messages appear instantly)
- ✅ User List, Chat List, and Message Threads
- ✅ Full MVVM architecture (SwiftUI-focused)
- ✅ Dependency Injection (for Unit Testing)
- ✅ Mocked Services for 95% Unit Test coverage
- ✅ Core Data cleanup when user changes
- ✅ Modular SwiftChatKit Framework (separate from main app)
- ✅ Swift 5.9 / iOS 15+ ready

---

## 🏛 Architecture Overview

```plaintext
SwiftUITalk (App)
 ├── ViewModels
 │     ├── AuthViewModel
 │     ├── ChatListViewModel
 │     └── ChatViewModel
 ├── Views
 │     ├── LoginView
 │     ├── SignupView
 │     ├── ChatListView
 │     └── ChatView
 └── Uses SwiftChatKit (Framework)

SwiftChatKit (Framework)
 ├── Core
 │     ├── SwiftChat (Facade Singleton)
 │     ├── FirestoreService (User + Chat APIs)
 ├── Services
 │     ├── UserService
 │     ├── ChatService
 ├── DataStore
 │     └── ChatDataStore (Core Data)
 ├── Protocols
 │     ├── ChatCoordinator
 │     ├── ChatUserCoordinator
 │     ├── ChatConfigurable
 └── Models
       ├── ChatUser
       ├── Message
       └── Core Data Entities (UserEntity, MessageEntity)
```

---

## 📸 Screenshots

| Login / Signup | Chat List | Chat Screen |
|:---:|:---:|:---:|
| ![Simulator Screenshot - iPhone 16 - 2025-04-27 at 19 36 41](https://github.com/user-attachments/assets/bfa64e5b-ada3-48c4-9117-057717f3ea42) |![Simulator Screenshot - iPhone 16 - 2025-04-27 at 19 36 32](https://github.com/user-attachments/assets/dd02b4b6-fe3d-496d-ad1e-8f9ff628e48c) |![Simulator Screenshot - iPhone 16 - 2025-04-27 at 19 35 58](https://github.com/user-attachments/assets/e0846563-a48e-4db4-a94b-abc451ba7ce1)|

---

## 🔥 Technologies Used

- Swift 5.9
- SwiftUI 3.0+
- Firebase Auth + Firestore
- Core Data (offline caching)
- Combine Framework
- MVVM (Model View ViewModel) Architecture
- Xcode 16
- Dependency Injection + Protocol Oriented Design

---

## 🧪 Testing

- Fully Mocked Services (Firestore, UserService, ChatService)
- Unit Tests for:
  - AuthViewModel
  - ChatListViewModel
  - ChatViewModel
  - UserService
  - ChatService
  - SwiftChat (Facade Layer)

---

## 🛠 How to Run

1. Clone the repo
2. set Swift Package Manager correctly.
3. Open `.xcodeproj`.
5. Build & Run on iOS Simulator or real device.

---

## 🙌 Contributing

Feel free to fork this repo, make improvements, and submit pull requests.

---

## 📄 License

MIT License © 2025 Shubham Bairagi
