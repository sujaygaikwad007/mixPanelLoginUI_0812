import UIKit
import Mixpanel
import Firebase


class SignInViewController: UIViewController  {
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var txtSignInUserName: UITextField!
    @IBOutlet weak var txtSignInPass: UITextField!
    
    var iconClick = false,userName = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtSignInUserName.delegate = self //Add border color after clicking
        txtSignInPass.delegate = self  //Add border color after clicking
        
        
        createBottomCurve(for: roundedUIView)
        cornerRadiusTxtField()
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
        addIconToTextField(textField: txtSignInPass, iconName: "openlock")
        
        eyeIconTxtField(for: txtSignInPass, with: UIImageView())
        
        let checkboxManager = CheckboxManager.shared
        let (checkbox, label) = checkboxManager.createCheckbox(targetView: self.view, position: CGPoint(x: 35 , y: 520), text: "Remember Me")
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("userName----\(self.userName)")
        self.txtSignInUserName.text = !userName.isEmpty ? self.userName : ""
        
        
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
            
            firebaseSignUp()
            txtSignInUserName.text = ""
            txtSignInPass.text = ""
            
            Mixpanel.mainInstance().identify(distinctId: userName!)
            Mixpanel.mainInstance().track(event: "Sign In...", properties:
                                            ["UserName" : userName,
                                             "Password" : password
                                            ])
        }
    }
    
    
    @IBAction func signUpFrmSignInBtn(_ sender: UIButton) {
        
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController
        signUpVC.controller = self
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signInBtn.layer.cornerRadius = 20
        
        txtSignInUserName.layer.borderWidth = 1
        txtSignInUserName.layer.cornerRadius = 20
        
        txtSignInPass.layer.borderWidth = 1
        txtSignInPass.layer.cornerRadius=20
        
    }
    //Add corner Radius to the textField ---- End
    
    
    //Code for Eye icon for password hide and show ---Start
    
    func eyeIconTxtField(for textField: UITextField, with iconImageView: UIImageView) {
        let passIcon = iconImageView
        passIcon.image = UIImage(named: "close")
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
            addIconToTextField(textField: txtSignInPass, iconName: "openlock")
            
            textField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImageView.image = UIImage(named: "close")
            addIconToTextField(textField: txtSignInPass, iconName: "filledlock")
            
            textField.isSecureTextEntry = true
        }
    }
    
    //Code for Eye icon for password hide and show ---End
    
    
    func firebaseSignUp(){
        guard let email = txtSignInUserName.text ,let password = txtSignInPass.text else
        {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error{
                
                print("Error creating user: \(error.localizedDescription)")
                showToast(controller: self, message: "Account Doesn't Exists", seconds: 2)
                self.txtSignInUserName.layer.borderColor = UIColor.red.cgColor
                self.txtSignInPass.layer.borderColor = UIColor.red.cgColor

                
            } else {
                let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                self.navigationController?.pushViewController(welcomeVC, animated: true)
            }
            
        }
        
        
    }
    
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
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
    }
    

    //Code for add border color after selecting-- End
    
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if textField == txtSignInPass {
//                let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//
//                textField.text = String(repeating: "*", count: updatedText.count)
//
//                return false
//            }
//
//            return true
//        }
//    
    
    
}






