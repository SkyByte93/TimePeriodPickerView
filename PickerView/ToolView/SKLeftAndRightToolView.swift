//
//  SKLeftAndRightToolView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/29.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class SKLeftAndRightToolView: SKToolView {
    
    ///
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuration.leftTitle, for: .normal)
        button.setTitleColor(configuration.leftColor, for: .normal)
        button.titleLabel?.font = configuration.leftFont
        button.addTarget(self, action: #selector(leftButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuration.rightTitle, for: .normal)
        button.setTitleColor(configuration.rightColor, for: .normal)
        button.titleLabel?.font = configuration.rightFont
        button.addTarget(self, action: #selector(rightButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    public func makeLeftAndRightButton() {
        addLeftButtonConstraints()
        addRightButtonConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    /// event is right button
    @objc func rightButtonEvent() {
        hidenPeriodTimeView()
    }
    
    /// event is left button
    @objc func leftButtonEvent() {
        hidenPeriodTimeView()
    }
    
    /// listen device orientation change
    @objc fileprivate func onDeviceOrientationDidChange() {
        switch UIDevice.current.orientation {
        case .portrait:
            leftButtonLeftConstraint.constant = 0
            rightButtonRightConstraint.constant = 0
        case .landscapeLeft:
            leftButtonLeftConstraint.constant = leftSafeArea
            rightButtonRightConstraint.constant = 0
        case .landscapeRight:
            rightButtonRightConstraint.constant = -rightSafeArea
            leftButtonLeftConstraint.constant = 0
        default: return
        }
    }
    
    fileprivate var leftButtonLeftConstraint: NSLayoutConstraint!
    fileprivate var rightButtonRightConstraint: NSLayoutConstraint!
    
    ///
    fileprivate func addLeftButtonConstraints() {
        addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButtonLeftConstraint = NSLayoutConstraint(item: leftButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: getLeftButtonDefaultSafe())
        addConstraints([leftButtonLeftConstraint,
                        NSLayoutConstraint(item: leftButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: leftButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: leftButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)])
    }
    
    ///
    fileprivate func addRightButtonConstraints() {
        addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButtonRightConstraint = NSLayoutConstraint(item: rightButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: getRightButtonDefaultSafe())
        addConstraints([rightButtonRightConstraint,
                        NSLayoutConstraint(item: rightButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: rightButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)])
    }
    
    ///
    fileprivate func getLeftButtonDefaultSafe() -> CGFloat {
        return UIDevice.current.orientation == .landscapeLeft ? leftSafeArea : 0
    }
    
    ///
    fileprivate func getRightButtonDefaultSafe() -> CGFloat {
        return UIDevice.current.orientation == .landscapeRight ? -rightSafeArea : 0
    }
    
    ///
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
