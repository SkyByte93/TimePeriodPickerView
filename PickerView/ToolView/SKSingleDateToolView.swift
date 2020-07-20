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
        
        self.selectedBlock = { (type, pickerIndex, start, end) in
            let start = Date(year: start.0, month: start.1, day: start.2).format(with: self.configuration.selecteTimeFormat)
            let end = Date(year: end.0, month: end.1, day: end.2).format(with: self.configuration.selecteTimeFormat)
            self.currentDate.text = "\(start)\(self.configuration.startingTimeAndEndingTime)\(end)"
        }
    }
    
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
//        guard let delegate = defaultDelegate else { return }
//        delegate.tool(left: nil, right: rightButton)
    }
    
    ///
    @objc func leftButtonEvent() {
        hidenPeriodTimeView()
//        guard let delegate = defaultDelegate else { return }
//        delegate.tool(left: leftButton, right: nil)
    }
    
}
