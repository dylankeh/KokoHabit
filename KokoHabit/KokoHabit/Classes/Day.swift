//
//  Day.swift
//  KokoHabit
//
//  Created by Arthur Tran on 2019-03-30.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class Day: NSObject {
    
    private var date: Date;
    private var minimumPointRequirement: Int;
    private var pointsAchieved: Int;
    
    init(date: Date, minimumPointRequirement: Int, pointsAchieved: Int) {
        self.date = date
        self.minimumPointRequirement = minimumPointRequirement
        self.pointsAchieved = pointsAchieved
    }
}
