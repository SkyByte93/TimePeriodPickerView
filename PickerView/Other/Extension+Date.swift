//
//  Extension+Date.swift
//  iglobalwin
//
//  Created by jetson on 2020/1/19.
//  Copyright © 2020 skytech. All rights reserved.
//

import UIKit

extension Date {
    //上月开始日期
    func startOfLastMonth() -> Date {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: Date())
        components.month = 1
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    // 上月结束日期
    func endOfLastMonth() -> Date {
        var components = DateComponents()
        components.month = 0
        components.day = -1
        let endOfMonth =  NSCalendar.current.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }
    // 本月开始日期
    func startOfCurrentMonth() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: Date())
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    /// 当前时间
    func currentDate(format: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let time = dateformatter.string(from: Date())
        return time
    }
    
    // 本月结束日期
    func endOfCurrentMonth() -> Date {
        var components = DateComponents()
        components.month = 1
        components.day = -1
        let endOfMonth =  NSCalendar.current.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }
    
    // 获取今天所在的周一
    func weekMonday(date: Date) -> Date {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        let weekDay = comp.weekday
        let day = comp.day
        var firstDiff: Int
        if (weekDay == 1) {
            firstDiff = -6
        } else {
            firstDiff = calendar.firstWeekday - weekDay! + 1
        }
        // 在当前日期(去掉时分秒)基础上加上差的天数
        var firstDayComp = calendar.dateComponents([.year, .month, .day], from: date)
        firstDayComp.day = day! + firstDiff
        let firstDayOfWeek = calendar.date(from: firstDayComp)
        return firstDayOfWeek!
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
    
    /// 获取周一和周日
    /// - Parameter filtrateFirstEqualToday: 过滤第一天等于今天
    func getLastWeekMonthDayAndWeekDay(filtrate firstEqualToday: Bool = true) -> (Date?, Date?) {
        let weekAndMonth = self.weekMonday(date: Date())// 今天所在的周一
        if firstEqualToday && !Date.isTodayisManday() {
            let lastWeekDay = Calendar.current.date(byAdding: .day, value: 6, to: weekAndMonth)// 这周所在的周日
            let lastMonthDay = Calendar.current.date(byAdding: .day, value: 0, to: weekAndMonth)// 这周所在的周一
            return (lastMonthDay,lastWeekDay)
        }
        let lastWeekDay = Calendar.current.date(byAdding: .day, value: -1, to: weekAndMonth)// 上周所在的周日
        let lastMonthDay = Calendar.current.date(byAdding: .day, value: -7, to: weekAndMonth)// 上周所在的周一
        return (lastMonthDay,lastWeekDay)
    }
    
    /// 获取开始第一天和最后一天
    /// - Parameter filtrateFirstEqualToday: 过滤第一天等于今天
    func getLastMonthStartAndEnd(filtrate firstEqualToday: Bool = true) -> (Date?, Date?) {
        if firstEqualToday && !Date.isToadyisMonthFirst() {
            return (Date().startOfCurrentMonth(), Date().endOfCurrentMonth())
        }
        return (Date().startOfLastMonth(), Date().endOfLastMonth())
    }
    
    
    /// 今天是否是周一
    static func isTodayisManday() -> Bool {
        let todayWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday
        return (((todayWeek ?? 0) + 5) % 7 == 0) ? true : false
    }
    
    /// 今天是否是这个月开始第一天
    static func isToadyisMonthFirst() -> Bool {
        let components = NSCalendar.current.dateComponents([.day], from: Date())
        return ((components.day ?? 1) == 1) ? true : false
    }
    
    /// 今年的第几周
    func getWeekByDate(date:Date) ->Int {
            guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else { return 0 }
            let components = calendar.components([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal], from: date)
            return components.weekOfYear!
    }
}

