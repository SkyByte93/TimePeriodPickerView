//
//  YearType.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class PickerConfig {
    /// 月周期格式
    var month: MonthFormat?
    /// 周周期格式
    var week: WeekFormat?
    /// 当前时间
    var currentDate: Date = Date()
    /// 自动确定到当前时间
    var autoLocationCurrentDate: Bool = true
    /// 时间范围
    var timeLimit: (Date, Date)?
    
    var selectColor: UIColor = .color(default: .red, darkMode: .red)
    
    var selectFont: UIFont = .systemFont(ofSize: 18)
    
    var normalColor: UIColor = .color(default: .white, darkMode: .white)
    
    var normalFont: UIFont = .systemFont(ofSize: 18)
    /// iOS13.0及以下有效
    var splitLimitColor: UIColor = .color(default: .lightGray, darkMode: .lightGray)
    /// iOS13.0及以下有效
    var splitLimitHeight: CGFloat = 1
    /// iOS13.0及以下有效
    var splitLimitHidden: Bool = true
    
    init(type: CycleType) {
        switch type {
        case .DAY: break
        case .WEEK: week = WeekFormat()
        case .MONTH: month = MonthFormat()
        case .Minute: break
        case .Hour: break
        }
    }
    init() {}
}

class MonthFormat: NSObject {
    /// 年格式
    var yearFormat: String = "yyyy年"
    /// 月格式
    var monthFormat: String = "MM月"
}

class WeekFormat: NSObject {
    /// 年格式
    var yearFormat: String = "yyyy年"
    /// 周期格式
    var monthFormat: String = "(MM.DD~MM.DD)"
}
