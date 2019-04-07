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
    
    // Phoenix: point should be display on the habit panel as well
    @IBOutlet weak var lblHabitPoint: UILabel!
    
    func setHabit(habit: Habit) {
        print(habit)
        lblHabitName.text = habit.getHabitName()
        lblHabitPoint.text = String(habit.getHabitValue())
    }
    
    func setCompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lblHabitPoint.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func setUncompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lblHabitPoint.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    // Phoenix: add two gets functions
    func getHabitName() -> String{
        return lblHabitName.text!
    }
    func getHabitPoint() -> String{
        return lblHabitPoint.text!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //layoutSubviews()
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

}
