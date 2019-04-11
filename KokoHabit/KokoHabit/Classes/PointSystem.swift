//
//  PointSystem.swift
//  KokoHabit
//
//  Created by 葛青 on 3/19/19.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class PointSystem: NSObject {
    
    private var dao : DAO!
    private var user : User!
    private var notification : Notification!
    
    func getUser() ->User
    {
        return user;
    }
    
    func randomPoints(habits: [Habit])
    {
        dao = DAO.init()
        // create a new array to record the points of all the active habits
        var points: [Int] = []
        
        for habit in habits
        {
            points.append(habit.getHabitValue())
        }
        
        points.shuffle()
        
        for index in 0..<habits.count {
            habits[index].setHabitValue(habitValue: points[index])
        }
        
        // change database value
        dao.updatePointsAfterRandom(habits: habits)
    }
    
    // what will it return?
    func checkNotifications() ->Notification
    {
        return notification;
    }
    
}
