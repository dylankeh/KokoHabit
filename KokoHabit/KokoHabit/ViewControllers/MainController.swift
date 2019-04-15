//
//  MainController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-17.
//  Copyright © 2019 koko. All rights reserved.
//
// This view controller allows the users to choose to create or login to the application

import UIKit
import QuartzCore
class MainController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let dao = DAO()
    
    //Make this button look like the following at runtime
    @IBOutlet weak var signupBtn: UIButton! {
        didSet {
            signupBtn.layer.borderColor = UIColor.white.cgColor
            signupBtn.layer.borderWidth = 2.0
            signupBtn.layer.cornerRadius = 22.5
            signupBtn.layer.shadowRadius = 3.0
            signupBtn.layer.shadowColor = UIColor.black.cgColor
            signupBtn.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
            signupBtn.layer.shadowOpacity = 0.25
            signupBtn.layer.masksToBounds = false
        }
    }
    
    //Make this button look like the following at runtime
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
    
    //This will avoid the use to login again if the user closes the app and does not log out
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let currentUserEmail = defaults.object(forKey: "currentUserEmail") as? String {
            mainDelegate.user = dao.viewPerson(email: currentUserEmail as NSString)
            self.performSegue(withIdentifier: "habitSegue", sender : nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //This segue will allow us to return from other views.
    @IBAction func unWindToHome(sender: UIStoryboardSegue) {
        
    }

}
