//
//  Coupon.swift
//  Class to represent a coupon
//  Coupons allow users to meet their daily minimum point requirement when they're falling behind
//  Coupons are given out once a week, at the beginning of the week, if the user has met the daily minimum point requirement for the entire week
//
//  KokoHabit
//
//  Created by Arthur Tran on 2019-04-02.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class Coupon: NSObject {
    private var couponId: Int
    private var pointValue: Int // how much points the coupon is worth, this is equivalent to a habit point value
    
    init(couponId: Int, pointValue: Int) {
        self.couponId = couponId
        self.pointValue = pointValue
    }
    
    func getCouponId() -> Int {
        return couponId
    }
    
    func setCouponId(couponId: Int) {
        self.couponId = couponId
    }
    
    func getPointValued() -> Int {
        return pointValue
    }
    
    func setPointValue(pointValue: Int) {
        self.pointValue = pointValue
    }
    
}
