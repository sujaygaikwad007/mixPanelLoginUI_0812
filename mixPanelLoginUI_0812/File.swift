import Foundation
import UIKit

// Code for  Icon---- Start
func addIconToTextField(textField: UITextField, iconName: String) {
    let iconImageView = UIImageView(image: UIImage(named: iconName))
    iconImageView.contentMode = .scaleAspectFit
    
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height)) // Adjust the width as needed
    
    iconContainerView.addSubview(iconImageView)
    iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: textField.frame.height) // Adjust the positioning and size of the icon
    
    textField.leftView = iconContainerView
    textField.leftViewMode = .always
}

// Code for  Icon---- ENd



//Function for alert message

func showToast(controller:UIViewController ,message:String,seconds:Double)
{
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.alpha = 0.6
    alert.view.layer.cornerRadius = 15
    let CancelBtn = UIAlertAction(title: "Close", style: .destructive)
    alert.addAction(CancelBtn)
    
    controller.present(alert, animated: true, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + seconds)
    {
        alert.dismiss(animated: true)
    }
}


//Function for alert message end


