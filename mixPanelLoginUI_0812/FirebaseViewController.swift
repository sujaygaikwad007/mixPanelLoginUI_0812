
import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FacebookCore
import FacebookLogin

class FirebaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func googleSignInBtn(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            print("googleSignInBtn--- \(credential)")
            
        }
    }
    
    
    
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard error == nil, let result = result, !result.isCancelled else {
                return
            }
            
            // Successfully logged in with Facebook
            if AccessToken.isCurrentAccessTokenActive {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                self?.signInWithFacebook(credential)
            }
        }
    }
    
    
    
    private func signInWithFacebook(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard error == nil else {
                // Handle error
                return
            }
            
            // Firebase authentication successful with Facebook
            if let user = authResult?.user {
                print("Facebook Sign In Successful. User ID: \(user.uid)")
            }
        }
    }
    
    
    
}





