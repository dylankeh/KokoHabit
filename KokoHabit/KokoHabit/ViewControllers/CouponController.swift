//
//  CouponController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019/4/2.
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
        cell.setCoupon(coupon: delegate.coupons[indexPath.row],index: indexPath.row+1)
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dao.getCoupons()
    }
}
