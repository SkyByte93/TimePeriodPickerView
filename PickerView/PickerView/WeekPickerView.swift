//
//  WeekPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit
import DateToolsSwift

class WeekPickerView: UIPickerView {
    public var weekData = Array<(Int, Array<((Int), (Int, Int, Int), (Int, Int, Int))>)>()
    public var periodDelegate: DatePeriodPickerViewDelegate?
    fileprivate var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int))!
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
        calculateWeek()
        let week = Date().getLastWeekMonthDayAndWeekDay()
        currentPeriodDate = ((week.0!.year, week.0!.month, week.0!.day),(week.1!.year, week.1!.month, week.1!.day))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            view.isHidden = false
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: 1)
            view.backgroundColor = .white
        }
        // 修改字体样式
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.font = UIFont.systemFont(ofSize: 18)
        pickerLabel?.textColor = .red
        
        if component == 0 {
            pickerLabel?.text = "\(weekData[row].0)年"
        }else {
            guard weekData[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            pickerLabel?.text = "\(weekSelcted.0)(\(weekSelcted.1.1.ddToDD()).\(weekSelcted.1.2.ddToDD())~\(weekSelcted.2.1.ddToDD()).\(weekSelcted.2.2.ddToDD()))"
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
                currentPeriodDate = ((weekDate.1.0, weekDate.1.1, weekDate.1.2),(weekDate.2.0, weekDate.2.1, weekDate.2.2))
            }else {
                let weekDate = weekData[year].1[selectedRow(inComponent: 1)]
                currentPeriodDate = ((weekDate.1.0, weekDate.1.1, weekDate.1.2),(weekDate.2.0, weekDate.2.1, weekDate.2.2))
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(weekData[row].0)年"
        }else {
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            return "\(weekSelcted.0)(\(weekSelcted.1.0.ddToDD()).\(weekSelcted.1.1.ddToDD())~\(weekSelcted.2.0.ddToDD()).\(weekSelcted.2.1.ddToDD()))"
        }
    }
}

extension WeekPickerView {
    
    /// 计算前4个月的每周
    func calculateWeek() {
        var weekArr = Array<(Date, Date)>()
        DispatchQueue(label: "background", qos: .background).async {
            let calendar = Calendar.current
            var test = Date().weekMonday(date: calendar.date(byAdding: .month, value: -3, to: Date().startOfCurrentMonth())!)// 四个月前1号所在的周一
            let weekDay = calendar.date(byAdding: .day, value: Date.isTodayisManday() ? -1 : 6, to: Date().weekMonday(date: Date()))// 计算周日
            var isLoop: Bool = true
            while isLoop {
                let lastWeekDay = calendar.date(byAdding: .day, value: 6, to: test)// 周日
                weekArr.append((test, lastWeekDay!))
                if weekDay?.year == lastWeekDay?.year && weekDay?.month == lastWeekDay?.month && weekDay?.day == lastWeekDay?.day {
                    isLoop = false
                }
                test = calendar.date(byAdding: .day, value: 1, to: lastWeekDay!)!// 周一
            }
            var array = Array<((Int), (Int, Int, Int), (Int, Int, Int))>()
            for index in 0...weekArr.count - 1 {
                let week = weekArr[index]
                if week.0.year == week.1.year {
                    array.append(((Date().getWeekByDate(date: week.0)),(week.0.year, week.0.month, week.0.day),(week.1.year, week.1.month, week.1.day)))
                }else {
                    self.weekData.insert(((week.0.year),(array.reversed())), at: 0)
                    array.removeAll()
                    array.append(((Date().getWeekByDate(date: week.0)),(week.0.year ,week.0.month, week.0.day),(week.1.year, week.1.month, week.1.day)))
                }
                if index == weekArr.count - 1 {
                    self.weekData.insert(((week.1.year),(array.reversed())), at: 0)
                }
            }
            DispatchQueue.main.async { self.reloadAllComponents() }
        }
    }
}
