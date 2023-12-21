import UIKit
import Reachability


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var firebaseBtn: UIButton!
    
    var reachability: Reachability!

    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.cornerRadius = 20
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        checkInternetConnectivity()


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
    
    
    
    // check network connectivity--start

    func checkInternetConnectivity(){
           
           do{
               reachability = try Reachability()
               try reachability.startNotifier()
           } catch {
               print("unable to start reachability")
           }
           
           NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
       }
       
       deinit{
           reachability.stopNotifier()
           NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
       }
       
       @objc func reachabilityChanged(_ notification: Notification){
           guard let reachability = notification.object as? Reachability else { return }
           
           if reachability.connection == .unavailable {
               
               showToast(controller: self, message: "Please connect your internet", seconds: 5)
           }
       }
       // check network connectivity--end

    
    
    
}
    
    





