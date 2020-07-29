//
//  DateTypeModel.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/28.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class DateTypeModel: Equatable {
    static func == (lhs: DateTypeModel, rhs: DateTypeModel) -> Bool {
        return lhs.button == rhs.button
    }
    
    var isSelected: Bool!
    var index: Int!
    var type: SKPeriodType!
    var button: UIButton!
    init(isSelected: Bool, index: Int,type: SKPeriodType,button: UIButton) {
        self.isSelected = isSelected
        self.index = index
        self.type = type
        self.button = button
    }
}

