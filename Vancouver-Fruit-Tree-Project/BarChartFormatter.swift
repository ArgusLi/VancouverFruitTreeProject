//
//  BarChartFormatter.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Cameron Savage on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import Foundation
import Charts
import UIKit

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public func setMonths(dates: [String]){
        months = dates
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return months[Int(value)]
    }
}
