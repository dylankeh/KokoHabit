//
//  ChangePasswordViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/4/14.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let dao = DAO()
    
    @IBOutlet weak var tfNewPassword: UITextField! {
        didSet {
            tfNewPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBAction func changePassword(_ sender: Any) {
        var newPassword: String = tfNewPassword.text!
        newPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var message: String = ""
        var messageColor: UIColor
        
        if (newPassword.count == 0) {
            message = "Please insert correct format of password!"
            messageColor = #colorLiteral(red: 1, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        } else {
            if (dao.updatePassword(password: newPassword)) {
                mainDelegate.user.setPassword(password: newPassword)
                message = "Change password successfully."
                messageColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else {
                message = "Cannot save password!"
                messageColor = #colorLiteral(red: 1, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        
        lblMessage.text = message
        lblMessage.textColor = messageColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
