//
//  LoginController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet var email:UITextField!
    @IBOutlet var password:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(sender:UIButton) {
        let dao = DAO()
        let user:User = dao.viewPerson(email: email!.text! as NSString)
        
        //Login to menu
        if(password!.text == user.getPassword()) {
            
            self.performSegue(withIdentifier: "mainMenu", sender : nil)
            
        }
        // Alert Wrong password
        else {
            print("We out bitches");
        }
    }

}
