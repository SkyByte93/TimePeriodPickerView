//
//  DayPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//



import Foundation
import UIKit

class DayPickerView: BasePickerView {
    private var dayDate = DateModel()
    
    override init(config: SKPickerConfiguration? = nil) {
        super.init(config: (config == nil ? SKPickerConfiguration(type: .DAY) : config)!)
        delegate = self
        dataSource = self
        reloadDate()
    }
    
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func currentDayType() {
        let years = dayDate.years[selectedFrist]
        let months = years.months[selectedSecond]
        let day = months.days[selectedThird]
        setCurrentPeriod((years.year, months.month, day), (years.year, months.month, day))
    }
    
    fileprivate func currentMonthType() {
        let years = dayDate.years[selectedFrist]
        let months = years.months[selectedSecond]
        setCurrentPeriod((years.year, months.month, 1), (years.year, months.month, Date().getDaysInMonth(year: years.year, month: months.month)))
    }
    
    /// 计算定位位置
    fileprivate func autoSeleteIndex() {
        guard let year = autoSelecteYear() else { return }
        guard let month = autoSelecteMonth(year: year.1) else { return }
        var day: Int? = nil
        if config.type == .DAY { day = autoSelecteDay(month: month.1)?.0 }
        location(year: year.0, month: month.0, day: day)
    }
    
    fileprivate func autoSelecteYear() -> (Int, YearModel)? {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return nil }
        for (YIndex, year) in dayDate.years.enumerated() where selected.year == year.year {
            return (YIndex, year)
        }
        return nil
    }
    
    fileprivate func autoSelecteMonth(year: YearModel) -> (Int, MonthModel)? {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return nil }
        for (MIndex, month) in year.months.enumerated() where selected.month == month.month {
            return (MIndex, month)
        }
        return nil
    }
    
    fileprivate func autoSelecteDay(month: MonthModel) -> (Int, Int)? {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return nil }
        for (DIndex, day) in month.days.enumerated() where selected.day == day {
            return (DIndex, day)
        }
        return nil
    }
    
    fileprivate func location(year: Int) {
        selectRow(year, inComponent: 0, animated: config.selecteDateAnimation)
        reloadComponent(1)
    }
    
    fileprivate func location(month: Int) {
        selectRow(month, inComponent: 1, animated: config.selecteDateAnimation)
        if config.type == .DAY { reloadComponent(2) }
    }
    
    fileprivate func location(day: Int) {
        selectRow(day, inComponent: 2, animated: config.selecteDateAnimation)
    }
    
    /// 定位
    fileprivate func location(year: Int?, month: Int?, day: Int?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let year = year { self.location(year: year) }
            if let month = month { self.location(month: month) }
            if let day = day {
                self.location(day: day)
                self.currentDayType()
                self.periodDelegate(self, .DAY)
            }else {
                self.currentMonthType()
                self.periodDelegate(self, .MONTH)
            }
        }
    }
    
    ///
    lazy var fixedMode: Void = {
        guard let view = self.subviews.filter({ $0.bounds.height < 100 }).first else { return }
        makeFiexdLable(subview: view, total: 3, index: 0, text: "年")
        makeFiexdLable(subview: view, total: 3, index: 1, text: "月")
        makeFiexdLable(subview: view, total: 3, index: 2, text: "日")
    }()
    
    ///
    override func calculationDate(start: Date, end: Date) {
        dayDate.years.removeAll()
        dayDate = years(start: start, end: end)
        if config.order == .Desc { dayDate.years = dayDate.years.reversed() }
        DispatchQueue.main.async {
            self.reloadAllComponents()
            if self.config.selecteDate != nil {
                self.autoSeleteIndex()
            }else {
                if self.config.type == .DAY {
                    self.currentDayType()
                }else if self.config.type == .MONTH {
                    self.currentMonthType()
                }
            }
        }
    }
}

extension DayPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return config.componentNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / CGFloat(config.componentNumber)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dayDate.years.count
        }else if component == 1 {
            guard dayDate.years.count > selectedFrist else { return 0 }
            return dayDate.years[selectedFrist].months.count
        }else {
            guard dayDate.years.count > selectedFrist, dayDate.years[selectedFrist].months.count > selectedSecond else { return 0 }
            return dayDate.years[selectedFrist].months[selectedSecond].days.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            if config.type == .DAY { pickerView.reloadComponent(2) }
        }else if component == 1 && config.type == .DAY {
            pickerView.reloadComponent(2)
        }
        
        if isAllComponentContain() {
            let yearArr = dayDate.years[selectedFrist]
            let monthArr = yearArr.months[selectedSecond]
            let day = monthArr.days[selectedThird]
            setCurrentPeriod((yearArr.year, monthArr.month, day), (yearArr.year, monthArr.month, day))
        }
        periodDelegate(self, .DAY)
    }
    
    func isAllComponentContain() -> Bool {
        let isContain = dayDate.years.count > selectedFrist &&
            dayDate.years[selectedFrist].months.count > selectedSecond &&
            dayDate.years[selectedFrist].months[selectedSecond].days.count > selectedThird
        // 在结尾时间时, 需要刷新数据.
        if !isContain && dayDate.years[selectedFrist].months.count <= selectedSecond {
            selectRow(dayDate.years[selectedFrist].months.count - 1, inComponent: 1, animated: true)
            reloadComponent(2)
        }
        return isContain
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if #available(*, iOS 13.0) {
            //设置分割线
            for view in pickerView.subviews where view.frame.size.height <= 1 {
                view.isHidden = config.splitLimitHidden
                view.frame = CGRect(x: 0, y: view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: config.splitLimitHeight)
                view.backgroundColor = config.splitLimitColor
            }
        }
        
        // 修改字体样式
        var pickerLabel = view as? UILabel
        if pickerLabel == nil { pickerLabel = UILabel() }
        if config.showMode == .fixed {
            pickerLabel?.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 40)
            _ = fixedMode
        }
        pickerLabel?.textAlignment = .center
        pickerLabel?.font = config.selectFont
        pickerLabel?.textColor = config.selectColor
        
        if component == 0 {
            guard row < dayDate.years.count else { return pickerLabel! }
            pickerLabel?.text = "\(dayDate.years[row].year)" + (config.showMode == .suffix ? "年" : "")
        }else if component == 1 {
            let month = dayDate.years[selectedFrist].months
            guard row < month.count else { return pickerLabel! }
            pickerLabel?.text = "\(month[row].month)" + (config.showMode == .suffix ? "月" : "")
        }else if component == 2 {
            let day = dayDate.years[selectedFrist].months[selectedSecond].days
            guard row < day.count else { return pickerLabel! }
            pickerLabel?.text = "\(day[row])" + (config.showMode == .suffix ? "日" : "")
        }
        return pickerLabel!
    }
}
