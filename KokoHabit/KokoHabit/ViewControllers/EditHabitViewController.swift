//
//  EditHabitViewController.swift
//  KokoHabit
//
//  Created by 葛青 on 3/19/19.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class EditHabitViewController: UIViewController {
    
    @IBOutlet var tfNewName : UITextField!
    @IBOutlet var tfNewPoint : UITextField!
    
    var oldName : String!
    var oldPoint : String!
    var habitId : Int!

    @IBAction func updateHabit(sender:UIButton) {
        let dao = DAO()
        if tfNewName.text != "" && tfNewPoint.text != ""
        {
            print(dao.updateHabit(id: Int32(habitId),
                            pointValue: Int32(tfNewPoint.text!)!,
                            name: tfNewName.text! as NSString))
        }
        else if tfNewName.text == "" && tfNewPoint.text != ""
        {
            print(dao.updateHabit(id: Int32(habitId),
                                  pointValue: Int32(tfNewPoint.text!)!,
                                  name: tfNewName.placeholder! as NSString))
        }
        else if tfNewPoint.text == "" && tfNewName.text != ""
        {
            print(dao.updateHabit(id: Int32(habitId),
                                  pointValue: Int32(tfNewPoint.placeholder!)!,
                                  name: tfNewName.text! as NSString))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfNewName.placeholder = oldName
        tfNewPoint.placeholder = oldPoint

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
