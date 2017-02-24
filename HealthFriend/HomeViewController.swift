//
//  HomeViewController.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/23/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import Foundation
import UIKit
import Charts

var SentFromHome: Bool = false


class HomeViewController: ViewController {
    
    var days: [String]!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      barChartView.noDataText = "You start with 100 ponts each day. If you maintain your goal, you'll keep those points."
        //axisFormatDelegate = self
        days = ["S", "M", "T", "W", "Th", "F", "S"]
        let points = [50, 70, 60, 89, 23, 59, 90]
        setChart(dataPoints: days, values: points)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        barChartView.noDataText = "Once we get moving, we'll have some data to display here"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Data Points")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = 100.0
        barChartView.leftAxis.labelCount = 2
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.chartDescription?.enabled = false
        
        barChartView.xAxis.labelPosition = .bottom
        
        chartDataSet.colors = [UIColor(red: 36/255.0, green: 149/255.0, blue: 242/255.0, alpha: 1)]
        chartDataSet.drawValuesEnabled = false
        
    }
    @IBAction func SettingsButtonPressed(_ sender: Any) {
        SentFromHome = true
    }
}
