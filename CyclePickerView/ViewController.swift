//
//  ViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var startDate = ""
    var endDate = ""
    
//    lazy var picker: DatePeriodPickerView = {
//        let picker = DatePeriodPickerView.init(types: [.DAY, .WEEK, .MONTH])
//        return picker
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showPickerView(_ sender: UIButton) {
        let picker = DatePeriodPickerView.init(types: [.DAY, .WEEK, .MONTH])
        view.addSubview(picker)
    }
}

