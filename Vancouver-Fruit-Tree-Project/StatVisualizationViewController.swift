//
//  StatVisualizationViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Cameron Savage on 2018-07-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import Charts

class StatVisualizationViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var MinDateField: UITextField!
    @IBOutlet weak var MaxDateField: UITextField!
    
    @IBOutlet weak var MinDateStepper: UIStepper!
    @IBOutlet weak var MaxDateStepper: UIStepper!
    
    
    //var convertDate: DateFormatter = DateFormatter()
    
    var MinYear: Int = 2018
    var MinMonth: Int = 01
    
    var MaxYear: Int = 2018
    var MaxMonth: Int = 01
    
    var MaxDateStepperVal: Double = 0
    var MinDateStepperVal: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barChart.noDataText = "No data for the selected range, or no range has been submitted"
        barChart.dragXEnabled = true
        barChart.fitBars = true
        // Do any additional setup after loading the view.
        let date = Date()
        
        let currentdate = Calendar.current
        let month = currentdate.component(.month, from: date)
        let year = currentdate.component(.year, from: date)
        
        MinYear = year
        MaxYear = year
        
        MinMonth = month
        MaxMonth = month
        
        // min/maxmonth will both be the same
        if MinMonth < 10 {
            MinDateField.text = String(MinYear) + " / 0" + String(MinMonth)
            MaxDateField.text = String(MaxYear) + " / 0" + String(MaxMonth)
        
        }
        
        else{
            MinDateField.text = String(MinYear) + " / " + String(MinMonth)
            MaxDateField.text = String(MaxYear) + " / " + String(MaxMonth)
        }
        
        
    }

    func printDateRange(){
        
        if MinMonth < 10 {
            MinDateField.text = String(MinYear) + " / 0" + String(MinMonth)
        }
        else {
            MinDateField.text = String(MinYear) + " / " + String(MinMonth)
        }
            
        if MaxMonth < 10 {
            MaxDateField.text = String(MaxYear) + " / 0" + String(MaxMonth)
        }
            
        else{
            MaxDateField.text = String(MaxYear) + " / " + String(MaxMonth)
        }
        
    }
    
    @IBAction func EditMinDate(_ sender: UIStepper) {
        print(String(MinDateStepper.value))
        //decrease min date
        if sender.value <= MinDateStepperVal{
            
            sender.value = 0
            
            //decrease month, year if necessary
            if MinMonth <= 1 {
                MinMonth = 12
                MinYear -= 1
            }
            else{
                MinMonth -= 1
            }
        }
        
        //increase min date
        else if sender.value > MinDateStepperVal {
            
            sender.value = 0
            
            //increase month, year if necessary
            if MinMonth >= 12 {
                MinMonth = 1
                MinYear += 1
            }
                
            else{
                MinMonth += 1
                
            }
        }
        
        //error check
        if MinYear >= MaxYear {
            
            //if max year is smaller
            if MinYear > MaxYear {
                MinYear = MaxYear
                MinMonth = MaxMonth
            }
            
            //if years are equal
            else if MinMonth > MaxMonth{
                MinMonth = MaxMonth
            }
        }
        
        
        printDateRange()
        
    }
    
    
    @IBAction func EditMaxDate(_ sender: UIStepper) {
        print(String(sender.value))
        //decrease max date
        if sender.value <= MaxDateStepperVal {
            
            sender.value = 0
            
            //decrease month, year if necessary
            if MaxMonth <= 1 {
                MaxMonth = 12
                MaxYear -= 1
            }
            else{
                MaxMonth -= 1
            }
        }
            
            //increase max date
        else if sender.value > MaxDateStepperVal {
            
            sender.value = 0
            
            //increase month, year if necessary
            if MaxMonth >= 12 {
                MaxMonth = 1
                MaxYear += 1
            }
                
            else{
                MaxMonth += 1
                
            }
        }
        
        //error check
        if MaxYear <= MinYear {
            
            //if max year is smaller
            if MaxYear < MinYear {
                MaxYear = MinYear
                MaxMonth = MinMonth
            }
            
            //if years are equal
            else if MaxMonth < MinMonth {
                MinMonth = MaxMonth
            }
        }
        
        printDateRange()
    }
    
    
    @IBAction func SubmitDateRanges(_ sender: UIButton) {
        
        let DBINT = DatabaseInterface()
        var currentYear = MinYear
        var currentMonth = MinMonth
        
        var tempA: BarChartDataEntry = BarChartDataEntry()
        var tempB: BarChartDataEntry = BarChartDataEntry()
        
        var barChartDataEntriesA: [BarChartDataEntry] = [BarChartDataEntry]()
        var barChartDataEntriesB: [BarChartDataEntry] = [BarChartDataEntry]()
        
        let barFormatter: BarChartFormatter = BarChartFormatter()
        let xaxis = XAxis()
        
        var response: (Int, Int) = (0, 0)
        
        var dates: [String] = [String]()
        var count = 0
        
        print("Checking between " + String(MinYear) + " / " + String(MinMonth) + " - " + String(MaxYear) + " / " + String(MaxMonth))
        
        while currentYear < MaxYear || (currentYear == MaxYear && currentMonth <= MaxMonth) {
            print("Checking " + String(currentYear) + " / " + String(currentMonth))
            if currentMonth < 10 {
                response = DBINT.getYieldDataByMonth(year: String(currentYear), month: ("0" + String(currentMonth)))
                dates.append(String(currentYear) + "/0" + String(currentMonth))
            }
            
            else{
                response = DBINT.getYieldDataByMonth(year: String(currentYear), month: String(currentMonth))
                dates.append(String(currentYear) + "/" + String(currentMonth))
            }
            
            print("Yield: " + String(response.0 + response.1))
            
            
            
            //[Double(response.0), Double(response.1)]
            
            tempA = BarChartDataEntry(x: Double(count), y: Double(response.0))
            tempB = BarChartDataEntry(x: Double(count), y: Double(response.1))
            
            barChartDataEntriesA.append(tempA)
            barChartDataEntriesB.append(tempB)
            
            
            //iterate to next month
            if currentMonth < 12 {
                currentMonth += 1
            }
            
            else {
                currentMonth = 1
                currentYear += 1
            }
            count += 1
            
        }
        print(dates)
        barFormatter.setMonths(dates: dates)
        
        for i in 0...(count-1) {
            
            barFormatter.stringForValue(Double(i), axis: xaxis)
            
        }
        
        xaxis.valueFormatter = barFormatter
        
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        let dataSetA = BarChartDataSet(values: barChartDataEntriesA, label: "Gr. A Yield")
        let dataSetB = BarChartDataSet(values: barChartDataEntriesB, label: "Gr. B Yield")
        let data = BarChartData(dataSets: [dataSetA, dataSetB])
        
        barChart.data = data
        //barChart.groupBars(fromX: <#T##Double#>, groupSpace: <#T##Double#>, barSpace: <#T##Double#>)
        
        barChart.notifyDataSetChanged()
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
