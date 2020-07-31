//
//  ViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class PopupStyleViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addDisplayButton()
        addDisplayTimeLabel()
    }
    
    override func showPickerView(_ sender: UIButton) {
        let pickerConfig = [dayConfig(), dayConfig(), dayConfig()]
        let pickerView = SKDatePeriodPickerView(types: [.MONTH, .WEEK, .DAY], toolConfig: ToolViewConfiguration(), pickerConfig: pickerConfig)
        pickerView.delegate = self
        SKPickerView = pickerView
        addPickerViewConstraints()
    }
    
    func ToolViewConfiguration() -> SKToolViewConfiguration {
        let config = SKToolViewConfiguration()
        return config
    }
    
    func dayConfig() -> SKPickerConfiguration {
        let start = Date().subtract(TimeChunk(days: 3, weeks: 3, months: 0, years: 30))
        let end = Date().add(TimeChunk(days: 3, weeks: 3, months: 3, years: 30))
        var dayConfig = SKPickerConfiguration(start: start, end: end)
        dayConfig.showMode = .fixed
        dayConfig.order = .Asc
        return dayConfig
    }
}

extension PopupStyleViewController: SKDatePeriodDateDelegate {
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
    }
    
    func SKPeriodLeftButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        print("左边")
    }
    
    func SKPeriodRightButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        print("右边")
    }
}
