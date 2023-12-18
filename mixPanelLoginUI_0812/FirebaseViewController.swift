
import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FacebookCore
import FacebookLogin
import AuthenticationServices


class FirebaseViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()

    }
    

    
    
    
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
            
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: true)
            
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
    
    
    @IBAction func appleIdBtn(_ sender: UIButton) {
        
        
        if #available(iOS 13.0, *){
            startSignInWithApple()
        } else {
            print("invalid ios version")
        }
    }
    
    
    @available(iOS 13.0, *)
    func startSignInWithApple(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
}

extension FirebaseViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userId = appleIdCredential.user
            
            if let identityTokenData = appleIdCredential.identityToken {
                if let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nil)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if let error = error {
                            print("Error signing in with Apple: \(error.localizedDescription)")
                            return
                        }
                        // User signed in successfully
                    }
                } else {
                    print("Error converting identityToken to string")
                }
            } else {
                print("Error: No identityToken found")
            }
        }
    }
}




