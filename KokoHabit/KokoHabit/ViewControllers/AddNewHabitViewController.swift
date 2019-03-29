//
//  AddNewHabitViewController.swift
//  KokoHabit
//
//  Created by 葛青 on 3/19/19.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class AddNewHabitViewController: UIViewController {

    @IBOutlet var habitName: UITextField!
    @IBOutlet var habitPoint: UITextField!
    
    
    @IBAction func createAccount(sender:UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let dao = DAO()
        
        print(dao.addHabit(userEmail: mainDelegate.user.getEmail() as NSString, habitName:habitName.text! as NSString, habitPoint: Int32(habitPoint.text!)!))
        
        //Alert incase not inserted or error.. or alert to send them to the login page
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
