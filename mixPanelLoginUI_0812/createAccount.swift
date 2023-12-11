import UIKit
import Mixpanel

class createAccount: UIViewController {
    
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var txtSignUpUsername: UITextField!
    @IBOutlet weak var txtSignUpEmail: UITextField!
    @IBOutlet weak var txtSignUpPass: UITextField!
    @IBOutlet weak var txtSignUpConfirmPass: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var iconClick = false

    
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


        
       
    }
    

    
    // Add botttom cureve to the UIView---- Start
    func createBottomCurve(for view: UIView, curveRadius: CGFloat = 70) {
            print("roundedUIView frame: \(view.frame)")
            
            let maskPath = UIBezierPath()
            maskPath.move(to: CGPoint(x: 0, y: 0))
            maskPath.addLine(to: CGPoint(x: 0, y: view.bounds.height - curveRadius))
            maskPath.addQuadCurve(to: CGPoint(x: view.bounds.width, y: view.bounds.height - curveRadius),
                                  controlPoint: CGPoint(x: view.bounds.width / 2, y: view.bounds.height))
            maskPath.addLine(to: CGPoint(x: view.bounds.width, y: 0))
            maskPath.close()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = maskPath.cgPath
            view.layer.mask = shapeLayer
            
        }
    
    // Add botttom cureve to the UIView---- End

   
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        
        let userName = txtSignUpUsername.text
        let email = txtSignUpEmail.text
        let password = txtSignUpPass.text
        
        
        
        
        Mixpanel.mainInstance().identify(distinctId: userName!)
        Mixpanel.mainInstance().people.set(properties: ["$email": email, "$name" : userName])

        
        Mixpanel.mainInstance().track(event: "Sign UP...", properties:
                                        ["UserName" : userName,
                                         "Password" : password
                                        ])
       // print("UserName-----\(userName)  Email-----\(email)")
        
        
    }
    
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
        
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




extension createAccount : UITextFieldDelegate

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
