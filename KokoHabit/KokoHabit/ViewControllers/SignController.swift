//
//  SignController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class SignController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet weak var signupBtn: UIButton! {
        didSet {
            signupBtn.layer.cornerRadius = 22.5
            signupBtn.layer.shadowRadius = 3.0
            signupBtn.layer.shadowColor = UIColor.black.cgColor
            signupBtn.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
            signupBtn.layer.shadowOpacity = 0.25
            signupBtn.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func createAccount(sender:UIButton) {
        let dao = DAO()
        let occupetion:NSString = "Unknown"
        
        if (password.text! == confirmPassword.text! && password.text! != ""
            && email.text! != "" && name.text != "") {
            if (email.text!.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")) {
                dao.addPerson(email: email!.text! as NSString, name: name!.text! as NSString, age: -1, password: password!.text! as NSString, occupation: occupetion)
                
                dismiss(animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Invalid Sign Up", message: "Not a valid email address", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
        }
        else if(password.text! != confirmPassword.text!) {
            let alertController = UIAlertController(title: "Invalid Password", message: "The password does not match", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }
        else if(password.text! == "") {
            let alertController = UIAlertController(title: "Invalid Password", message: "Password cannot be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }
        else {
            let alertController = UIAlertController(title: "Invalid Login", message: "All the fields have to be filled up", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
        }
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
