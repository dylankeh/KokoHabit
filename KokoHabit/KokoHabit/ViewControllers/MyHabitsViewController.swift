//
//  MyHabitsViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class MyHabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var testHabit = Habit(habitName: "Eat an apple", habitValue: 40, completion: false)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitCell
        
        cell.setHabit(habit: testHabit)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HabitCell
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if testHabit.getCompletion() {
            testHabit.setCompletion(completion: false)
            cell.setUncompletedHabit()
        } else {
            testHabit.setCompletion(completion: true)
            cell.setCompletedHabit()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: {
            action, index in print("Favourite button tapped")
        })
        deleteAction.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.2745098039, blue: 0.2196078431, alpha: 1)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {
            ac, view, success in print("Modify button pressed")
            success(true)
        })
        editAction.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.8784313725, blue: 0.6078431373, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMyHabitsVC(sender : UIStoryboardSegue){ }
}
