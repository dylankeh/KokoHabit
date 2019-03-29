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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
