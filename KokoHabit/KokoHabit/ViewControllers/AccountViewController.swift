//
//  AccountViewController.swift
//  KokoHabit
//
//  Created by Xiaoyu Liang on 2019-04-12.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit
import WebKit

//  The ViewController that show user about their accont infomation and quote
class AccountViewController: UIViewController, WKNavigationDelegate {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    let dao = DAO()
    
    @IBOutlet weak var wbPage: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var lblTotalHabits: UILabel!
    @IBOutlet weak var lblTotalPoints: UILabel!
    
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
    
    @IBAction func logout() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        mainDelegate.setBadgeNumber(badgeNumber: 0)
        self.performSegue(withIdentifier: "logout", sender : nil)
    }
    
    //Before the webView show up
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    
    //After the webView show up
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }
    
    @IBAction func unWindToAccountVC(sender: UIStoryboardSegue) {}
}
