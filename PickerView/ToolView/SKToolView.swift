//
//  SKToolView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/20.
//  Copyright © 2020 jetson. All rights reserved.
//


import UIKit
import Foundation

typealias SelecteBlock = (_ type: SKPeriodType,_ pickerViewIndex: Int,_ start: SKPeriodDate,_ end: SKPeriodDate) -> Void

class SKToolView: UIView {
    
    var typesBtnArr = Array<DateTypeModel>()
    
    var delegate: SKToolViewProtocol?
    ///
    var configuration: SKToolViewConfiguration!
    /// 选中block回调
    var selectedBlock: SelecteBlock?
    
    init(config: SKToolViewConfiguration) {
        super.init(frame: .zero)
        configuration = config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    final func hidenPeriodTimeView() {
        if let delegate = delegate { delegate.hidenTimePeriod() }
    }
}
