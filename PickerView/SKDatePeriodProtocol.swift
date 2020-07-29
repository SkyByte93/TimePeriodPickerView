//
//  DatePeriodProtocol.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/13.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

protocol SKToolViewProtocol {
    ///
    func hidenTimePeriod()
    ///
    func selectePickerView(selected type: SKPeriodType, selected index: Int)
}

protocol SKDatePeriodPickerViewDelegate: NSObjectProtocol {
    ///
    func pickerView(pickerView: UIPickerView, type: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate)
}

extension SKDatePeriodPickerViewDelegate {}

protocol SKDatePeriodDateDelegate: NSObjectProtocol {
    ///
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start time: SKPeriodDate, end time: SKPeriodDate)
    ///
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start time: Date, end time: Date)
    ///
    func SKPeriodLeftButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start time: SKPeriodDate, end time: SKPeriodDate)
    ///
    func SKPeriodRightButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start time: SKPeriodDate, end time: SKPeriodDate)
}

extension SKDatePeriodDateDelegate {
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {}
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: Date, end: Date) {}
    func SKPeriodLeftButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {}
    func SKPeriodRightButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {}
}

extension UIColor {
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        }else {
            return light
        }
    }
}
