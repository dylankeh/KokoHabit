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
    @IBOutlet weak var lblHabitPoint: UILabel!
    @IBOutlet weak var percentageView: UIView!
    
    
    func setHabit(habit: Habit) {
        print(habit)
        lblHabitName.text = habit.getHabitName()
        lblHabitPoint.text = String(habit.getHabitValue())
    }
    
    func setCompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lblHabitPoint.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        percentageView.backgroundColor = UIColor.init(colorWithHexValue: 0xCCCCCC)
    }
    
    func setUncompletedHabit(){
        lblHabitName.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lblHabitPoint.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        percentageView.backgroundColor = UIColor.init(colorWithHexValue: 0xE18988)
    }
    
    func setPercentageViewFrame(frame: CGRect) {
        percentageView.frame = frame
    }
    
    func setPercentageViewWidth(width: CGFloat) {
        percentageView.frame = CGRect(x: self.percentageView.frame.minX, y: self.percentageView.frame.minY, width: width, height: self.percentageView.frame.size.height)
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
            }

}
