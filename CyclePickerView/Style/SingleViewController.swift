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
        let toolConfig = SKToolViewConfiguration()
        let pickerConfig = SKPickerConfiguration()
        let start = Date().subtract(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 300))
        let end = Date().add(TimeChunk(seconds: 0, minutes: 0, hours: 0, days: 3, weeks: 3, months: 0, years: 300))
        pickerConfig.timeLimit = (start, end)
        let picker = SKDatePeriodPickerView.init(types: [.MONTH], toolConfig: toolConfig, pickerConfig: [pickerConfig])
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
