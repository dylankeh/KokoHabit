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
    @IBOutlet var totalPoints: UILabel!
    private var habitPoints = [PieChartDataEntry]()
    private var habits: [Habit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pieChartView.noDataText = "No progress data available yet."
        let dao = DAO()
        habits = dao.getHabitProgress()
        var dailyPointMax: Int = 0;
        
        habitPoints.removeAll()
        
        for i in 0..<habits.count {
            let pointEntry = PieChartDataEntry(value: Double(habits[i].getHabitValue()))
            pointEntry.label = habits[i].getHabitName()
            habitPoints.append(pointEntry)
            dailyPointMax += habits[i].getHabitValue()
        }
        totalPoints.text = String(dao.checkUserDayPointTotal(day: Date())) + "/" + String(dailyPointMax)
        setChart()
    }
    
    func setChart() {
        
        let pieChartDataSet = PieChartDataSet(entries: habitPoints, label: nil)
        pieChartDataSet.drawIconsEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [NSUIColor] = []
        
        for i in 0..<habitPoints.count {
            if (!habits[i].getCompletion()) {
                colors.append(NSUIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0))
            }
            else {
                colors.append(ChartColorTemplates.vordiplom()[i])
            }
         }
            
        pieChartDataSet.colors = colors
        pieChartDataSet.entryLabelColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: 1)
        pieChartDataSet.valueColors = [UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: 1)]
    }
}
