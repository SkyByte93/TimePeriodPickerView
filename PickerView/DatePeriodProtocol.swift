//
//  DatePeriodProtocol.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/13.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation

protocol DatePeriodToolDelegate: NSObjectProtocol {
    ///
    func dataPeriod(pickerView picker: DatePeriodPickerView, type: CycleType, start: Date, end: Date)
    ///
    func dataPeriod(pickerView picker: DatePeriodPickerView, type: CycleType, start: PeriodDate, end: PeriodDate)
}
extension DatePeriodToolDelegate {
    func dataPeriod(pickerView picker: DatePeriodPickerView, type: CycleType, start: PeriodDate, end: PeriodDate) {}
}

protocol DatePeriodDataDelegate: NSObjectProtocol {
    ///
    
}
extension DatePeriodDataDelegate {
    
}
