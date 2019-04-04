//
//  LoginController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var email:UITextField!
    @IBOutlet var password:UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 22.5
        loginBtn.layer.shadowRadius = 3.0
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
        loginBtn.layer.shadowOpacity = 0.25
        loginBtn.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        let dao = DAO()
        let list: [String] = dao.getAllStartWeeks()
        
        for week in list {
            print(dao.checkUserWeeklyPointTotal(week: week))
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func login(sender:UIButton) {
        let dao = DAO()
        if (email.text! != "" && password.text! != "") {
            let user:User = dao.viewPerson(email: email!.text! as NSString)
            
            //Login to menu
            if(password!.text == user.getPassword()) {
                
                //Phoenix: store user info in AppDelegate for future use
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                mainDelegate.user = user
                
                self.performSegue(withIdentifier: "mainMenu", sender : nil)
                
            }
            else {
                
                let alertController = UIAlertController(title: "Failed Login", message: "The provided credentials do not match", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }
            
        }else {
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
