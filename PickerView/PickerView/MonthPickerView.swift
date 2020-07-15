//
//  MonthPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class MonthPickerView: UIPickerView {
    private(set) var monthData = Array<(Int, Array<Int>)>()
    fileprivate var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int))!
    public var periodDelegate: DatePeriodPickerViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
        calculateMonth()
        let month = Date().getLastMonthStartAndEnd()
        currentPeriodDate = ((month.0!.year, month.0!.month, month.0!.day),(month.1!.year, month.1!.month, month.1!.day))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthData.count
        }else {
            return monthData.count > 0 ? monthData[pickerView.selectedRow(inComponent: 0)].1.count : 0
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
            pickerLabel?.text = "\(monthData[row].0)年"
        }else {
            guard monthData[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            pickerLabel?.text = "\(monthData[pickerView.selectedRow(inComponent: 0)].1[row])月"
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { pickerView.reloadComponent(1) }
        if monthData.count > 0 {
            let year = selectedRow(inComponent: 0)
            if selectedRow(inComponent: 1) > monthData[year].1.count {
                selectRow(year, inComponent: 0, animated: true)
                let monthDate = monthData[year].1[0]
                currentPeriodDate = ((monthData[year].0, monthDate, 1), (monthData[year].0, monthDate, Date().getDaysInMonth(year: monthData[year].0, month: monthDate)))
            }else {
                let monthDate = monthData[year].1[selectedRow(inComponent: 1)]
                currentPeriodDate = ((monthData[year].0, monthDate, 1), (monthData[year].0, monthDate, Date().getDaysInMonth(year: monthData[year].0, month: monthDate)))
            }
        }
        if let tempProtocol = periodDelegate {
            tempProtocol.pickerView(pickerView: self, type: .MONTH, start: currentPeriodDate.0, end: currentPeriodDate.1)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(monthData[row].0)年"
        }else {
            return "\(monthData[pickerView.selectedRow(inComponent: 0)].1[row])月"
        }
    }
}
extension MonthPickerView {
    /// 计算前4个月
    func calculateMonth() {
        let currentDate = Date()
        var year: Int = Date().year
        var month: Array<Int> = Array()
        DispatchQueue(label: "background", qos: .background).async {
            let excursion = Date.isToadyisMonthFirst() ? 1 : 0
            let index = 3
            for i in (0 + excursion) ... (index + excursion) {
                let currentDate = Calendar.current.date(byAdding: .month, value: -i, to: currentDate)
                if year == currentDate?.year {
//                    print("相同-年:\(year)月:\(month)")
                    month.append(currentDate!.month)
                }else {
//                    print("不相同-年:\(year)月:\(month)")
                    self.monthData.append((year, month))
                    year = currentDate!.year
                    month.removeAll()
                    month.append(currentDate!.month)
                }
                if i == index + excursion {
                    self.monthData.append((year, month))
                }
//                print("年-总\(self.monthData)")
            }
            DispatchQueue.main.async { self.reloadAllComponents() }
        }
    }
}
