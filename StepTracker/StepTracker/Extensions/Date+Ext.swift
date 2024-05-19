//
//  Date+Ext.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-19.
//

import Foundation


extension Date {
    var weekDayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
