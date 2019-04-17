//
//  CouponCell.swift
// This is a class for a coupon cell
//  KokoHabit
//
//  Created by Arthur Tran on 2019/4/2.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var lblCouponValue: UILabel!
    @IBOutlet weak var couponRowImage: UIImageView!
    
    func setCoupon(coupon: Coupon) {
        lblCouponValue.text = "\(String(coupon.getPointValued())) Points"
    }
    
    func setUsedCoupon(){
        lblCouponValue.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        couponRowImage.image = UIImage(named: "coupon_row_used")
        self.isUserInteractionEnabled = false;

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
