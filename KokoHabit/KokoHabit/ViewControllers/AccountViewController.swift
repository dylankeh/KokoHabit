//
//  AccountViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019-04-12.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit
import WebKit

class AccountViewController: UIViewController, WKNavigationDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let dao = DAO()
    
    @IBOutlet weak var wbPage: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTotalHabits: UILabel!
    @IBOutlet weak var lblTotalPoints: UILabel!
    
    @IBOutlet weak var tfNewPassword: UITextFieldIcon!
    
    @IBOutlet weak var btnChangePassword: UIButton! {
        didSet {
            btnChangePassword.layer.cornerRadius = 22.5
            btnChangePassword.layer.shadowRadius = 3.0
            btnChangePassword.layer.shadowColor = UIColor.black.cgColor
            btnChangePassword.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
            btnChangePassword.layer.shadowOpacity = 0.25
            btnChangePassword.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var logoutBtn: UIButton! {
        didSet {
            logoutBtn.layer.cornerRadius = 22.5
            logoutBtn.layer.shadowRadius = 3.0
            logoutBtn.layer.shadowColor = UIColor.black.cgColor
            logoutBtn.layer.shadowOffset = CGSize(width: 0.0,height:  1.0)
            logoutBtn.layer.shadowOpacity = 0.25
            logoutBtn.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlAddress = URL(string: "https://www.quotesthatmotivate.com/random_quote.php")
        let url = URLRequest(url: urlAddress!)
        wbPage.load(url)
        wbPage.navigationDelegate = self
        lblTotalHabits.text = String(dao.getUserTotalHabitsCompleted())
        lblTotalPoints.text = String(dao.getUserTotalPoints())
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let newPassword = tfNewPassword.text!
        
    }
    
    @IBAction func logout() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        mainDelegate.setBadgeNumber(badgeNumber: 0)
        self.performSegue(withIdentifier: "logout", sender : nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        activity.isHidden = false
        activity.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
