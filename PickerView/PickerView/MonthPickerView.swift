//
//  MonthPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit
let labelWidth: CGFloat = 80.0

class MonthPickerView: BasePickerView {
    private var monthDate = Array<(Int, Array<Int>)>()
    
    override init(frame: CGRect, config: SKPickerConfiguration? = nil) {
        super.init(frame: frame, config: (config == nil ? SKPickerConfiguration(type: .MONTH) : config)!)
        delegate = self
        dataSource = self
        calculateMonth()
    }
    
    fileprivate func calculateMonth() {
        DispatchQueue(label: "background", qos: .background).async {
            self.calculateMonth(start: self.startTime, end: self.endTime)
        }
    }
    
    fileprivate func autoSeleteIndex() {
        guard let selected = config.selecteDate, selecteDateNotHave() else { return }
        for (YIndex, year) in monthDate.enumerated() where selected.year == year.0 {
            for (MIndex, month) in year.1.enumerated() where selected.month == month {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let animation = self.config.selecteDateAnimation
                    self.selectRow(YIndex, inComponent: 0, animated: animation)
                    self.reloadComponent(1)
                    self.selectRow(MIndex, inComponent: 1, animated: animation)
                    self.currentDate()
                }
            }
        }
    }
    
    func currentDate() {
        let year = monthDate[selectedRow(inComponent: 0)]
        let month = year.1[selectedRow(inComponent: 1)]
        setCurrentPeriod((year.0, month, 1), (year.0, month, Date().getDaysInMonth(year: year.0, month: month)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var fixedMode: Void = {
        guard let view = self.subviews.filter{ $0.bounds.height < 100 }.first else { return }
        view.addSubview(self.makeFiexdLable(total: 2, index: 0, text: "年", color: self.config.selectColor, font: self.config.selectFont))
        view.addSubview(self.makeFiexdLable(total: 2, index: 1, text: "月", color: self.config.selectColor, font: self.config.selectFont))
    }()
}

extension MonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthDate.count
        }else {
            return monthDate.count > 0 ? monthDate[pickerView.selectedRow(inComponent: 0)].1.count : 0
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
            pickerLabel?.text = "\(monthDate[row].0)" + (config.showMode == .suffix ? "年" : "")
        }else {
            guard monthDate[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            pickerLabel?.text = "\(monthDate[pickerView.selectedRow(inComponent: 0)].1[row])" + (config.showMode == .suffix ? "月" : "")
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { pickerView.reloadComponent(1) }
        if monthDate.count > 0 {
            let year = selectedRow(inComponent: 0)
            if selectedRow(inComponent: 1) > monthDate[year].1.count {
                selectRow(year, inComponent: 0, animated: true)
                let monthDates = monthDate[year].1[0]
                setCurrentPeriod((monthDate[year].0, monthDates, 1), (monthDate[year].0, monthDates, Date().getDaysInMonth(year: monthDate[year].0, month: monthDates)))
            }else {
                let monthDates = monthDate[year].1[selectedRow(inComponent: 1)]
                setCurrentPeriod((monthDate[year].0, monthDates, 1), (monthDate[year].0, monthDates, Date().getDaysInMonth(year: monthDate[year].0, month: monthDates)))
            }
        }
        periodDelegate(self, .MONTH)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(monthDate[row].0)"
        }else {
            return "\(monthDate[pickerView.selectedRow(inComponent: 0)].1[row])"
        }
    }
}

extension MonthPickerView {
    
    fileprivate func calculateMonth(start: Date, end: Date) {
        let period = TimePeriod(beginning: start, end: end)
        if start.year == end.year {
            monthDate.append((start.year, months(start: start, end: end)))
        }else if start.year < end.year {
            for tempYear in start.year...(start.year + period.chunk.years) {
                if tempYear < end.year && tempYear > start.year {
                    let startYear = Date.startOf(year: tempYear)
                    let endYear = Date.endOf(year: tempYear)
                    monthDate.append((tempYear, months(start: startYear, end: endYear)))
                }else if tempYear == end.year {
                    let startYear = Date.startOf(year: tempYear)
                    monthDate.append((end.year, months(start: startYear, end: end)))
                }else if tempYear == start.year {
                    let endYear = Date.endOf(year: tempYear)
                    monthDate.append((start.year, months(start: start, end: endYear)))
                }
            }
        }
        if config.order == .BCE { monthDate = monthDate.reversed() }
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
extension BasePickerView {
    fileprivate func months(start: Date, end: Date) -> Array<Int> {
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
        return config.order == .BCE ? monthArr.reversed() : monthArr
    }
}

extension UIPickerView {
    func makeFiexdLable(total: CGFloat, index: CGFloat, text: String, color: UIColor, font: UIFont) -> UILabel {
        let fixedWidth: CGFloat = 30.0
        let x = CGFloat((kScreenW / total) * index) + CGFloat((kScreenW / total - labelWidth) / total) + labelWidth
        let label = UILabel(frame: CGRect(x: x, y: 0, width: fixedWidth, height: 34))
        label.text = text
        label.textAlignment = .center
        label.textColor = color
        label.font = font
        return label
    }
}
