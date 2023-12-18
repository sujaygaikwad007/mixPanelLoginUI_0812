
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var textTableData: UITableView!
    @IBOutlet weak var lblDisplayUserName: UILabel!
    
    var users: [User] = []
    var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTableData.dataSource = self
        textTableData.delegate = self
        
        textTableData.register(UINib(nibName: "ResultTableCell", bundle: .none), forCellReuseIdentifier: "ResultTableCell")
        
       fetchUserFromFirebase()
        
    }
    
    
    
    
    func fetchUserFromFirebase() {
        let ref = Database.database().reference().child("users")

        ref.observe(.value) { snapshot in
            self.users.removeAll()

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userData = childSnapshot.value as? [String:Any],
                   let username = userData["username"] as? String,
                   let email = userData["email"] as? String,
                   let uid = userData["uid"] as? String
                {

                    let user = User(username: username, email: email, uid: uid)
                    self.lblDisplayUserName.text = "Welcome"
                    self.users.append(user)
                }
            }


            DispatchQueue.main.async {
                self.textTableData.reloadData()
            }
        }
    }
    
    
    
    
    
    
    @IBAction func signOutBtn(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
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
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



