//
//  BasePickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/21.
//  Copyright © 2020 jetson. All rights reserved.
//


import UIKit

class BasePickerView: UIPickerView {
    var currentPeriod: (Date,Date) = (Date(),Date())
    
    weak var periodDelegate: SKDatePeriodPickerViewDelegate?
    
    public var config: SKPickerConfiguration!
    
    var startTime: Date!
    var endTime: Date!
    
    
    /// 刷新日期
    public func reloadDate() {
        startAndEndJudge()
        DispatchQueue(label: "background", qos: .background).async {
            self.calculationDate(start: self.startTime, end: self.endTime)
        }
    }
    
    /// 开始日期和结束日期是否需要交换, 结束日期必须大于开始日期, 否则进行交换
    fileprivate func startAndEndJudge() {
        startTime =  config.timeLimit.0 < config.timeLimit.1 ? config.timeLimit.0 : config.timeLimit.1
        endTime = config.timeLimit.0 < config.timeLimit.1 ? config.timeLimit.1 : config.timeLimit.0
    }
    
    /// 计算日期
    public func calculationDate(start: Date, end: Date) {
    }
    
    init(config: SKPickerConfiguration) {
        super.init(frame: .zero)
        self.config = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BasePickerView {
    
    func setCurrentPeriod(_ start: (Int, Int, Int), _ end: (Int, Int, Int)) {
        let start = Date(year: start.0, month: start.1, day: start.2)
        let end = Date(year: end.0, month: end.1, day: end.2)
        currentPeriod = (start, end)
    }
    
    func setCurrentPeriod(_ start: Date, _ end: Date) {
        currentPeriod = (start, end)
    }
    
    /// 时间周期中是否包含选中日期
    func selecteDateNotHave() -> Bool {
        guard let selected = config.selecteDate else { return false }
        return selected < endTime && selected > startTime
    }
    
    /// 代理
    func periodDelegate(_ pickerView: BasePickerView , _ type: SKPeriodType) {
        if let delegate = periodDelegate {
            let start = currentPeriod.0
            let end = currentPeriod.1
            delegate.pickerView(pickerView: pickerView, type: type, start: (start.year, start.month, start.day), end: (end.year, end.month, end.day))
        }
    }
}

extension BasePickerView {
    func makeFiexdLable(subview: UIView, total: CGFloat, index: CGFloat, text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = config.selectColor
        label.font = config.selectFont
        
        let average = (bounds.width / total) * (index + 0.7)
        subview.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        subview.addConstraints([NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: subview, attribute: .bottom, multiplier: 1.0, constant: 0),
                                NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: subview, attribute: .top, multiplier: 1.0, constant: 0),
                                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: subview, attribute: .left, multiplier: 1.0, constant: average)])
    }
}

extension BasePickerView {
    ///
    func years(start: Date, end: Date) -> DateModel {
        var dateArr = DateModel()
        let period = TimePeriod(beginning: start, end: end)
        if start.year == end.year {
            if start.month == end.month {
                if start.day == end.day {
                    dateArr.years.append(YearModel(start.year, [MonthModel(start.month, [start.day])]))
                }else if start.day < end.day {
                    dateArr.years.append(YearModel(start.year, [MonthModel(start.month, Array(start.day...start.day + period.chunk.days))]))
                }
            }else if start.month < end.month {
                dateArr.years.append(YearModel(start.year, monthsAndDays(start: start, end: end)))
            }
        }else if start.year < end.year {
            for tempYear in start.year...(start.year + period.chunk.years) {
                if tempYear < end.year && tempYear > start.year {
                    let startYear = Date.startOf(year: tempYear)
                    let endYear = Date.endOf(year: tempYear)
                    dateArr.years.append(YearModel(tempYear, monthsAndDays(start: startYear, end: endYear)))
                }else if tempYear == end.year {
                    let startYear = Date.startOf(year: tempYear)
                    dateArr.years.append(YearModel(tempYear, monthsAndDays(start: startYear, end: end)))
                }else if tempYear == start.year {
                    let endYear = Date.endOf(year: tempYear)
                    dateArr.years.append(YearModel(tempYear, monthsAndDays(start: start, end: endYear)))
                }
            }
        }
        return dateArr
    }

    ///
    func monthsAndDays(start: Date, end: Date) -> Array<MonthModel> {
        var monthArr = Array<MonthModel>()
        for tempMonth in start.month...(start.month + TimePeriod(beginning: start, end: end).chunk.months) {
            if tempMonth < end.month && tempMonth > start.month {
                let time = Date(year: start.year, month: tempMonth, day: 1)
                monthArr.append(MonthModel(tempMonth, days(start: 1, end: time.daysInMonth)))
            }else if tempMonth == end.month {
                monthArr.append(MonthModel(tempMonth, days(start: 1, end: end.day)))
            }else if tempMonth == start.month {
                monthArr.append(MonthModel(tempMonth, days(start: start.day, end: start.daysInMonth)))
            }
        }
        return config.order == .Desc ? monthArr.reversed() : monthArr
    }
    
    func days(start: Date, end: Date) -> Array<Int> {
        var monthArr = Array<Int>()
        for tempMonth in start.month...(start.month + TimePeriod(beginning: start, end: end).chunk.months) {
            if tempMonth < end.month && tempMonth > start.month {
                monthArr.append(tempMonth)
            }else if tempMonth == end.month {
                monthArr.append(tempMonth)
            }else if tempMonth == start.month {
                monthArr.append(tempMonth)
            }
        }
        return config.order == .Desc ? monthArr.reversed() : monthArr
    }
    
    /// 正序, 倒序
    fileprivate func days(start: Int, end: Int) -> Array<Int> {
        let days = Array(start...end)
        return config.order == .Desc ? days.reversed() : days
    }
}

extension UIPickerView {
    var selectedFrist: Int { get { selectedRow(inComponent: 0) } }
    var selectedSecond: Int { get { selectedRow(inComponent: 1) } }
    var selectedThird: Int { get { selectedRow(inComponent: 2) } }
}
