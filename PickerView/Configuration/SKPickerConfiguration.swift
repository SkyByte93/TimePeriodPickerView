//
//  YearType.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

struct SKPickerConfiguration {
    /// 自动选中当前日期, 默认当前日期, 为nil时不自动选中
    var selecteDate: Date? = Date()
    /// 自动选中动画
    var selecteDateAnimation: Bool = true
    /// 时间范围
    var timeLimit: (Date, Date) = (Date(), Date())
    ///
    var selectColor: UIColor = .color(light: .red, dark: .red)
    ///
    var selectFont: UIFont = .systemFont(ofSize: 18)
    ///
    var normalColor: UIColor = .color(light: .white, dark: .white)
    ///
    var normalFont: UIFont = .systemFont(ofSize: 18)
    
    /// 显示年格式
    var yearFormat: YearMode = .YYYY
    /// 显示月格式
    var monthFormat: MonthMode = .MM
    /// 显示天格式
    var dayFormat: DayMode = .DD
    /// 显示类型
    var showMode: SKShowMode = .suffix
    
    /// iOS13.0及以下有效
    var splitLimitColor: UIColor = .color(light: .lightGray, dark: .lightGray)
    /// iOS13.0及以下有效
    var splitLimitHeight: CGFloat = 1
    /// iOS13.0及以下有效
    var splitLimitHidden: Bool = false
    
    /// 显示顺序
    var order: SKPeriodOrder = .Asc
    /// 只读
    private(set) var componentNumber: Int!
    
    init(type: SKPeriodType) {
        self.type = type
        switch type {
        case .DAY: componentNumber = 3
        case .MONTH: componentNumber = 2
        case .WEEK: componentNumber = 2
        }
    }
    
    init(start: Date, end: Date) {
        self.timeLimit = (start, end)
    }
    
    mutating func setTimeLimit(_ start: Date,_ end: Date) {
        timeLimit = (start, end)
    }
    
    var type: SKPeriodType!
}

//class MonthFormat: NSObject {
//    /// 年格式
//    var yearFormat: String = "yyyy年"
//    /// 月格式
//    var monthFormat: String = "MM月"
//}
//
//class WeekFormat: NSObject {
//    /// 年格式
//    var yearFormat: String = "yyyy年"
//    /// 周期格式
//    var monthFormat: String = "(MM.DD~MM.DD)"
//}
