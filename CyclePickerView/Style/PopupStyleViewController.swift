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
        
        addShowButton()
        addShowTimeLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPickerView(UIButton())
        }
    }
    
    override func showPickerView(_ sender: UIButton) {
        let toolConfig = SKToolViewConfiguration()
        
        let pickerConfig = [dayConfig(), dayConfig(), dayConfig()]
        
        let picker = SKDatePeriodPickerView(types: [.MONTH, .WEEK, .DAY], toolConfig: toolConfig, pickerConfig: pickerConfig)
        picker.delegate = self
        UIApplication.shared.keyWindow?.addSubview(picker)
    }
    
    func dayConfig() -> SKPickerConfiguration {
        let dayConfig = SKPickerConfiguration()
        let start = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 30))
        let end = Date().add(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 3, years: 30))
        dayConfig.timeLimit = (start, end)
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
