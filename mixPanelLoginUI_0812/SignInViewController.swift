import UIKit
import Mixpanel
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var txtSignInUserName: UITextField!
    @IBOutlet weak var txtSignInPass: UITextField!
    
    
    @IBOutlet weak var googleSignInBtn: UIButton!
    
    var iconClick = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtSignInUserName.delegate = self //Add border color after clicking
        txtSignInPass.delegate = self  //Add border color after clicking
        
        
        createBottomCurve(for: roundedUIView)
        cornerRadiusTxtField()
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
        addIconToTextField(textField: txtSignInPass, iconName: "openlock")
        
        eyeIconTxtField(for: txtSignInPass, with: UIImageView())
        
    }
    
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        
        let userName = txtSignInUserName.text
        let password = txtSignInPass.text
        
        
        if txtSignInUserName.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter User Name", seconds: 2)
            txtSignInUserName.layer.borderColor = UIColor.red.cgColor
        }
        
        else if txtSignInPass.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Password", seconds: 2)
            txtSignInPass.layer.borderColor = UIColor.red.cgColor
        }
        
        else
        {
            
            
            let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.navigationController?.pushViewController(welcomeVC, animated: true)
            
            Mixpanel.mainInstance().identify(distinctId: userName!)
            Mixpanel.mainInstance().track(event: "Sign In...", properties:
                                            ["UserName" : userName,
                                             "Password" : password
                                            ])
            
           // print("UserName is \(userName)")
            
        }
    }
    
    
    @IBAction func signUpFrmSignInBtn(_ sender: UIButton) {
        
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
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
    
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signInBtn.layer.cornerRadius = 20
        googleSignInBtn.layer.cornerRadius = 20
        
        txtSignInUserName.layer.borderWidth = 1
        txtSignInUserName.layer.cornerRadius = 20
        
        txtSignInPass.layer.borderWidth = 1
        txtSignInPass.layer.cornerRadius=20
        
    }
    //Add corner Radius to the textField ---- End
    
    
    
    
    
    //Code for Eye icon for password hide and show ---Start
    
    func eyeIconTxtField(for textField: UITextField, with iconImageView: UIImageView) {
        let passIcon = iconImageView
        passIcon.image = UIImage(named: "open")
        let contentView = UIView() // For blank space
        contentView.addSubview(passIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        passIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        textField.rightView = contentView
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        passIcon.isUserInteractionEnabled = true
        passIcon.addGestureRecognizer(tapGesture)
    }




    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        guard let textField = tappedImageView.superview?.superview as? UITextField else { return }

        if iconClick {
            iconClick = false
            tappedImageView.image = UIImage(named: "open")
            textField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImageView.image = UIImage(named: "close")
            textField.isSecureTextEntry = true
        }
    }



    
    //Code for Eye icon for password hide and show ---End
    
    
   
    
}


extension SignInViewController : UITextFieldDelegate

{
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
            
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.blue.cgColor
            
        
        if textField == txtSignInUserName
        {
            addIconToTextField(textField: txtSignInUserName, iconName: "userfilled")

        }
        else if textField == txtSignInPass
        {
            addIconToTextField(textField: txtSignInPass, iconName: "filledlock")

        }
            
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
        addIconToTextField(textField: txtSignInPass, iconName: "openlock")
        
        
    }
    //Code for add border color after selecting-- End
}






