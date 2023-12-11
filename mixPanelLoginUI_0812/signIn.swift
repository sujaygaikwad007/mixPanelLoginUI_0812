import UIKit
import Mixpanel

class signIn: UIViewController {
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var txtSignInUserName: UITextField!
    @IBOutlet weak var txtSignInPass: UITextField!
    
    var iconClick = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtSignInUserName.delegate = self //Add border color after clicking
        txtSignInPass.delegate = self  //Add border color after clicking
        
        
        createBottomCurve(for: roundedUIView)
        cornerRadiusTxtField()
        eyeIconTxt()
        
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
        addIconToTextField(textField: txtSignInPass, iconName: "padlock")
        
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
            showToast(controller: self, message: "User Successfully Sign In", seconds: 2)
            
            Mixpanel.mainInstance().identify(distinctId: userName!)
            Mixpanel.mainInstance().track(event: "Sign In...", properties:
                                            ["UserName" : userName,
                                             "Password" : password
                                            ])
            
            print("UserName is \(userName)")
            
        }
    }
    
    
    @IBAction func signUpFrmSignInBtn(_ sender: UIButton) {
        
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "createAccount") as! createAccount
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
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
    
    func eyeIconTxt()
    {
        let passIcon = UIImageView()
        passIcon.image = UIImage(named: "close")
        let contentView = UIView() //For blank space
        contentView.addSubview(passIcon)
        
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        
        passIcon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "close")!.size.width, height: UIImage(named: "close")!.size.height)
        
        
        txtSignInPass.rightView = contentView
        txtSignInPass.rightViewMode = .always
        txtSignInPass.clearButtonMode = .whileEditing
        
        
        let tapGesture = UITapGestureRecognizer(target: self.self, action: #selector(imageTapped(tapGesture:)))
        
        
        passIcon.isUserInteractionEnabled = true
        passIcon.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func imageTapped(tapGesture:UITapGestureRecognizer)
    {
        let tappedImage = tapGesture.view as! UIImageView
        
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "open")
            txtSignInPass.isSecureTextEntry = false
        }
        
        else
        {
            iconClick = true
            tappedImage.image = UIImage(named: "close")
            txtSignInPass.isSecureTextEntry = true
        }
    }
    
    //Code for Eye icon for password hide and show ---End
    
    
   
    
}


extension signIn : UITextFieldDelegate

{
    //Code for add border color after selecting--Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField != txtSignInUserName || textField != txtSignInPass {
            
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.blue.cgColor
            
            
            addIconToTextField(textField: txtSignInUserName, iconName: "userfilled")
           // addIconToTextField(textField: txtSignInPass, iconName: "padlock")
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        addIconToTextField(textField: txtSignInUserName, iconName: "user")
        
    }
    //Code for add border color after selecting-- End
}






