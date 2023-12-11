import UIKit
import Mixpanel

class createAccount: UIViewController {
    
    
    @IBOutlet weak var roundedUIView: UIView!
    @IBOutlet weak var txtSignUpUsername: UITextField!
    @IBOutlet weak var txtSignUpEmail: UITextField!
    @IBOutlet weak var txtSignUpPass: UITextField!
    @IBOutlet weak var txtSignUpConfirmPass: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBottomCurve(for: roundedUIView)
        cornerRadiusTxtField()

        
        self.txtSignUpUsername.addPaddingTxt()
        self.txtSignUpEmail.addPaddingTxt()
        self.txtSignUpPass.addPaddingTxt()
        self.txtSignUpConfirmPass.addPaddingTxt()
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
        print("UserName-----\(userName)  Email-----\(email)")
        
        
    }
    
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    //Add corner Radius to the textField ---- Start
    func cornerRadiusTxtField()
    {
        signUpBtn.layer.cornerRadius = 20

        
        txtSignUpUsername.layer.borderWidth = 0.5
        txtSignUpUsername.layer.cornerRadius = 20
        
        txtSignUpEmail.layer.borderWidth = 0.5
        txtSignUpEmail.layer.cornerRadius=20
        
        txtSignUpPass.layer.borderWidth = 0.5
        txtSignUpPass.layer.cornerRadius=20
        
        txtSignUpConfirmPass.layer.borderWidth = 0.5
        txtSignUpConfirmPass.layer.cornerRadius=20
        
    }
    //Add corner Radius to the textField ---- End
}


