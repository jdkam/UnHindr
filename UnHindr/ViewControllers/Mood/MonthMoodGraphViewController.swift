//File: [MonthMoodGraphViewController.swift]
//Creators: [Johnston]
//Date created: [11/10/2019]
//Updater name: [Johnston]
//File description: [Reads values from the data from firebase]

import UIKit
import Foundation
import Charts
import FirebaseFirestore
import FirebaseAuth

class MonthMoodGraphViewController: UIViewController {

    @IBOutlet weak var monthGraph: BarChartView!
    @IBOutlet weak var monthName: UILabel!
    @IBOutlet weak var monthView: UILabel!
    

    var GraphData: [BarChartDataEntry] = []
    
    var monthMoodValues: [Int:Double] = [:]
    var dayAverage = Array(repeating: 0, count: 31)
    var dictDayAvg: [Int:Int] = [:]
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monthView.text = "Month"
        
        let moodRef = Services.checkUserIDMood()
        
        
        // determines if the current user is a patient or caregiver
        Services.getisPatient(){(success) in
            if(success)
            {
                // if the user is a patient
                self.getMoodData(reference: moodRef)
            }
            else
            {
                // if the user is a caregiver
                if(user_ID != "")
                {
                    // if the caregiver selected a patient
                    self.getMoodData(reference:moodRef)
                }
                else
                {
                    // if the caregiver has not selected a patient
                    self.monthGraph.noDataText = "Please choose a patient in the Connect Screen"
                    self.monthName.text = ""
                }
            }
        }
        
        //Sets up the chart properties
        self.title = "Bar Chart"
        monthGraph.maxVisibleCount = 40
        monthGraph.drawBarShadowEnabled = false
        monthGraph.drawValueAboveBarEnabled = true
        monthGraph.highlightFullBarEnabled = false
        monthGraph.doubleTapToZoomEnabled = false
        let leftAxis = monthGraph.leftAxis
        leftAxis.axisMinimum = 0
        monthGraph.rightAxis.enabled = false
        let xAxis = monthGraph.xAxis
        xAxis.labelPosition = .bottom
        let l = monthGraph.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 8
        l.xEntrySpace = 6
        monthGraph.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        xAxis.drawGridLinesEnabled = false
    }
    
    // MARK: - Obtain the months mood data from firebase
    // Input:
    //      1. The collection reference for the specific user
    // Output:
    //      1. The monthly mood graph is created and displayed for the user to see
    func getMoodData(reference: CollectionReference)
    {
        // gets all the documents for this particular user
        reference.getDocuments()
            {
                (querySnapshot, err) in
                if err != nil
                {
                    // the program will go into this if statement if the user authentication fails
                    print("Error getting monthly mood data")
                }
                else
                {
                    // testing other months
                    // let otherdate = DateFormatter()
                    // otherdate.dateFormat = "yyyy/MM/dd HH:mm"
                    // let someDateTime = otherdate.date(from: "2019/10/3 22:31")
                    // let currentMonth = 10
                    // grabs today's date
                    let today = Date()
                    let calendar = Calendar.current
                    // gets the month of today's date
                    let currentMonth = calendar.component(.month, from: today)
                    // gets the name of the month of today's date
                    let currentMonthName = DateFormatter().monthSymbols[currentMonth-1]
                    // sets the monthName label to be the name of the month
                    self.monthName.text = "\(currentMonthName)"
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
                            // checks if dbDay is already inside monthMoodValues dictionary
                            let keyExists = self.monthMoodValues[dbDay] != nil
                            if(keyExists)
                            {
                                // adds the score found from dbDay into the correct spot in the dictionary
                                self.monthMoodValues[dbDay] = (self.monthMoodValues[dbDay]!) + (document.get("Score") as! Double)
                                // increments the average by one
                                self.dictDayAvg[dbDay]! += 1
                            }
                            else{
                                // sets the value of the new dbDay key to equal to the score
                                self.monthMoodValues[dbDay] = (document.get("Score") as! Double)
                                // sets the average to 1
                                self.dictDayAvg[dbDay] = 1
                            }
                        }
                    }
                    // counts the number of days for that month and stores the value in numDays
                    let range = calendar.range(of: .day, in: .month, for: today)!
                    let numDays = range.count
                    var i = 1
                    // goes through all of the days of the month
                    // checks each day inside the monthMoodValues dictionary
                    while (i <= numDays)
                    {
                        // checks if the day exists in the dictionary
                        let dayExists = self.monthMoodValues[i] != nil
                        if(dayExists)
                        {
                            // sets data as the average of all database values of that particular day
                            let data = BarChartDataEntry(x: Double(i), y: (self.monthMoodValues[i]!)/Double(self.dictDayAvg[i]!))
                            self.GraphData.append(data)
                        }
                        else{
                            // if the key does not exist, set that day equal to 0
                            let data = BarChartDataEntry(x: Double(i), y: 0)
                            self.GraphData.append(data)
                        }
                        i += 1
                    }
                    // finialize setup of graph after the data has been inputted
                    let set = BarChartDataSet(values: self.GraphData, label: "Mood")
                    
                    set.colors = [UIColor.init(displayP3Red: 21/255, green: 187/255, blue: 18/255, alpha: 1)]
                    let chartData = BarChartData(dataSet: set)
                    self.monthGraph.fitBars = true
                    self.monthGraph.data = chartData
                    // allows for the graph to be swiped left or right
                    self.monthGraph.setVisibleXRangeMaximum(7)
                    self.monthGraph.moveViewToX(Double(numDays-7))
                }
            }
    }
}



