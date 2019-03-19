//
//  Habit.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class Habit: NSObject {
    private var habitName: String
    private var habitValue: Int
    private var completion: Bool
    
    init(habitName: String, habitValue: Int, completion: Bool) {
        self.habitName = habitName
        self.habitValue = habitValue
        self.completion = completion
    }
}