//
//  DatePeriodProtocol.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/13.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

protocol ToolProtocol: NSObjectProtocol {
    ///
    func tool(left leftBtn: UIButton?, right rightBtn: UIButton?)
    ///
    func tool(selected type: CycleType, selected index: Int)
}

extension ToolProtocol {}

protocol DatePeriodPickerViewDelegate: NSObjectProtocol {
    ///
    func pickerView(pickerView: UIPickerView, type: CycleType, start: PeriodDate, end: PeriodDate)
}
extension DatePeriodPickerViewDelegate {
    
}

protocol DatePeriodDataDelegate: NSObjectProtocol {
    ///
    func selected(pickerView: DatePeriodPickerView, type: CycleType, start: PeriodDate, end: PeriodDate)
}
extension DatePeriodDataDelegate {
    
}

extension UIColor {
    static func color(default color: UIColor, darkMode: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? darkMode : color }
        }else {
            return color
        }
    }
}
