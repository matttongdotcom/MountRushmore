import SwiftUI
import FirebaseAuth

class AuthState: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        self.user = Auth.auth().currentUser
        self.isLoggedIn = (self.user != nil)
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.user = user
            self?.isLoggedIn = (user != nil)
            print("Auth state changed: user is \(user == nil ? "nil" : "logged in")")
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
} 