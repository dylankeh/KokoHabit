//
//  HabitCell.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/28.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class HabitCell: UITableViewCell {

    @IBOutlet weak var lblHabitName: UILabel!
    
    func setHabit(habit: Habit) {
        print(habit)
        lblHabitName.text = habit.getHabitName()
    }
    
    func setCompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func setUncompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.7766154408, green: 0.2747580707, blue: 0.221539259, alpha: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
