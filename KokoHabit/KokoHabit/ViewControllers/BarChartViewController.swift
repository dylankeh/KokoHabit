//
//  BarChartViewController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-04-03.
//  Copyright © 2019 koko. All rights reserved.
//
// This view pie chart controller will display the weekly progress
// for each habit. But it also colors the weeks of a month
// with the same colour.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    private var weeks: [String] = []
    private var points: [Double] = []


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This method gets the values from the database
    // loaded everytime the user enters in the monthly progress chart
    override func viewWillAppear(_ animated: Bool) {
        
        let dao = DAO()
        weeks = dao.getAllStartWeeks()
        
        for week in weeks {
            print(week)
            points.append(dao.getUserWeeklyPointTotal(week: week))
        }
        
        setChart(dataPoints: weeks, values: points)
    }
    
    // This method sets the right components for the chart,
    // it also sets the correct data.
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "No progress data available yet."
        
        var dataEntries: [BarChartDataEntry] = []
        
        //Loop all of the value entries into the chart
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        barChartView.data = chartData
        
        //No Zoomin in manually
        barChartView.doubleTapToZoomEnabled = false
        
        //Zoomed into the first 4 weeks
        barChartView.setVisibleXRangeMaximum(4)
        barChartView.moveViewToX(0)
        
        //Clean colors
        chartDataSet.colors.removeAll()
        
        //Setting the color for thr bars
        for i in 0..<ChartColorTemplates.vordiplom().count {
            //For 4 weeks each color pattern
            chartDataSet.colors.append(ChartColorTemplates.vordiplom()[i])
            chartDataSet.colors.append(ChartColorTemplates.vordiplom()[i])
            chartDataSet.colors.append(ChartColorTemplates.vordiplom()[i])
            chartDataSet.colors.append(ChartColorTemplates.vordiplom()[i])
        }
        
        //Animations and making it look pretty
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:weeks)
        barChartView.xAxis.granularity = 1
        
        //Getting rid of lines
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        
        //Setting the height of the graph
        barChartView.leftAxis.axisMaximum = 710;
    }
}
