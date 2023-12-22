
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

protocol WelcomeViewControllerDelegate: AnyObject {
    func didSignOut()
}


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var textTableData: UITableView!
    @IBOutlet weak var lblDisplayUserName: UILabel!
    
    @IBOutlet weak var signOutBtnVar: UIButton!
    
    var users: [User] = []
    var currentUser: User?
    
    
    var  JGprogress : JGProgressHUD!
    
    weak var delegate: WelcomeViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        signOutBtnVar.isHidden = true
        
        textTableData.dataSource = self
        textTableData.delegate = self
        
        JGprogress = JGProgressHUD(style: .dark)
        
        
        textTableData.register(UINib(nibName: "ResultTableCell", bundle: .none), forCellReuseIdentifier: "ResultTableCell")
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            fetchUserFromFirebase()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func fetchUserFromFirebase() {
        
        JGprogress.show(in: self.view)
        
        let ref = Database.database().reference().child("users")
        
        ref.observe(.value) { [self] snapshot in
            self.users.removeAll()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String:Any],
                   let username = userData["username"] as? String,
                   let email = userData["email"] as? String,
                   let uid = userData["uid"] as? String
                {
                    let user = User(username: username, email: email, uid: uid, messages: [])
                   // print("User from Database----\(user)")
                    self.users.append(user)
                    
                    
                }
            }
            
            self.users = self.users.filter { $0.uid != Auth.auth().currentUser?.uid }
           
            
            
            DispatchQueue.main.async {
                
                self.lblDisplayUserName.text = "Welcome!"
                self.signOutBtnVar.isHidden = false
                self.textTableData.reloadData()
                self.JGprogress.dismiss(animated: true)
                
            }
        }
    }
    
    
    @IBAction func signOutBtn(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            delegate?.didSignOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }
    
    
    
}

extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell", for: indexPath) as! ResultTableCell
        
        let user = users[indexPath.row]
        
        
        
        cell.lblUserName.text = user.username
        cell.lblUserEmail.text = user.email
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        chatVC.title = user.username
        
        chatVC.receiverUid = user.uid
        
        
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



