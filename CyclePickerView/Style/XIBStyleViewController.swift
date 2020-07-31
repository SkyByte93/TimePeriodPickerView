//
//  XIBStyleViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit
import PhotosUI

class XIBStyleViewController: UIViewController {
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var remove: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var periodPickerView: SKDatePeriodPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerConfig = SKPickerConfiguration(start: Date(timeIntervalSince1970: TimeInterval(10000)), end: Date())
        periodPickerView = SKDatePeriodPickerView(types: [.MONTH, .WEEK, .DAY], pickerConfig: [pickerConfig, pickerConfig, pickerConfig])
        periodPickerView.delegate = self
        
    }
}

extension XIBStyleViewController: SKDatePeriodDateDelegate {
    func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
//        set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
    }
}
