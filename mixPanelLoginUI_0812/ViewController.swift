import UIKit


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var firebaseBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.cornerRadius = 20
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

    }

    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "createAccount") as! CreateAccountViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    @IBAction func firebaseBtnTapped(_ sender: UIButton) {
        
        let firebaseInVC = storyboard?.instantiateViewController(withIdentifier: "FirebaseViewController") as! FirebaseViewController
        self.navigationController?.pushViewController(firebaseInVC, animated: true)
    }
    
    
    
}
    
    





