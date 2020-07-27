//
//  SKSingleDateToolView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/20.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class SKSingleDateToolView: SKToolView {
    
    ///
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuration.leftTitle, for: .normal)
        button.setTitleColor(configuration.leftColor, for: .normal)
        button.titleLabel?.font = configuration.leftFont
        button.addTarget(self, action: #selector(leftButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuration.rightTitle, for: .normal)
        button.setTitleColor(configuration.rightColor, for: .normal)
        button.titleLabel?.font = configuration.rightFont
        button.addTarget(self, action: #selector(rightButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    lazy var currentDate: UILabel = {
        let leftWidth = configuration.isExchangeToolButton ? leftButton.bounds.width : rightButton.bounds.width
        let rightWidth = configuration.isExchangeToolButton ? rightButton.bounds.width : leftButton.bounds.width
        let label = UILabel(frame: CGRect(x: leftWidth + 10, y: 0, width: kScreenW - rightWidth - leftWidth - 20, height: bounds.height))
        label.textAlignment = .center
        label.font = configuration.selecteTimeFont
        label.textColor = configuration.selecteTimeColor
        return label
    }()
    
    ///
    public init(config: SKToolViewConfiguration) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        
        configuration = config
        makeLeftAndRightButton(configuration.isExchangeToolButton)
        backgroundColor = configuration.background
        
        addSubview(leftButton)
        addSubview(rightButton)
        if configuration.isShowSelecteTime { addSubview(currentDate) }
        
        self.selectedBlock = { (type, pickerIndex, startTime, endTime) in
            let start = Date(year: startTime.0, month: startTime.1, day: startTime.2).format(with: self.configuration.selecteTimeFormat)
            let end = Date(year: endTime.0, month: endTime.1, day: endTime.2).format(with: self.configuration.selecteTimeFormat)
            self.currentDate.text = "\(start)\(self.configuration.startingTimeAndEndingTime)\(end)"
        }
    }
    
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    ///
    fileprivate func makeLeftAndRightButton(_ bool: Bool) {
        if !bool {
            leftButton.frame = configuration.leftFrame
            rightButton.frame = configuration.rightFrame
        }else {
            leftButton.frame = configuration.rightFrame
            rightButton.frame = configuration.leftFrame
        }
    }
    
    ///
    @objc func rightButtonEvent() {
        hidenPeriodTimeView()
    }
    
    ///
    @objc func leftButtonEvent() {
        hidenPeriodTimeView()
    }
    
}
