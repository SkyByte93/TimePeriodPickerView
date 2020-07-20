//
//  DayPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class DayPickerView: UIPickerView {
    public var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int)) = ((0 ,0, 0),(0, 0, 0))
    public var periodDelegate: SKDatePeriodPickerViewDelegate?
    
    private var dayDate = Array<(Int, Array<(Int, Array<Int>)>)>()
    private(set) var config: SKPickerConfig = SKPickerConfig(type: .DAY)
    private(set) var startTime: Date!
    private(set) var endTime: Date!
    
    public init(frame: CGRect, config: SKPickerConfig? = nil) {
        super.init(frame: frame)
        if let config = config { self.config = config }
        delegate = self
        dataSource = self
        set(lhs: self.config.timeLimit.0, rhs: self.config.timeLimit.1)
        currentDate()
        calculateDay(start: self.startTime, end: self.endTime)
    }
    ///
    fileprivate func currentDate() {
        if let selected = config.selecteDate, selecteDateNotHave() {
            self.currentPeriodDate = ((selected.year, selected.month, selected.day),(selected.year, selected.month, selected.day))
        }else {
            self.currentPeriodDate = ((startTime.year, startTime.month, startTime.day),( startTime.year, startTime.month, startTime.day))
        }
    }
    ///
    fileprivate func set(lhs: Date, rhs: Date) {
        startTime =  lhs < rhs ? lhs : rhs
        endTime = lhs < rhs ? rhs : lhs
    }
    /// 判断时间周期是否含有选中时间
    fileprivate func selecteDateNotHave() -> Bool {
        guard let selected = config.selecteDate else { return false }
        return selected < endTime && selected > startTime
    }
    fileprivate func autoSeleteIndex() {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return }
        for (YIndex, year) in dayDate.enumerated() where selected.year == year.0 {
            for (MIndex, month) in year.1.enumerated() where selected.month == month.0 {
                for (DIndex, day) in month.1.enumerated() where selected.day == day {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.selectRow(YIndex, inComponent: 0, animated: true)
                        self.reloadComponent(1)
                        self.selectRow(MIndex, inComponent: 1, animated: true)
                        self.reloadComponent(2)
                        self.selectRow(DIndex, inComponent: 2, animated: true)
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DayPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dayDate.count
        }else if component == 1 {
            guard dayDate.count > pickerView.selectedRow(inComponent: 0) else { return 0 }
            return dayDate[pickerView.selectedRow(inComponent: 0)].1.count
        }else {
            guard dayDate.count > pickerView.selectedRow(inComponent: 0),
                  dayDate[pickerView.selectedRow(inComponent: 0)].1.count > pickerView.selectedRow(inComponent: 1) else { return 0 }
            return dayDate[pickerView.selectedRow(inComponent: 0)].1[pickerView.selectedRow(inComponent: 1)].1.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }else if component == 1 {
            pickerView.reloadComponent(2)
        }
        
        if isAllComponentContain() {
            let yearArr = dayDate[selectedRow(inComponent: 0)]
            let monthArr = yearArr.1[selectedRow(inComponent: 1)]
            let day = monthArr.1[selectedRow(inComponent: 2)]
            currentPeriodDate = ((yearArr.0, monthArr.0, day),(yearArr.0, monthArr.0, day))
        }
        
        if let tempProtocol = periodDelegate {
            tempProtocol.pickerView(pickerView: self, type: .DAY, start: currentPeriodDate.0, end: currentPeriodDate.1)
        }
    }
    
    func isAllComponentContain() -> Bool {
        let isContain = dayDate.count > selectedRow(inComponent: 0) &&
            dayDate[selectedRow(inComponent: 0)].1.count > selectedRow(inComponent: 1) &&
            dayDate[selectedRow(inComponent: 0)].1[selectedRow(inComponent: 1)].1.count > selectedRow(inComponent: 2)
        // 在结尾时间时, 需要刷新数据.
        if !isContain && dayDate[selectedRow(inComponent: 0)].1.count <= selectedRow(inComponent: 1) {
            selectRow(dayDate[selectedRow(inComponent: 0)].1.count - 1, inComponent: 1, animated: true)
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
        }else {
            
        }
        // 修改字体样式
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.font = config.selectFont
        pickerLabel?.textColor = config.selectColor
        
        if component == 0 {
            guard row < dayDate.count else { return pickerLabel! }
            pickerLabel?.text = "\(dayDate[row].0)年"
        }else if component == 1 {
            let month = dayDate[pickerView.selectedRow(inComponent: 0)].1
            guard row < month.count else { return pickerLabel! }
            pickerLabel?.text = "\(month[row].0)月"
        }else if component == 2 {
            let day = dayDate[pickerView.selectedRow(inComponent: 0)].1[pickerView.selectedRow(inComponent: 1)].1
            guard row < day.count else { return pickerLabel! }
            pickerLabel?.text = "\(day[row])日"
        }
        return pickerLabel!
    }
}

extension DayPickerView {
    fileprivate func calculateDay(start: Date, end: Date) {
        dayDate.removeAll()
        let period = TimePeriod(beginning: start, end: end)
        if start.year == end.year {
            if start.month == end.month {
                if start.day == end.day {
                    dayDate.append((start.year, [(start.month,[start.day])]))
                }else if start.day < end.day {
                    dayDate.append((start.year, [(start.month, Array(start.day...start.day + period.chunk.days))]))
                }
            }else if start.month < end.month {
                dayDate.append((start.year, months(start: start, end: end)))
            }
        }else if start.year < end.year {
            for tempYear in start.year...(start.year + period.chunk.years) {
                if tempYear < end.year && tempYear > start.year {
                    let startYear = Date.startOf(year: tempYear)
                    let endYear = Date.endOf(year: tempYear)
                    dayDate.append((tempYear, months(start: startYear, end: endYear)))
                }else if tempYear == end.year {
                    let startYear = Date.startOf(year: tempYear)
                    dayDate.append((tempYear, months(start: startYear, end: end)))
                }else if tempYear == start.year {
                    let endYear = Date.endOf(year: tempYear)
                    dayDate.append((tempYear, months(start: start, end: endYear)))
                }
            }
        }
        if self.config.selecteDate != nil { autoSeleteIndex() }
        reloadAllComponents()
    }
    
    fileprivate func months(start: Date, end: Date) -> Array<(Int, Array<Int>)> {
        var monthArr = Array<(Int, Array<Int>)>()
        for tempMonth in start.month...(start.month + TimePeriod(beginning: start, end: end).chunk.months) {
            if tempMonth < end.month && tempMonth > start.month {
                let time = Date(year: start.year, month: tempMonth, day: 1)
                monthArr.append((tempMonth, Array(1...time.daysInMonth)))
            }else if tempMonth == end.month {
                monthArr.append((tempMonth, Array(1...end.day)))
            }else if tempMonth == start.month {
                monthArr.append((tempMonth, Array(start.day...start.daysInMonth)))
            }
        }
        return monthArr
    }
}
