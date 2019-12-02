/*
  File: [YearMedChartViewController.swift]
  Creators: [Johnston]
  Date created: [22/11/2019]
  Date updated: [22/11/2019]
  Updater name: [Johnston]
  Class description: [Reads medication data and properly graphs them for an entire year]
*/

import UIKit
import Foundation
import Charts
import FirebaseFirestore
import FirebaseAuth

// MARK: - Class to create the graphs for the amount of medication taken in one month for a one year period
class YearMedChartViewController: UIViewController {

    @IBOutlet weak var yearMedGraph: BarChartView!
    @IBOutlet weak var yearLabel: UILabel!
    
    var GraphData: [BarChartDataEntry] = []
    
    var yearMedValues: [String:Double] = [:]

    // this array is to set the x axis values as strings
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // grabbing the medicartion reference for the specific patient
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
                    self.yearMedGraph.noDataText = "Please choose a patient in the Conncet Screen"
                    self.yearLabel.text = ""
                }
            }
        }

        
        // Sets up the chart properties
        self.title = "Bar Chart"
        yearMedGraph.maxVisibleCount = 40
        yearMedGraph.drawBarShadowEnabled = false
        yearMedGraph.drawValueAboveBarEnabled = true
        yearMedGraph.highlightFullBarEnabled = false
        yearMedGraph.doubleTapToZoomEnabled = false
        yearMedGraph.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        let leftAxis = yearMedGraph.leftAxis
        leftAxis.axisMinimum = 0
        yearMedGraph.rightAxis.enabled = false
        let xAxis = yearMedGraph.xAxis
        xAxis.labelPosition = .bottom
        let l = yearMedGraph.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 8
        l.xEntrySpace = 6
        xAxis.drawGridLinesEnabled = false
        yearMedGraph.xAxis.labelRotationAngle = -45
    }
    
    // MARK: - Obtain the yearly medication data from firebase
    // Input:
    //      1. None
    // Output:
    //      1. The yearly medication graph is created and displayed for the user to see
    func getMedData(reference: CollectionReference)
    {
        // gets all the documents for this particular user
        reference.getDocuments()
            {
                (querySnapshot, err) in
                if err != nil // the program will go into this if statement if the user authentication fails
                {
                    print("Error getting yearly cognitive data")
                }
                else
                {
                    // grabs today's date
                    let today = Date()
                    let calendar = Calendar.current
                    // finds the year from today's date
                    let currentYear = calendar.component(.year, from: today)
                    // sets the label to be the currentYear
                    self.yearLabel.text = "\(currentYear)"
                    // iterates through all of the documents for that user
                    for document in querySnapshot!.documents
                    {
                        // creates the timestamp for each document
                        let timestamp: Timestamp = document.get("Date") as! Timestamp
                        // finds the date of that timestamp
                        let dbDate: Date = timestamp.dateValue()
                        // finds the month of that timestamp
                        let dbMonth = calendar.component(.month, from: dbDate)
                        // finds the year of that timestamp
                        let dbYear = calendar.component(.year, from: dbDate)
                        // gets the name of the month from dbMonth
                        let monthName = DateFormatter().monthSymbols[dbMonth - 1]
                        // checks if the database year and the current year match
                        if(dbYear == currentYear)
                        {
                            // checks if the month already exists in the dictionary
                            let keyExists = self.yearMedValues[monthName] != nil
                            if(keyExists)
                            {
                                // when the key exists, add the score on top of the value that is already in the dictionary
                                self.yearMedValues[monthName] = (self.yearMedValues[monthName]!) + (document.get("Quantity") as! Double)
                            }
                            else
                            {
                                // creates the new key with the score from the database as its value
                                self.yearMedValues[monthName] = (document.get("Quantity") as! Double)
                            }
                        }
                    }
                    var j = 0
                    // iterates through all the months to insert it into the graphdata array
                    for i in self.months
                    {
                        // checks if that month exists inside the dictionary
                        let dayExists = self.yearMedValues[i] != nil
                        if(dayExists)
                        {
                            // sets the data value as the average from yearMoodValue[i] and dictMonthAvg[i] and appends the data to the GraphData array
                            let data = BarChartDataEntry(x: Double(j),y: Double(self.yearMedValues[i]!))
                            self.GraphData.append(data)
                        }
                        else{
                            // sets the data value as 0 since the key does not exist
                            let data = BarChartDataEntry(x: Double(j), y: 0)
                            self.GraphData.append(data)
                        }
                        j += 1
                    }
                    // calls on the helper function to set the x axis values as strings
                    let monthFormat = BarChartFormatter(values: self.months)
                    self.yearMedGraph.xAxis.valueFormatter = monthFormat as IAxisValueFormatter
                    // finalize any other chart properties
                    let set = BarChartDataSet(values: self.GraphData, label: "Medication Taken")
                    set.colors = [UIColor.init(displayP3Red: 0/255, green: 128/255, blue: 255/255, alpha: 1)]
                    let chartData = BarChartData(dataSet: set)
                    self.yearMedGraph.fitBars = true
                    self.yearMedGraph.data = chartData
                    self.yearMedGraph.setVisibleXRangeMaximum(6)
                    self.yearMedGraph.moveViewToX(6)
                }
        }
    }
    
    // MARK: - Helper class for XAxis labeling of medication graph
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var values : [String]
        required init (values : [String]) {
            self.values = values
            super.init()
        }
        
        // Function: Convert an array of strings to array of ints
        // Input:
        //      1. String array
        // Output:
        //      1. The graph will be shown to the user after this function is completed
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return values[Int(value)]
        }
    }

}
