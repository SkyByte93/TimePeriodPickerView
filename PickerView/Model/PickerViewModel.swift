//
//  SKTimePeriodModel.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

public class PickerViewModel {
    var isSelected: Bool!
    var type: SKPeriodType!
    var pickerView: UIPickerView!
    
    init(type: SKPeriodType ,picker: UIPickerView, isSelected: Bool) {
        pickerView = picker
        self.type = type
        self.isSelected = isSelected
    }
}

