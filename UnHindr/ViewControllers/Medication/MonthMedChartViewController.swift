//
//  MonthMedChartViewController.swift
//  UnHindr
//
//  Created by Johnston Yang on 2019-11-22.
//  Copyright © 2019 Sigma. All rights reserved.
//

import Foundation
import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth

class MonthMedChartViewController: UIViewController {

    @IBOutlet weak var monthChart: BarChartView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let medRef = Services.db.collection("users").document(Services.userRef!).collection("Medication")
    
    var GraphData: [BarChartDataEntry] = []
    
    var monthMotorValues: [Int:Double] = [:]
    var dayAverage = Array(repeating: 0, count: 31)
    var dictDayAvg: [Int:Int] = [:]
    
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMotorGameData()
        
        // Sets up the chart properties
        self.title = "Bar Chart"
        monthChart.maxVisibleCount = 40
        monthChart.drawBarShadowEnabled = false
        monthChart.drawValueAboveBarEnabled = true
        monthChart.highlightFullBarEnabled = false
        monthChart.doubleTapToZoomEnabled = false
        let leftAxis = monthChart.leftAxis
        leftAxis.axisMinimum = 0
        monthChart.rightAxis.enabled = false
        let xAxis = monthChart.xAxis
        xAxis.labelPosition = .bottom
        let l = monthChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 8
        l.xEntrySpace = 6
        monthChart.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        xAxis.drawGridLinesEnabled = false
    }
    
    // MARK: - Obtain the months motor data from firebase
    // Input:
    //      1. None
    // Output:
    //      1. The monthly motor graph is created and displayed for the user to see
    func getMotorGameData()
    {
        medRef.getDocuments()
            {
                (querySnapshot,err) in
                if err != nil{
                    print("Error getting monthly motor game data")
                }
                else
                {
                    // testing other months
                    //                    let otherdate = DateFormatter()
                    //                    otherdate.dateFormat = "yyyy/MM/dd HH:mm"
                    //                    let someDateTime = otherdate.date(from: "2019/10/3 22:31")
                    //                    let currentMonth = 10
                    // gets the current date
                    let today = Date()
                    let calendar = Calendar.current
                    // gets the current month from the date
                    let currentMonth = calendar.component(.month, from: today)
                    // gets name of the current month
                    let currentMonthName = DateFormatter().monthSymbols[currentMonth-1]
                    // sets the monthLabel to be the name of the month
                    self.monthLabel.text = "\(currentMonthName)"
                    
                    // iterates through all of the documents for this user
                    for document in querySnapshot!.documents
                    {
                        // gets the date numbers of the timestamp from firebase
                        let timestamp: Timestamp = document.get("Date") as! Timestamp
                        // gets the date of the timestamp
                        let dbDate: Date = timestamp.dateValue()
                        // gets the month of the timestamp
                        let dbMonth = calendar.component(.month, from: dbDate)
                        // gets the day of the timestamp
                        let dbDay = calendar.component(.day, from: dbDate)
                        // checks if the month from the database matches with today's month
                        if(dbMonth == currentMonth)
                        {
                            // checks if dbDay is already inside weekMoodValues dictionary
                            let keyExists = self.monthMotorValues[dbDay] != nil
                            if(keyExists)
                            {
                                // adds the score found from dbDay into the correct spot in the dictionary
                                self.monthMotorValues[dbDay] = (self.monthMotorValues[dbDay]!) + (document.get("Quantity") as! Double)
                            }
                            else{
                                // sets the value of the new dbDay key to equal to the score
                                self.monthMotorValues[dbDay] = (document.get("Quantity") as! Double)
                            }
                        }
                    }
                    // counts the number of days for that month and stores the value in numDays
                    let range = calendar.range(of: .day, in: .month, for: today)!
                    let numDays = range.count
                    
                    var i = 1
                    // goes through all of the days of the month
                    // checks each day inside the monthMotorValues dictionary
                    while (i <= numDays)
                    {
                        // checks if the day exists in the dictionary
                        let dayExists = self.monthMotorValues[i] != nil
                        if(dayExists)
                        {
                            // sets data as the average of all database values of that particular day
                            let data = BarChartDataEntry(x: Double(i), y: (self.monthMotorValues[i]!))
                            self.GraphData.append(data)
                        }
                        else{
                            // if the key does not exist, set that day equal to 0
                            let data = BarChartDataEntry(x: Double(i), y: 0)
                            self.GraphData.append(data)
                        }
                        i += 1
                    }
                    // finalize setup of graph after the data has been inputted
                    let set = BarChartDataSet(values: self.GraphData, label: "Medication Graph")
                    set.colors = [UIColor.init(displayP3Red: 0/255, green: 128/255, blue: 255/255, alpha: 1)]
                    let chartData = BarChartData(dataSet: set)
                    self.monthChart.fitBars = true
                    self.monthChart.data = chartData
                    self.monthChart.setVisibleXRangeMaximum(7)
                    self.monthChart.moveViewToX(Double(numDays-7))
                }
        }
    }
}
