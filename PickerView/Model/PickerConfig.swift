//
//  YearType.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class SKPickerConfig {
    /// 月周期格式
    var month: MonthFormat?
    /// 周周期格式
    var week: WeekFormat?
    /// 自动选中当前日期, 默认当前日期, nil时不自动选中
    var selecteDate: Date? = Date()
    /// 时间范围
    var timeLimit: (Date, Date)!
    
    var selectColor: UIColor = .color(default: .red, darkMode: .red)
    
    var selectFont: UIFont = .systemFont(ofSize: 18)
    
    var normalColor: UIColor = .color(default: .white, darkMode: .white)
    
    var normalFont: UIFont = .systemFont(ofSize: 18)
    /// 是否是正序
    var isSort: Bool = false
    
    /// iOS13.0及以下有效
    var splitLimitColor: UIColor = .color(default: .lightGray, darkMode: .lightGray)
    /// iOS13.0及以下有效
    var splitLimitHeight: CGFloat = 1
    /// iOS13.0及以下有效
    var splitLimitHidden: Bool = true
    
    /// 显示顺序
    var order: SKPeriodOrder = .ACE
    
    init(type: SKPeriodType) {
        switch type {
        case .DAY: break
        case .WEEK: week = WeekFormat()
        case .MONTH: month = MonthFormat()
        case .MINUTE: break
        case .HOUR: break
        case .SECOND: break
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