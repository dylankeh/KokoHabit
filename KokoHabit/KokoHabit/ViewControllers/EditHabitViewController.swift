//
//  EditHabitViewController.swift
//  KokoHabit
//
//  Created by Qing Ge Phoenix on 3/19/19.
//  Copyright © 2019 koko. All rights reserved.
//
//  This controller contains funtion of editing habits and checking point limit

import UIKit

class EditHabitViewController: UIViewController {
    
    @IBOutlet var tfNewName : UITextField!
    @IBOutlet var tfNewPoint : UITextField!
    
    var oldName : String!
    var oldPoint : String!
    var habitId : Int!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBAction func updateHabit(sender:UIButton) {
        let dao = DAO()
        if tfNewName.text != "" && tfNewPoint.text != ""
        {
            if Int(tfNewPoint.text!) == nil || Int(tfNewPoint.text!)! <= 0
            {
                let alertTitle : String = "Warning!";
                let alertMessage : String = "Point should be a positive integer number.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
            else if Int(tfNewPoint.placeholder!)! < Int(tfNewPoint.text!)!
                && delegate.habitTotalPointLimit + Int(tfNewPoint.placeholder!)! - Int(tfNewPoint.text!)! < 0
            {
                let alertTitle : String = "Warning!";
                let alertMessage : String = "Point will be over limit of 100. You only have \(delegate.habitTotalPointLimit!) avaliable points to allocate.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
            else
            {
                print(dao.updateHabit(id: Int32(habitId),
                                      pointValue: Int32(tfNewPoint.text!)!,
                                      name: tfNewName.text! as NSString))
                let alertTitle : String = "Success!";
                let alertMessage : String = "You updated the habit name and point successfully.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
        }
        else if tfNewName.text == "" && tfNewPoint.text != ""
        {
            if Int(tfNewPoint.text!) == nil || Int(tfNewPoint.text!)! <= 0
            {
                let alertTitle : String = "Warning!";
                let alertMessage : String = "Point should be a positive integer number.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
            else if Int(tfNewPoint.placeholder!)! < Int(tfNewPoint.text!)!
                && delegate.habitTotalPointLimit + Int(tfNewPoint.placeholder!)! - Int(tfNewPoint.text!)! < 0
            {
                let alertTitle : String = "Warning!";
                let alertMessage : String = "Point will be over limit of 100. You only have \(delegate.habitTotalPointLimit!) avaliable points to allocate.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
            else
            {
                print(dao.updateHabit(id: Int32(habitId),
                                      pointValue: Int32(tfNewPoint.text!)!,
                                      name: tfNewName.placeholder! as NSString))
                let alertTitle : String = "Success!";
                let alertMessage : String = "You updated the habit point successfully.";
                popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
            }
        }
        else if tfNewPoint.text == "" && tfNewName.text != ""
        {
            print(dao.updateHabit(id: Int32(habitId),
                                  pointValue: Int32(tfNewPoint.placeholder!)!,
                                  name: tfNewName.text! as NSString))
            let alertTitle : String = "Success!";
            let alertMessage : String = "You updated the habit name successfully.";
            popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
        }
        else
        {
            let alertTitle : String = "Warning!";
            let alertMessage : String = "Please enter the new name and/or the new point for this habit.";
            popUpAlert(alertTitle: alertTitle, alertMessage: alertMessage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfNewName.placeholder = oldName
        tfNewPoint.placeholder = oldPoint

        // Do any additional setup after loading the view.
    }
    
    func popUpAlert(alertTitle: String, alertMessage: String)
    {
        let alert = UIAlertController(title: alertTitle
            , message: alertMessage
            , preferredStyle: .alert)
        let noAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(noAction)
        present(alert, animated: true)
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
