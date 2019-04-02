//
//  Habit.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/3/17.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class Habit: NSObject {
    private var habitId: Int
    private var habitName: String
    private var habitValue: Int
    private var completion: Bool
    
    init(habitId: Int, habitName: String, habitValue: Int, completion: Bool) {
        self.habitId = habitId
        self.habitName = habitName
        self.habitValue = habitValue
        self.completion = completion
    }
    
    func getHabitId() -> Int {
        return habitId
    }
    
    func getHabitName() -> String {
        return habitName
    }
    
    
    func getHabitValue() -> Int {
        return habitValue
    }
    
    func getCompletion() -> Bool {
        return completion
    }
    
    func setHabitId(habitId: Int) {
        self.habitId = habitId
    }
    
    func setHabitName(habitName: String) {
        self.habitName = habitName
    }
    
    func setHabitValue(habitValue: Int) {
        self.habitValue = habitValue
    }
    
    func setCompletion(completion: Bool) {
        self.completion = completion
    }
}
