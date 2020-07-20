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
        let configuation = SKToolViewConfiguration()
        
        let config = SKPickerConfig()
        config.splitLimitHidden = false
        let start = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 3))
        let end = Date().add(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 3))
        config.timeLimit = (start, end)
        let pickerConfiguration = [config, config, config]
        
        let picker = SKDatePeriodPickerView.init(types: [.MONTH, .WEEK, .DAY], configuration: configuation, configuration: pickerConfiguration)
        picker.selectedIndex = 1
        picker.delegate = self
        picker.locale = Locale(identifier: "CTS")
        
        UIApplication.shared.keyWindow?.addSubview(picker)
    }
}

extension PopupStyleViewController: SKDatePeriodDateDelegate {
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
    }
    
    func SKPeriodLeftButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        print("左边按钮")
    }
    
    func SKPeriodRightButton(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        print("右边按钮")
    }
}
