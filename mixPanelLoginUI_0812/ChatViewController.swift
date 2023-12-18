
import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    
    
    var messages = [Message]()
    let selfSender = Sender(senderId: "1",
                            displayName: "Jack")
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        
        configureMessageInputBar()
        observeMessages()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    func configureMessageInputBar() {
            messageInputBar.delegate = self
            messageInputBar.inputTextView.placeholder = "Type a message..."
            messageInputBar.sendButton.setTitle("Send", for: .normal)
  }

    
    

    
    
    func observeMessages() {
        guard let user = Auth.auth().currentUser else { return }

        let ref = Database.database().reference().child("messages").child(user.uid)

        ref.observe(.childAdded) { snapshot in
            if let messageData = snapshot.value as? [String: Any],
               let senderId = messageData["senderId"] as? String,
               let displayName = messageData["displayName"] as? String,
               let text = messageData["text"] as? String,
               let timestamp = messageData["timestamp"] as? TimeInterval
            {
                let sender = Sender(senderId: senderId, displayName: displayName)
                let message = Message(sender: sender, messageId: snapshot.key, sentDate: Date(timeIntervalSince1970: timestamp), kind: .text(text))
                self.messages.append(message)
                self.messagesCollectionView.reloadData()
            }
        }
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

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        sendMessage(text: text)
        inputBar.inputTextView.text = ""
    }
}


extension ChatViewController {
    func sendMessage(text: String) {
        guard let user = Auth.auth().currentUser else { return }

        let ref = Database.database().reference().child("messages").child(user.uid)

        let messageData: [String: Any] = [
            "senderId": user.uid,
            "displayName": user.displayName ?? "",
            "text": text,
            "timestamp": ServerValue.timestamp()
        ]

        ref.childByAutoId().setValue(messageData) { (error, _) in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
}

