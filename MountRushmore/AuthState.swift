import SwiftUI
import FirebaseAuth

class AuthState: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        self.user = Auth.auth().currentUser
        self.isLoggedIn = (self.user != nil)
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.user = user
            self?.isLoggedIn = (user != nil)
            if user != nil {
                self?.errorMessage = nil
            }
            print("Auth state changed: user is \(user == nil ? "nil" : "logged in")")
        }
    }
    
    func signIn(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Error signing in: \(error.localizedDescription)")
            } else {
                // The state change listener will set isLoggedIn and clear any previous errors.
                print("Sign-in successful from AuthState")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
} 
