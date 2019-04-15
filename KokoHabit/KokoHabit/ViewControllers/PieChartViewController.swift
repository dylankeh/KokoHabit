//
//  PieChartViewController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-04-04.
//  Copyright © 2019 koko. All rights reserved.
//
// This Pie Chart Controller manages the display of the daily progress
// keeping track of which habits have been completed.
// And also the total points completed on that day.

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
    
    //This method will be triggered every time switched into the screen
    override func viewWillAppear(_ animated: Bool) {
        pieChartView.noDataText = "No progress data available yet."
        let dao = DAO()
        habits = dao.getHabitProgress()
        var dailyPointMax: Int = 0;
        
        //Remove any old habit data
        habitPoints.removeAll()
        
        for i in 0..<habits.count {
            let pointEntry = PieChartDataEntry(value: Double(habits[i].getHabitValue()))
            pointEntry.label = habits[i].getHabitName()
            habitPoints.append(pointEntry)
            dailyPointMax += habits[i].getHabitValue()
        }
        
        //Set the total points for the day
        totalPoints.text = String(dao.getUserDayPointTotal(day: Date())) + "/" + String(dailyPointMax)
        setChart()
    }
    
    //This function draws the chart with the data from the database
    func setChart() {
        
        let pieChartDataSet = PieChartDataSet(entries: habitPoints, label: nil)
        
        pieChartDataSet.drawIconsEnabled = false
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [NSUIColor] = []
        
        //Setting grey any habit not completed other wise grab a color from the default colour chart
        for i in 0..<habitPoints.count {
            if (!habits[i].getCompletion()) {
                colors.append(NSUIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 1.0))
            }
            else {
                colors.append(ChartColorTemplates.vordiplom()[i])
            }
         }
        
        //Settting the colors for the entire chart
        pieChartDataSet.colors = colors
        pieChartView.legend.enabled = false
        pieChartDataSet.entryLabelColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: 1)
        pieChartDataSet.valueColors = [UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: 1)]
    }
}
