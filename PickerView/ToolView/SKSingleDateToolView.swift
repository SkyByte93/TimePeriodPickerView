//
//  SKSingleDateToolView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/20.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class SKSingleDateToolView: SKLeftAndRightToolView {
    
    ///
    fileprivate lazy var currentDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = configuration.selecteTimeFont
        label.textColor = configuration.selecteTimeColor
        return label
    }()
    
    ///
    override init(config: SKToolViewConfiguration) {
        super.init(config: config)
        makeLeftAndRightButton()
        backgroundColor = configuration.background
        
        if configuration.isShowSelecteTime { addCurrentDateConstraints() }
        
        self.selectedBlock = { (type, pickerIndex, startTime, endTime) in
            let start = Date(year: startTime.0, month: startTime.1, day: startTime.2).format(with: self.configuration.selecteTimeFormat)
            let end = Date(year: endTime.0, month: endTime.1, day: endTime.2).format(with: self.configuration.selecteTimeFormat)
            self.currentDate.text = "\(start)\(self.configuration.startingTimeAndEndingTime)\(end)"
        }
    }
    
    func addCurrentDateConstraints() {
        addSubview(currentDate)
        currentDate.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: currentDate, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: currentDate, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: currentDate, attribute: .left, relatedBy: .equal, toItem: leftButton, attribute: .right, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: currentDate, attribute: .right, relatedBy: .equal, toItem: rightButton, attribute: .left, multiplier: 1.0, constant: 0),])
    }
    
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
