
import UIKit
import MessageKit
import Firebase

class ChatViewController: MessagesViewController {
    
    @IBOutlet weak var currentUserNameLbl: UILabel!
    
    
    var messages = [Message]()
    let selfSender = Sender(senderId: "1",
                            displayName: "Jack")

    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("UerName of current use----\(currentUserName)")
        //self.currentUserNameLbl.text = !currentUserName.isEmpty ? self.currentUserName : ""

    }
    



}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
    
}
