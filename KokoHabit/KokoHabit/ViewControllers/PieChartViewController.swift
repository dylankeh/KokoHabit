//
//  PieChartViewController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-04-04.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet var output: UILabel!
     private var habitPoints = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let months = ["Jan", "Feb", "Mar", "Apr", "May"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
        habitPoints.removeAll()
        
        for i in 0..<unitsSold.count {
            let pointEntry = PieChartDataEntry(value: unitsSold[i])
            pointEntry.label = months[i]
            habitPoints.append(pointEntry)
        }
        setChart()
    }
    
    func setChart() {
        
        let pieChartDataSet = PieChartDataSet(entries: habitPoints, label: nil)
        pieChartDataSet.drawIconsEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<habitPoints.count {
         let red = Double(arc4random_uniform(256))
         let green = Double(arc4random_uniform(256))
         let blue = Double(arc4random_uniform(256))
         
         let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
         colors.append(color)
         }
        
        pieChartDataSet.colors = colors//ChartColorTemplates.colorful()//ChartColorTemplates.vordiplom()
        
    }

}
