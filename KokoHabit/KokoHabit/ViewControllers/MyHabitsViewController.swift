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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMyHabitsVC(sender : UIStoryboardSegue){ }
}
