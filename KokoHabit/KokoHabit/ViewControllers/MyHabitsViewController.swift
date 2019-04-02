//
//  MyHabitsViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class MyHabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Phoenix: get selected habit name&point,pass to Edit page,diplay in the placeholder
    var selectedHabitName : String!
    var selectedHabitPoint : String!
    
    
    let dao = DAO()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitCell
        
        cell.setHabit(habit: delegate.habits[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HabitCell
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let today = Date.init()
        if delegate.habits[indexPath.row].getCompletion() {
            delegate.habits[indexPath.row].setCompletion(completion: false)
            dao.setHabitCompletetionStatus(day: today, habitId: delegate.habits[indexPath.row].getHabitId(), status: 0)
            cell.setUncompletedHabit()
        } else {
            delegate.habits[indexPath.row].setCompletion(completion: true)
            dao.setHabitCompletetionStatus(day: today, habitId: delegate.habits[indexPath.row].getHabitId(), status: 1)
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
            
            // Phoenix: get the current selected habit name and point
            let cell = tableView.cellForRow(at: indexPath) as! HabitCell
            self.selectedHabitName = cell.getHabitName()
            self.selectedHabitPoint = cell.getHabitPoint()
            print("name is :\(cell.getHabitName())")
            print("point is :\(cell.getHabitPoint())")

            self.performSegue(withIdentifier: "goToEditHabitPage", sender: self)
        })
        editAction.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.8784313725, blue: 0.6078431373, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    // Phoenix: pass two values to Edit habit page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditHabitPage"
        {
            let editHabitController = segue.destination as! EditHabitViewController
            //print("name is :\(selectedHabitName ?? "null")")
            editHabitController.oldName = selectedHabitName
            editHabitController.oldPoint = selectedHabitPoint
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let today = Date.init()
        
        // check if the current week is in the database
        if (dao.checkIfWeekExists(day: today)) {
            
            // check if today is in the database
            if (dao.checkIfDayExists(day: today)) {
                dao.getHabits(day: today)
            } else {
                dao.insertDay(day: today)
                dao.getHabits(day: today)
            }
        } else {
    
            if (dao.checkIfUserPassedWeeklyPoints()) {
                dao.insertCoupon()
            }
            // insert new week
            dao.insertWeek(day: today)
            // insert new day
            dao.insertDay(day: today)
            dao.getHabits(day: today)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMyHabitsVC(sender : UIStoryboardSegue){ }
}
