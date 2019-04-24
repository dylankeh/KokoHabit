//
//  MyHabitsViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

enum Colors {
    static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
    static let blue = UIColor.blue
    static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
    static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
}

enum Images {
    static let box = UIImage(named: "Box.imageset/Box")!
    static let triangle = UIImage(named: "Triangle.imageset/Triangle")!
    static let circle = UIImage(named: "Circle.imageset/Circle")!
    static let swirl = UIImage(named: "Spiral.imageset/Spiral")!
}

class MyHabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! 
    // Phoenix: get selected habit name&point,pass to Edit page,diplay in the placeholder
    var selectedHabitName : String!
    var selectedHabitPoint : String!
    var selectedHabitId : Int!
    
    var isSameDay : Bool!
    
    var numberOfNotFinishedHabits : Int! = 0
    var isTheFirstDayInAWeek : Bool! = true
    @IBOutlet var lblock: UILabel!
    
    let dao = DAO()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // anim
    var emitter = CAEmitterLayer()
    var layerIsAdded : Bool! = false
    
    var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
        Images.swirl
    ]
    var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isTheFirstDayInAWeek == true
        {
            return true
        }
        return false
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
            numberOfNotFinishedHabits += 1
            // remove the effect maybe
            
            
        } else {
            //change the habit to completed in the habit array
            delegate.habits[indexPath.section].setCompletion(completion: true)
            //change the completion status of the habit in the database
            dao.setHabitCompletetionStatus(day: today, habitId: delegate.habits[indexPath.section].getHabitId(), status: 1)
            cell.setCompletedHabit()
            numberOfNotFinishedHabits -= 1
            if numberOfNotFinishedHabits == 0
            {
                if layerIsAdded == false
                {
                    // show animation and sound here
                    emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
                    emitter.emitterShape = CAEmitterLayerEmitterShape.line
                    emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
                    emitter.emitterCells = generateEmitterCells()
                    
                    self.view.layer.addSublayer(emitter)
                    print("added emitter layer")
                    layerIsAdded = true
                }
                print("num is \(String(numberOfNotFinishedHabits))")
                
                self.startParticles(emitterLayer: self.emitter)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    
                    self.endParticles(emitterLayer: self.emitter)
                })
                
            }
        }
        // update the badge count
        delegate.setBadgeNumber(badgeNumber: delegate.habits.filter {!$0.getCompletion()} .count)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Remove", handler: {
            action, index in print("Delete button tapped")
            let alertController = UIAlertController(title: "Remove Habit", message: "Are you sure you want to remove this habit?", preferredStyle: .alert)
            
            // user chooses to purchase more habits
            let yesAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alert: UIAlertAction!) in
                
                print(self.dao.deleteHabit(habitId: Int32(self.delegate.habits[indexPath.section].getHabitId())))
                self.delegate.habits.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                self.tableView.deleteSections(indexSet, with: .none)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(yesAction)
            self.present(alertController, animated: true)
            
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
        getNumOfNotFinishedHabits()
    }
    
    func load() {
        let today = Date.init()
        
        // if the current week is in the database
        if (dao.checkIfWeekExists(day: today)) {
            
            // if "today" is not in the database, which means second day, first time open
            if (!dao.checkIfDayExists(day: today)){
                dao.insertDay(day: today)
                
                let pointSystem = PointSystem()
                // shuffle the habit points 
                pointSystem.randomPoints(habits: dao.getHabits(day: today))
                isTheFirstDayInAWeek = false
                lblock.text = "🔒"
            }
            // if today is in the database, means it's the same day, second time open
            else
            {
                let weeks : [String] = dao.getAllStartWeeks()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                
                // when it is the second day
                if(weeks.last != dateFormatter.string(from: today))
                {
                    isTheFirstDayInAWeek = false
                    lblock.text = "🔒"
                }
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
            isTheFirstDayInAWeek = true;
            lblock.text = "🔑"
        }
        // get all the active habits
        delegate.habits = dao.getHabits(day: today)
        // update the badge count
        delegate.setBadgeNumber(badgeNumber: delegate.habits.filter {!$0.getCompletion()} .count)
        // refresh table
        tableView.reloadData()
    }

    func getNumOfNotFinishedHabits()
    {
        print(delegate.habits.count)
        numberOfNotFinishedHabits = delegate.habits.filter {!$0.getCompletion()} .count
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(delegate.habits.count)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.emitter.removeFromSuperlayer()
        self.layerIsAdded = false
    }
    
    @IBAction func unWindToMyHabitVC(sender: UIStoryboardSegue) {}
    
    @IBAction func addNewHabit(sender: Any){
        
        // free users can only have 5 active habits at a time
        if delegate.habits.count < 5 {
            self.performSegue(withIdentifier: "addHabit", sender : nil)
        } else {
            // show an alert asking if they want to buy more habits
            let alertController = UIAlertController(title: "Habit Limit Reached", message: "You can only have 5 active habits on a free account. Do you want to pay $1.99 to unlock 5 more.", preferredStyle: .actionSheet)
            
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
    
    // Phoenix: emitter animation
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            let cell = CAEmitterCell()
            
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            
            cells.append(cell)
        }
        return cells
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return colors[0].cgColor
        } else if i <= 8 {
            return colors[1].cgColor
        } else if i <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }
    
    func endParticles(emitterLayer:CAEmitterLayer) {
        emitterLayer.lifetime = 0.0
    }
    func startParticles(emitterLayer:CAEmitterLayer) {
        emitterLayer.lifetime = 14.0
    }
}
