//
//  CouponController.swift
//  KokoHabit
//
//  This controller shows a list of the user's unused coupons
//
//  Created by Arthur Tran on 2019/4/2.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class CouponController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let dao = DAO()
    let delegate = UIApplication.shared.delegate as! AppDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as! CouponCell
        cell.setCoupon(coupon: delegate.coupons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CouponCell
        
        // if the user decides to use a coupon show them alert asking for confirmation since once coupons are used they cant be "unused" or redeemed again
        let alertController = UIAlertController(title: "Use Coupon", message: "Are you sure you want to use this coupon?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default ,
                                      handler:  { (alert: UIAlertAction!) in
                                        cell.setUsedCoupon(); // style the coupon as used
                                        // set the coupon as used today in the database
                                        self.dao.useCoupon(day: Date.init(), couponId: self.delegate.coupons[indexPath.row].getCouponId());
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dao.getCoupons()
    }
}
