import Foundation
import UIKit

class CheckboxManager {
    static let shared = CheckboxManager()
    
    private init() {}
    
    func createCheckbox(targetView: UIView, position: CGPoint, text: String) -> (UIButton, UILabel) {
        let checkbox = UIButton(type: .custom)
        checkbox.setImage(UIImage(named: "unchecked"), for: .normal)
        checkbox.setImage(UIImage(named: "checked"), for: .selected)
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        checkbox.frame = CGRect(origin: position, size: CGSize(width: 20, height: 20))
        
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        label.frame = CGRect(x: position.x + 25, y: position.y, width: 150, height: 20)
        
        targetView.addSubview(checkbox)
        targetView.addSubview(label)
        
        return (checkbox, label)
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // You can add logic here to handle checkbox selection/deselection.
    }
}




