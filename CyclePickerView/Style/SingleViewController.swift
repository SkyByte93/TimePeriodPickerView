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
        addShowButton()
        addShowTimeLabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPickerView(UIButton())
        }
    }
    
    override func showPickerView(_ sender: UIButton) {
        let configuation = SKToolViewConfiguration()
        let config = SKPickerConfiguration()
        let start = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 300))
        let end = Date().add(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 300))
        config.timeLimit = (start, end)
        let pickerConfiguration = [config]
        
        let picker = SKDatePeriodPickerView.init(types: [.MONTH], configuration: configuation, configuration: pickerConfiguration)
        picker.delegate = self
        UIApplication.shared.keyWindow?.addSubview(picker)
    }
}

extension SingleViewController: SKDatePeriodDateDelegate {
    ///
    func pickerView(pickerView: UIPickerView, type: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(type)")
    }
}
