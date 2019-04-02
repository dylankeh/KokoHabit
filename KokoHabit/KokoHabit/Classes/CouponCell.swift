//
//  CouponCell.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/4/2.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCouponValue: UILabel!
    
    func setCoupon(coupon: Coupon, index: Int) {
        lblCoupon.text = "Coupon \(index)"
        lblCouponValue.text = "\(String(coupon.getPointValued())) points"
    }
    
    func setUsedCoupon(){
        lblCoupon.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        lblCouponValue.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
