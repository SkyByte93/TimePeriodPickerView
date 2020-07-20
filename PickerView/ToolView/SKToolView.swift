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
    
    init(frame: CGRect, config: SKToolViewConfiguration) {
        super.init(frame: frame)
        configuration = config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    final func hidenPeriodTimeView() {
        if let delegate = delegate { delegate.hiden() }
    }
    
    ///
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        guard isUserInteractionEnabled || !isHidden || !(alpha <= 0.01) else { return nil }
//        /// 遍历图层
//        for subview in subviews.reversed() {
//            let convertedPoint = subview.convert(point, from: self)
//            let hitTestView = subview.hitTest(convertedPoint, with: event)
//            if let view = hitTestView { return view }
//        }
//        return nil
//    }
}
