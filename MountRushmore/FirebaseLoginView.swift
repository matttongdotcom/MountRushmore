import SwiftUI
import FirebaseAuth
import FirebaseAuthUI
import FirebaseEmailAuthUI

struct FirebaseLoginView: UIViewControllerRepresentable {
    @EnvironmentObject var authState: AuthState

    class Coordinator: NSObject, FUIAuthDelegate {
        var parent: FirebaseLoginView

        init(_ parent: FirebaseLoginView) {
            self.parent = parent
        }
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            
            // The AuthState listener will automatically handle the update.
            // No explicit action is needed here to dismiss the view.
            print("Sign-in successful from FirebaseLoginView coordinator")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI.delegate = context.coordinator
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()
        ]
        authUI.providers = providers
        
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No update logic needed
    }
} 
