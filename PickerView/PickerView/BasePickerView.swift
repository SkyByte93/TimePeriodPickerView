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
    
    var config: SKPickerConfiguration!
    
    var startTime: Date!
    var endTime: Date!
    
    /// 开始日期和结束日期是否需要交换, 结束日期必须大于开始日期, 否则进行交换
    func startAndEndJudge() {
        startTime =  config.timeLimit.0 < config.timeLimit.1 ? config.timeLimit.0 : config.timeLimit.1
        endTime = config.timeLimit.0 < config.timeLimit.1 ? config.timeLimit.1 : config.timeLimit.0
    }
    
    init(frame: CGRect, config: SKPickerConfiguration) {
        super.init(frame: frame)
        self.config = config
        startAndEndJudge()
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
