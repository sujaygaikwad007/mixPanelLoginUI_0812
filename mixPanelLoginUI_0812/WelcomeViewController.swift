


import UIKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var textTableData: UITableView!
    
    var userEmailArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTableData.backgroundColor = .clear
        textTableData.dataSource = self
        textTableData.delegate = self
        
        textTableData.register(UINib(nibName: "ResultTableCell", bundle: .none), forCellReuseIdentifier: "ResultTableCell")
        
        fetchUserFromFirebase()
        

    }
    
    
    
    func fetchUserFromFirebase()
    {
        
        if let user = Auth.auth().currentUser{
            
            let userEmail = user.email
            self.userEmailArray.append(userEmail ?? "No user found")
            
            DispatchQueue.main.async {
                self.textTableData.reloadData()

            }
            
            
            print("User Email: \(userEmail ?? "No email found")")
        }
        
    }
    

    

}

extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell", for: indexPath) as! ResultTableCell
        
        cell.lblResult?.text = userEmailArray[indexPath.row]
        
        return cell
    }
}



