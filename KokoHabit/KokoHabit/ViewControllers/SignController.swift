//
//  SignController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class SignController: UIViewController {
    
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(sender:UIButton) {
        let dao = DAO()
        let occupetion:NSString = "Unknown"
        
        if (password.text! == confirmPassword.text! && password.text! != ""
            && email.text! != "" && name.text != "") {
            dao.addPerson(email: email!.text! as NSString, name: name!.text! as NSString, age: -1, password: password!.text! as NSString, occupation: occupetion)
            
            dismiss(animated: true, completion: nil)
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
