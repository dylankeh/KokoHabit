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
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        //No Zoomin in manually
        barChartView.doubleTapToZoomEnabled = false
        
        //Zoomed into the first 4 weeks
        barChartView.setVisibleXRangeMaximum(4)
        barChartView.moveViewToX(0)
        
        //Setting the color for thr bars
        chartDataSet.colors = [UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue: 65/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1), UIColor(red: 255/255, green: 80/255, blue:  115/255, alpha: 1)]
        
        //Animations and making it look pretty
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        barChartView.xAxis.granularity = 1
        
        //Getting rid of lines
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        
        //Setting the height of the graph
        barChartView.leftAxis.axisMaximum = 710;
    }
}
