//
//  DateViewModel.swift
//  CyclePickerView
//
//  Created by jetson on 2020/8/5.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation

struct DateModel: Equatable {
    var years = Array<YearModel>()
    init(_ year: Array<YearModel>) {
        years = year
    }
    
    init() {}
}

struct YearModel: Equatable {
    var year: Int = 0
    var months = Array<MonthModel>()
    init(_ year: Int, _ months: Array<MonthModel>) {
        self.year = year
        self.months = months
    }
    init() {
        
    }
}

struct MonthModel: Equatable {
    var month: Int = 0
    var days = Array<Int>()
    init(_ month: Int,_ days: Array<Int>) {
        self.month = month
        self.days = days
    }
}
