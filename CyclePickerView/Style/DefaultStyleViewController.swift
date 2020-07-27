//
//  DefaultStyleViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.

import UIKit

class DefaultStyleViewController: BaseViewController {
    var picker: SKDatePeriodPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addShowButton()
        addShowTimeLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPickerView(UIButton())
        }
        
        let pickerConfig = SKPickerConfiguration(start: Date(timeIntervalSince1970: TimeInterval(10000)), end: Date())
        picker = SKDatePeriodPickerView(types: [.MONTH, .WEEK, .DAY], pickerConfig: [pickerConfig, pickerConfig, pickerConfig])
        picker.delegate = self
    }
    
    override func showPickerView(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.addSubview(picker)
    }
    
}

extension DefaultStyleViewController: SKDatePeriodDateDelegate {
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
    }
}

