//
//  BarChartViewController.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-04-03.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    var months: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        months = ["12-02-2019", "20-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019", "30-02-2019"]
        let unitsSold = [700.0, 400.0, 600.0, 300.0, 120.0, 600.0, 400.0, 500.0, 200.0, 400.0, 600.0, 300.0, 102.0, 160.0, 400.0, 700.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "No progress data available yet."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Weeks")
        chartDataSet.barBorderColor = UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1)
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartDataSet.colors = [UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1)]
        
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        barChartView.xAxis.granularity = 1
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        
        barChartView.leftAxis.axisMaximum = 3000;
        barChartView.leftAxis.axisMinimum = 0;
        barChartView.pinchZoomEnabled = true;
        barChartView.scaleXEnabled = true;
        barChartView.scaleYEnabled = true;
        barChartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
        
        
    }

}
