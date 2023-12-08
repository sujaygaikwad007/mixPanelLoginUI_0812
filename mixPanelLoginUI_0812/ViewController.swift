import UIKit


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.cornerRadius = 20
    }

    @IBAction func signupBtnTapped(_ sender: UIButton) {
        
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "createAccount") as! createAccount
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "signIn") as! signIn
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
}

