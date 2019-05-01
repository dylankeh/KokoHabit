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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func createHabit(sender:UIButton) {
        
        if habitName.text == "" || habitPoint.text == ""
        {
            let alert = UIAlertController(title: "Warning!"
                , message: "Please enter both the habit name and the point value."
                , preferredStyle: .alert)
            let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(noAction)
            present(alert, animated: true)
        }
        else if Int(habitPoint.text!) == nil || Int(habitPoint.text!)! <= 0
        {
            let alert = UIAlertController(title: "Warning!"
                , message: "Point should be a positive integer number."
                , preferredStyle: .alert)
            let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(noAction)
            present(alert, animated: true)
        }
        else if delegate.habitTotalPointLimit - Int(habitPoint.text!)! < 0
        {
            let alert = UIAlertController(title: "Warning!"
                , message: "Point will be over limit of 100. You only have \(delegate.habitTotalPointLimit!) avaliable points to allocate."
                , preferredStyle: .alert)
            let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(noAction)
            present(alert, animated: true)
            
        }
        else
        {
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let dao = DAO()
            
            print(dao.addHabit(email: mainDelegate.user.getEmail() as NSString, pointValue: Int32(habitPoint.text!)!, name: habitName.text! as NSString))
            delegate.habitTotalPointLimit = delegate.habitTotalPointLimit - Int(habitPoint.text!)!
            
            let alert = UIAlertController(title: "Success!"
                , message: "Added habit successfully."
                , preferredStyle: .alert)
            let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(noAction)
            present(alert, animated: true)
            
            //dismiss(animated: true, completion: nil)
        }
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
