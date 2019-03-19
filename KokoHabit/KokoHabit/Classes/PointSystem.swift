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
    
    // what will it return?
    func checkNotifications() ->Notification
    {
        return notification;
    }
    
}
