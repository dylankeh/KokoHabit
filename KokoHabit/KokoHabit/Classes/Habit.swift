//
//  Habit.swift
//  KokoHabit
//
//  This is Habit class that use to create each habit
//  habitId is integer type that the id for each habit
//  habitName is String type that briefly description for each habit
//  habitValue is integer type that the point value for each habit
//  completion is the Bool type that repersent this habit completed or not
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
