/*
 File: [MonthMedChartViewController.swift]
 Creators: [Johnston]
 Date created: [22/11/2019]
 Date updated: [22/11/2019]
 Updater name: [Johnston]
 Class description: [Reads medication data and properly graphs them for an entire month]
*/

import Foundation
import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth

// MARK: - Class to create the graphs for the amount of medication taken for each day in a one month period
class MonthMedChartViewController: UIViewController {

    @IBOutlet weak var monthChart: BarChartView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var GraphData: [BarChartDataEntry] = []
    
    var monthMedValues: [Int:Double] = [:]
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // grabbing the medication reference for the specific patient
        let (_,medRef) = Services.checkUserIDMed()
        
        // determines if the current user is a patient or caregiver
        Services.getisPatient(){(success) in
            if(success)
            {
                // if the user is a patient
                self.getMedData(reference: medRef)
            }
            else
            {
                // if the user is a caregiver
                if(user_ID != "")
                {
                    // if the caregiver selected a patient
                    self.getMedData(reference: medRef)
                }
                else
                {
                    // if the caregiver has not selected a patient
                    self.monthChart.noDataText = "Please choose a patient in the Conncet Screen"
                    self.monthLabel.text = ""
                }
            }
        }
        
        
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
    
    // MARK: - Obtain the months medication data from firebase
    // Input:
    //      1. The collection reference for the specific user
    // Output:
    //      1. The monthly medication graph is created and displayed for the user to see
    func getMedData(reference: CollectionReference)
    {
        reference.getDocuments()
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
                            let keyExists = self.monthMedValues[dbDay] != nil
                            if(keyExists)
                            {
                                // adds the score found from dbDay into the correct spot in the dictionary
                                self.monthMedValues[dbDay] = (self.monthMedValues[dbDay]!) + (document.get("Quantity") as! Double)
                            }
                            else{
                                // sets the value of the new dbDay key to equal to the score
                                self.monthMedValues[dbDay] = (document.get("Quantity") as! Double)
                            }
                        }
                    }
                    // counts the number of days for that month and stores the value in numDays
                    let range = calendar.range(of: .day, in: .month, for: today)!
                    let numDays = range.count
                    
                    var i = 1
                    // goes through all of the days of the month
                    // checks each day inside the monthMedValues dictionary
                    while (i <= numDays)
                    {
                        // checks if the day exists in the dictionary
                        let dayExists = self.monthMedValues[i] != nil
                        if(dayExists)
                        {
                            // sets data as the average of all database values of that particular day
                            let data = BarChartDataEntry(x: Double(i), y: (self.monthMedValues[i]!))
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
                    let set = BarChartDataSet(values: self.GraphData, label: "Medication Taken")
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
