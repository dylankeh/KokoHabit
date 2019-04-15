//
//  LoginController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//
// This method works the functionality
// of the login page

import UIKit

class LoginController: UIViewController, UITextFieldDelegate{
    
    //At runtime provide the following to the Textfield
    @IBOutlet var email:UITextFieldIcon! {
        didSet {
            email.tintColor = UIColor.lightGray
            email.setIcon(UIImage(named: "user-icon")!)
            email.borderStyle = UITextField.BorderStyle.roundedRect
        }
    }
    
    //At runtime provide the following to the Textfield
    @IBOutlet var password:UITextFieldIcon! {
        didSet {
            password.tintColor = UIColor.lightGray
            password.setIcon(UIImage(named: "lock")!)
            password.borderStyle = UITextField.BorderStyle.roundedRect
            password.isSecureTextEntry = true

        }
    }
    
    //At runtime provide the following to the Textfield
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
            loginBtn.layer.cornerRadius = 22.5
            loginBtn.layer.shadowRadius = 3.0
            loginBtn.layer.shadowColor = UIColor.black.cgColor
            loginBtn.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
            loginBtn.layer.shadowOpacity = 0.25
            loginBtn.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //The text field returns
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //This method implements the logining
    @IBAction func login(sender:UIButton) {
        let dao = DAO()
        if (email.text! != "" && password.text! != "") {
            let user:User = dao.viewPerson(email: email!.text! as NSString)
            
            //Login to menu
            if(password!.text == user.getPassword()) {
                
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                mainDelegate.user = user
                let defaults = UserDefaults.standard
                defaults.set(user.getEmail(), forKey: "currentUserEmail")
                defaults.synchronize()
                self.performSegue(withIdentifier: "mainMenu", sender : nil)
                
            }
            else {
                
                let alertController = UIAlertController(title: "Failed Login", message: "The provided credentials do not match", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
            
        } else {
            let alertController = UIAlertController(title: "Failed Login", message: "Fields must be filled up", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
    
    @IBAction func backHome(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// This class extends the functionality of the UITextField, by using a set Icon
// method to set an icon inside of it
extension UITextField {
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
