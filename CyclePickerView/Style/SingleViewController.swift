//
//  SingleViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class SingleViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addDisplayButton()
        addDisplayTimeLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPickerView(UIButton())
        }
    }
    
    override func showPickerView(_ sender: UIButton) {
        let start = Date().subtract(TimeChunk(days: 0, weeks: 0, months: 0, years: 50))
        let end = Date().add(TimeChunk(days: 0, weeks: 0, months: 0, years: 50))
        let pickerConfig = SKPickerConfiguration(start: start, end: end)
        
        let picker = SKDatePeriodPickerView(types: [.DAY], pickerConfig: [pickerConfig])
        picker.delegate = self
        
        SKPickerView = picker
        
//        addPickerViewConstraints()
    }
}

extension SingleViewController: SKDatePeriodDateDelegate {
    
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
    }
}
