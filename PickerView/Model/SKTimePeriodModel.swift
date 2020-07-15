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
    var type: CycleType!
    var pickerView: UIPickerView!
    init(type: CycleType ,picker: UIPickerView) {
        pickerView = picker
    }
}

class DateTypeModel: Equatable {
    static func == (lhs: DateTypeModel, rhs: DateTypeModel) -> Bool {
        return lhs.button == rhs.button
    }
    
    var isSelected: Bool!
    var index: Int!
    var type: CycleType!
    var button: UIButton!
    init(isSelected: Bool,index: Int,type: CycleType,button: UIButton) {
        self.isSelected = isSelected
        self.index = index
        self.type = type
        self.button = button
    }
}
