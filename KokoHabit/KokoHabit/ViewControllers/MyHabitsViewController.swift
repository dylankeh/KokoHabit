//
//  MyHabitsViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class MyHabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! 
    // Phoenix: get selected habit name&point,pass to Edit page,diplay in the placeholder
    var selectedHabitName : String!
    var selectedHabitPoint : String!
    var selectedHabitId : Int!
    
    var isSameDay : Bool!
    
    let dao = DAO()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // putting the cells into sections instead of rows so that we can use cell margins to have spacing between cells
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate.habits.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! HabitCell
        
        cell.contentView.layoutMargins.bottom = 20
        cell.layer.cornerRadius = 10
        
        // setting the cell for sections instead of rows this way there will be a space (margin) between them
        cell.setHabit(habit: delegate.habits[indexPath.section])
        
        // setting how much of the cell should be colored
        // this shows the proportion of the habit in the cell's point value and the total for the day
        cell.setPercentageViewWidth(width: cell.frame.size.width - (cell.frame.size.width * CGFloat((100 - Double(delegate.habits[indexPath.section].getHabitValue())) / 100)))
        
        // if the habit in the cell is completed
        if (delegate.habits[indexPath.section].getCompletion()) {
            cell.setCompletedHabit() // style the cell as completed
        } else {
            cell.setUncompletedHabit() // style the cell as uncompleted
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! HabitCell
        
        let today = Date.init()
        
        // check if the habit in the cell is completed
        // if the cell is already completed
        if delegate.habits[indexPath.section].getCompletion() {
            //change the habit to uncompleted in the habit array
            delegate.habits[indexPath.section].setCompletion(completion: false)
            //change the completion status of the habit in the database
            dao.setHabitCompletetionStatus(day: today, habitId: delegate.habits[indexPath.section].getHabitId(), status: 0)
            cell.setUncompletedHabit()
        } else {
            //change the habit to completed in the habit array
            delegate.habits[indexPath.section].setCompletion(completion: true)
            //change the completion status of the habit in the database
            dao.setHabitCompletetionStatus(day: today, habitId: delegate.habits[indexPath.section].getHabitId(), status: 1)
            cell.setCompletedHabit()
        }
        // update the badge count
        delegate.setBadgeNumber(badgeNumber: delegate.habits.filter {!$0.getCompletion()} .count)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: {
            action, index in print("Delete button tapped")
            print(self.dao.deleteHabit(habitId: Int32(self.delegate.habits[indexPath.section].getHabitId())))
            self.delegate.habits.remove(at: indexPath.section)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            self.tableView.deleteSections(indexSet, with: .none)
        })
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: {
            ac, view, success in print("Edit button pressed")
            success(true)
            
            // Phoenix: get the current selected habit name and point
            let cell = tableView.cellForRow(at: indexPath) as! HabitCell
            self.selectedHabitName = cell.getHabitName()
            self.selectedHabitPoint = cell.getHabitPoint()
            print("id is: \(self.delegate.habits[indexPath.section].getHabitId())")
            self.selectedHabitId = self.delegate.habits[indexPath.section].getHabitId()
            
            self.performSegue(withIdentifier: "goToEditHabitPage", sender: self)
        })
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    // Phoenix: pass two values to Edit habit page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditHabitPage"
        {
            let editHabitController = segue.destination as! EditHabitViewController
            editHabitController.oldName = selectedHabitName
            editHabitController.oldPoint = selectedHabitPoint
            editHabitController.habitId = selectedHabitId
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    func load() {
        let today = Date.init()
        
        // if the current week is in the database
        if (dao.checkIfWeekExists(day: today)) {
            
            // if "today" is not in the database
            if (!dao.checkIfDayExists(day: today)){
                dao.insertDay(day: today)
                
                let pointSystem = PointSystem()
                // shuffle the habit points 
                pointSystem.randomPoints(habits: dao.getHabits(day: today))
            }
        // its a new week
        } else {
            // if the user reached their weekly point goal give them a coupon
            if (dao.checkIfUserPassedWeeklyPoints()) {
                dao.insertCoupon()
            }
            // insert new week
            dao.insertWeek(day: today)
            // insert new day
            dao.insertDay(day: today)
        }
        // get all the active habits
        delegate.habits = dao.getHabits(day: today)
        // update the badge count
        delegate.setBadgeNumber(badgeNumber: delegate.habits.filter {!$0.getCompletion()} .count)
        // refresh table
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func unWindToMyHabitVC(sender: UIStoryboardSegue) {}
    
    @IBAction func addNewHabit(sender: Any){
        
        // free users can only have 5 active habits at a time
        if delegate.habits.count < 5 {
            self.performSegue(withIdentifier: "addHabit", sender : nil)
        } else {
            // show an alert asking if they want to buy more habits
            let alertController = UIAlertController(title: "Habit Limit Reached", message: "You can only have 5 active habits on a free account. Do you want to pay $1.99 to unlock 5 more.", preferredStyle: .alert)
            
            // user chooses to purchase more habits
            let yesAction = UIAlertAction(title: "Buy", style: .default, handler: { (alert: UIAlertAction!) in
                
                // oh no theres a problems with the payment
                let alertController = UIAlertController(title: "Payment Error", message: "There was an error with your payment method please try again later.", preferredStyle: .alert);
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
                    alertController.addAction(cancelAction);
                self.present(alertController, animated: true);}
                )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(yesAction)
            present(alertController, animated: true)
        }
    }

}
