import UIKit
import Mixpanel
import Firebase
import FirebaseDatabase



class CreateAccountViewController: UIViewController {
    
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var txtSignUpUsername: UITextField!
    @IBOutlet weak var txtSignUpEmail: UITextField!
    @IBOutlet weak var txtSignUpPass: UITextField!
    @IBOutlet weak var txtSignUpConfirmPass: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var iconClick = false
    
    
    var controller = SignInViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createBottomCurve(for: roundedUIView)
        cornerRadiusTxtField()
        
        txtSignUpUsername.delegate = self
        txtSignUpEmail.delegate = self
        txtSignUpPass.delegate = self
        txtSignUpConfirmPass.delegate = self
        
        
        addIconToTextField(textField: txtSignUpUsername, iconName: "user")
        addIconToTextField(textField: txtSignUpEmail, iconName: "email")
        addIconToTextField(textField: txtSignUpPass, iconName: "openlock")
        addIconToTextField(textField: txtSignUpConfirmPass, iconName: "openlock")
        
        eyeIconTxtField(for: txtSignUpPass, with: UIImageView())
        eyeIconTxtField(for: txtSignUpConfirmPass, with: UIImageView())
        
        
        let checkboxManager = CheckboxManager.shared
        let (checkbox, label) = checkboxManager.createCheckbox(targetView: self.view, position: CGPoint(x: 45 , y: 632), text: "I agree to the")
        
    }
    
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        
        let userName = txtSignUpUsername.text
        let email = txtSignUpEmail.text
        let password = txtSignUpPass.text
        
        if txtSignUpUsername.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter a username", seconds: 2)
            txtSignUpUsername.layer.borderColor = UIColor.red.cgColor
            
        }
        else if txtSignUpEmail.text!.isEmpty
        {
            showToast(controller: self, message: "Please Enter Email", seconds: 2)
            txtSignUpEmail.layer.borderColor = UIColor.red.cgColor
        }
        else if !(txtSignUpEmail.text?.isEmailValid)!
        {
            showToast(controller: self, message: "Please Enter a valid email", seconds: 2)
            txtSignUpEmail.layer.borderColor = UIColor.red.cgColor
        }
        else if txtSignUpPass.text!.isEmpty
        {
            showToast(controller: self, message: "Password field should not be empty", seconds: 2)
            txtSignUpPass.layer.borderColor = UIColor.red.cgColor
            
        }
        else if !(txtSignUpPass.text?.isPasswordValid)!
        {
            showToast(controller: self, message: "Please Enter a valid password", seconds: 2)
            txtSignUpPass.layer.borderColor = UIColor.red.cgColor
        }
        else if txtSignUpConfirmPass.text!.isEmpty
        {
            showToast(controller: self, message: "Password field should not be empty", seconds: 2)
            txtSignUpConfirmPass.layer.borderColor = UIColor.red.cgColor
            
            
        }
        else if txtSignUpPass.text != txtSignUpConfirmPass.text
        {
            showToast(controller: self, message: "Passwords do not match", seconds: 2)
            txtSignUpConfirmPass.layer.borderColor = UIColor.red.cgColor
        }
        else
        {
            
            
            
            
            showToast(controller: self, message: "Account Created Successfully", seconds: 0)
            
            firebaseSignUp()
    
            Mixpanel.mainInstance().identify(distinctId: userName!)
            Mixpanel.mainInstance().people.set(properties: ["$email": email, "$name" : userName])
            Mixpanel.mainInstance().track(event: "Sign UP...", properties:
                                            ["UserName" : userName,
                                             "Password" : password
                                            ])
        }
    }
    
    
    @IBAction func signInBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signUpBtn.layer.cornerRadius = 20
        
        
        txtSignUpUsername.layer.borderWidth = 1
        txtSignUpUsername.layer.cornerRadius = 20
        
        txtSignUpEmail.layer.borderWidth = 1
        txtSignUpEmail.layer.cornerRadius=20
        
        txtSignUpPass.layer.borderWidth = 1
        txtSignUpPass.layer.cornerRadius=20
        
        txtSignUpConfirmPass.layer.borderWidth = 1
        txtSignUpConfirmPass.layer.cornerRadius=20
        
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
            textField.isSecureTextEntry = false
        } else {
            iconClick = true
            tappedImageView.image = UIImage(named: "close")
            textField.isSecureTextEntry = true
        }
    }
    //Code for Eye icon for password hide and show ---End
    
    
    func firebaseSignUp(){
        guard let email = txtSignUpEmail.text ,let password = txtSignUpConfirmPass.text, let username =  txtSignUpUsername.text else
        {
            return
        }
        
        
        //Create user
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("Error creating user: \(error.localizedDescription)")
            } else {
                print("User created successfully--------")
            }
            
        }
        
        //Update realtime Database
        if let user = Auth.auth().currentUser{
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            let userDetails: [String: Any] = [
                        "uid": user.uid,
                        "username": username,
                        "email": email,
                        "messages": []
            ]
            
            userRef.setValue(userDetails) { (error, ref) in
                if let error = error {
                    print("Error storing user details: \(error.localizedDescription)")
                } else {
                    print("User created successfully--------")
                    let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
                    signInVC.userName = self.txtSignUpEmail.text!
                    self.navigationController?.pushViewController(signInVC, animated: true)
                    self.textFieldClearFunc()
                    
                }
            }
        }
        
        
        
     
        
        
        
        
        
    }
    
    
    func textFieldClearFunc()
    {
        txtSignUpUsername.text = ""
        txtSignUpEmail.text = ""
        txtSignUpPass.text = ""
        txtSignUpConfirmPass.text = ""
        
    }

    
}


extension CreateAccountViewController : UITextFieldDelegate

{
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        print("textFieldDidBeginEditing------")
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.blue.cgColor
        
        
        if textField == txtSignUpUsername
        {
            addIconToTextField(textField: txtSignUpUsername, iconName: "userfilled")
            
        }
        else if textField == txtSignUpEmail
        {
            addIconToTextField(textField: txtSignUpEmail, iconName: "filledemail")
            
        }
        else if textField == txtSignUpPass
        {
            addIconToTextField(textField: txtSignUpPass, iconName: "filledlock")
        }
        else if textField == txtSignUpConfirmPass
        {
            addIconToTextField(textField: txtSignUpConfirmPass, iconName: "filledlock")
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtSignUpUsername, iconName: "user")
        addIconToTextField(textField: txtSignUpEmail, iconName: "email")
        addIconToTextField(textField: txtSignUpPass, iconName: "openlock")
        addIconToTextField(textField: txtSignUpConfirmPass, iconName: "openlock")
        
    }
    //Code for add border color after selecting-- End
    
    
    
}



//Extension for the validation of textfields
extension String
{
    
    var isEmailValid: Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
        
    }
    
    var isPasswordValid:Bool{
        
        let passwordRegEx = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,12}")
        return passwordRegEx.evaluate(with: self)
    }
    
}
