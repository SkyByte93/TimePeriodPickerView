//
//  WeekPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class WeekPickerView: BasePickerView {
    public var weekData = Array<(Int, Array<((Int), (Int, Int, Int), (Int, Int, Int))>)>()
    
    override init(config: SKPickerConfiguration? = nil) {
        super.init(config: (config == nil ? SKPickerConfiguration(type: .WEEK) : config)!)
        delegate = self
        dataSource = self
        reloadDate()
    }
    
    func currentDate() {
        let year = weekData[selectedRow(inComponent: 0)]
        let week = year.1[selectedRow(inComponent: 1)]
        setCurrentPeriod((year.0, week.1.1, week.1.2), (year.0, week.2.1, week.2.2))
    }
    
    fileprivate func autoSeleteIndex() {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return }
        for (YIndex, year) in weekData.enumerated() where selected.year == year.0 {
            for (WIndex, week) in year.1.enumerated() {
                if week.1.1 == selected.month && week.2.1 == selected.month {
                    if week.1.2 <= selected.day && week.2.2 >= selected.day {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.location(year: YIndex, week: WIndex)
                        }
                    }
                }else {
                    if week.1.1 <= selected.month && week.2.1 >= selected.month && week.1.1 <= selected.day {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.location(year: YIndex, week: WIndex)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func location(year: Int, week: Int) {
        let animation = config.selecteDateAnimation
        selectRow(year, inComponent: 0, animated: animation)
        reloadComponent(1)
        selectRow(week, inComponent: 1, animated: animation)
        currentDate()
        periodDelegate(self, .MONTH)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override internal func calculationDate(start: Date, end: Date) {
        let period = TimePeriod(beginning: start, end: end)
        if start.year == end.year {
            if period.weeks == 0 {
                weekData.append((start.year, [((start.week), (start.year, start.month, start.day), (end.year, end.month, end.day))]))
            }else {
                weekData.append((start.year, weeks(start: start, end: end)))
            }
        }else if start.year < end.year {
            for tempYear in start.year...(start.year + period.chunk.years) {
                if tempYear < end.year && tempYear > start.year {
                    weekData.append((tempYear, weeks(start: Date.startOf(year: tempYear), end: Date.endOf(year: tempYear))))
                }else if tempYear == end.year {
                    weekData.append((tempYear, weeks(start: Date.startOf(year: tempYear), end: end)))
                }else if tempYear == start.year {
                    weekData.append((tempYear, weeks(start: start, end: Date.endOf(year: tempYear))))
                }
            }
        }
        
        if config.order == .Desc { weekData = weekData.reversed() }
        DispatchQueue.main.async {
            self.reloadAllComponents()
            if self.config.selecteDate != nil {
                self.autoSeleteIndex()
            }else {
                self.currentDate()
            }
        }
    }
}

extension WeekPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return weekData.count
        }else {
            return weekData.count > 0 ? weekData[pickerView.selectedRow(inComponent: 0)].1.count : 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //设置分割线
        for view in pickerView.subviews where view.frame.size.height <= 1 {
            view.isHidden = config.splitLimitHidden
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: config.splitLimitHeight)
            view.backgroundColor = config.splitLimitColor
        }
        
        // 修改字体样式
        var pickerLabel = view as? UILabel
        if pickerLabel == nil { pickerLabel = UILabel() }
        pickerLabel?.textAlignment = .center
        pickerLabel?.font = config.selectFont
        pickerLabel?.textColor = config.selectColor
        
        if component == 0 {
            guard weekData.count > row else { return pickerLabel! }
            pickerLabel?.text = "\(weekData[row].0)" + (config.showMode == .suffix ? "年" : "")
        }else {
            guard weekData.count > pickerView.selectedRow(inComponent: 0) && weekData[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            pickerLabel?.text = "第\(weekSelcted.0)周(\(weekSelcted.1.1.ddToDD()).\(weekSelcted.1.2.ddToDD())~\(weekSelcted.2.1.ddToDD()).\(weekSelcted.2.2.ddToDD()))"
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { pickerView.reloadComponent(1) }
        if weekData.count > 0 {
            let year = selectedRow(inComponent: 0)
            if selectedRow(inComponent: 1) > weekData[year].1.count {
                selectRow(year, inComponent: 0, animated: true)
                let weekDate = weekData[year].1[0]
                setCurrentPeriod(weekDate.1, weekDate.2)
            }else {
                let weekDate = weekData[year].1[selectedRow(inComponent: 1)]
                setCurrentPeriod(weekDate.1, weekDate.2)
            }
        }
        periodDelegate(self, .WEEK)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(weekData[row].0)"
        }else {
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            return "\(weekSelcted.0)(\(weekSelcted.1.0.ddToDD()).\(weekSelcted.1.1.ddToDD())~\(weekSelcted.2.0.ddToDD()).\(weekSelcted.2.1.ddToDD()))"
        }
    }
    
}

extension WeekPickerView {
    fileprivate func weeks(start: Date, end: Date) -> Array<(Int, (Int, Int, Int), (Int, Int, Int))> {
        let timePeriod = TimePeriod(beginning: start, end: end)
        let integerStartDay: Int = 7 - start.week
        var weekArr = Array<(Int, (Int, Int, Int), (Int, Int, Int))>()
        for tempWeek in 0...timePeriod.weeks {
            if tempWeek < timePeriod.weeks && tempWeek > 0 {
                let startTime = start.add(TimeChunk(days: integerStartDay, weeks: tempWeek - 1))
                let endTime = start.add(TimeChunk(days: integerStartDay, weeks: tempWeek))
                weekArr.append((tempWeek, (startTime.year, startTime.month, startTime.day), (endTime.year, endTime.month, endTime.day)))
            }else if tempWeek == timePeriod.weeks {
                let startTime = start.add(TimeChunk(days: integerStartDay, weeks: tempWeek - 1))
                weekArr.append((tempWeek, (startTime.year, startTime.month, startTime.day), (end.year, end.month, end.day)))
            }else if tempWeek == 0 {
                let endTime = start.add(TimeChunk(days: integerStartDay))
                weekArr.append((tempWeek, (start.year, start.month, start.day), (endTime.year, endTime.month, endTime.day)))
            }
        }
        return config.order == .Desc ? weekArr.reversed() : weekArr
    }
    
}
