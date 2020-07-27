//
//  Extension+Date.swift
//  iglobalwin
//
//  Created by jetson on 2020/1/19.
//  Copyright © 2020 skytech. All rights reserved.
//

import UIKit

extension Date {
    
    //本年开始日期
    static func startOf(year: Int) -> Date {
        let date = Date(year: year, month: 1, day: 2)
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        let startOfYear = calendar.date(from: components)!
        return startOfYear
    }
    
    //本年结束日期
    static func endOf(year: Int) -> Date {
        let date = Date(year: year, month: 1, day: 2)
        let calendar = NSCalendar.current
        var components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        components.year = 1
        components.day = -1
        
        let endOfYear = calendar.date(byAdding: components, to: startOf(year: year))!
        return endOfYear
    }
    
    /// 计算指定月的天数
    func getDaysInMonth(year: Int, month: Int) -> Int {
        var calendar = DateComponents()
        calendar.year = year
        calendar.month = month
        let date = Calendar.current.date(from: calendar)!
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date)
        return days.length
    }
}

func TimeChunka(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> TimeChunk {
    return TimeChunk(seconds: seconds, minutes: minutes, hours: hours, days: days, weeks: weeks, months: months, years: years)
}

func timeNow() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSS"
    let strNowTime = timeFormatter.string(from: date) as String
    return strNowTime
}
