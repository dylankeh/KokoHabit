//
//  Coupon.swift
//  KokoHabit
//
//  Created by Arthur Tran on 2019-04-02.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class Coupon: NSObject {
    private var couponId: Int
    private var pointValue: Int
    
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
