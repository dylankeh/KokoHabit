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
        
        if (password.text! == confirmPassword.text! && password.text! != "") {
            print(dao.addPerson(email: email!.text! as NSString, name: name!.text! as NSString, age: -1, password: password!.text! as NSString, occupation: occupetion))
            
            self.performSegue(withIdentifier: "loginPage", sender : nil)
        }
    
        //Alert incase not inserted or error.. or alert to send them to the login page
    }
}
