//
//  DatePeriodToolView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/13.
//  Copyright © 2020 jetson. All rights reserved.
//
import UIKit
import Foundation
let TextChangeAnimated = 0.5

class SKDatePeriodToolView: SKLeftAndRightToolView {
    ///
    public var selectedIndex: Int = 0 {
        willSet { animationChnage(index: newValue) }
    }
    
    ///
    fileprivate func setTypeButton(_ item: inout DateTypeModel, selected: Bool) {
        let color = selected ? configuration.selectedButtonColor : configuration.normalButtonColor
        let font = selected ? configuration.selectedButtonFont : configuration.normalButtonFont
        item.button.titleLabel?.font = font
        item.button.setTitleColor(color, for: .normal)
        item.isSelected = selected
    }
    
    ///
    @objc func typesButton(_ sender: UIButton) {
        for (index, item) in typesBtnArr.enumerated() where item.button == sender {
            if let delegate = delegate {
                delegate.selectePickerView(selected: item.type, selected: index)
            }
            animationChnage(index: index)
        }
    }
    
    /// 改变选中日期类型动画
    public func animationChnage(index: Int) {
        assert(index < typesBtnArr.count, "index 超出下标位置")
        let oldItem = typesBtnArr.filter{ $0.isSelected }.first
        var newItem = typesBtnArr[index]
        guard oldItem != newItem, var lodItem = oldItem else { return }
        #warning("结构体类型的DateTypeModel会出现值错误的情况, 可以优化")
        self.setTypeButton(&lodItem, selected: false)
        self.setTypeButton(&newItem, selected: true)
    }
    
    ///
    public init(types: Array<SKPeriodType>, config: SKToolViewConfiguration) {
        super.init(config: config)
        
        makeLeftAndRightButton()
        backgroundColor = configuration.background
        
        makeTypeItem(types)
        
        self.selectedBlock = { (type, pickerIndex, start, end) in
        }
    }
    
    /// 制作类型日期选项按钮
    fileprivate func makeTypeItem(_ types: Array<SKPeriodType>) {
        // 当ToolView上已经有类型日期选项按钮时, 删除toolView上的类型日期选项按钮
        if typesBtnArr.count > 0 { removeTypesButton() }
        // 计算类型日期选项按钮尺寸
        makeTypeButtonArray(types: types, in: &typesBtnArr)
        // 添加toolView上的类型日期选项按钮
        addTypesButtonToToolView()
    }
    
    /// 删除类型日期选项按钮
    fileprivate func removeTypesButton() {
//        for item in typesBtnArr {
//            item.button.removeFromSuperview()
//        }
    }
    
    /// 新建类型日期选项按钮, 并计算尺寸, 添加到typesButtonArr中.
    fileprivate func makeTypeButtonArray(types: Array<SKPeriodType>, in array: inout Array<DateTypeModel>) {
        for (index, item) in types.enumerated() {
            let button = UIButton()
            button.addTarget(self, action: #selector(typesButton(_:)), for: .touchUpInside)
            switch item {
            case .MONTH: button.setTitle("月", for: .normal)
            case .WEEK: button.setTitle("周", for: .normal)
            case .DAY: button.setTitle("天", for: .normal)
            }
            
            array.append(DateTypeModel(isSelected: selectedIndex == index, index: index,type: item, button: button))
            setTypeButton(&array[index], selected: selectedIndex == index)
        }
    }
    
    /// 添加类型日期选项按钮到toolView上
    fileprivate func addTypesButtonToToolView() {
        for item in typesBtnArr {
            addSubview(item.button)
        }
        addMedianTypesButtonConstraints()
    }
    
    func addMedianTypesButtonConstraints() {
        guard typesBtnArr.count > 0 else { return }
        if typesBtnArr.count % 2 == 0 {
            let median = Int(typesBtnArr.count / 2)
            let previousMedian = typesBtnArr[median - 1].button!
            let lastMedian = typesBtnArr[median].button!
            
            //left
            previousMedian.translatesAutoresizingMaskIntoConstraints = false
            addConstraint(NSLayoutConstraint(item: previousMedian, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
            addTypesButtonConstraints(button: previousMedian)
            
            //right
            lastMedian.translatesAutoresizingMaskIntoConstraints = false
            addConstraint(NSLayoutConstraint(item: lastMedian, attribute: .left, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
            addTypesButtonConstraints(button: lastMedian)
            
            var internalNumber = 0
            while median - internalNumber - 2 >= 0 {
                addLeftTypesButtonConstraints(last: typesBtnArr[median - internalNumber - 1].button, current: typesBtnArr[median - internalNumber - 2].button)
                addRightTypesButtonConstraints(last: typesBtnArr[median + internalNumber].button, current: typesBtnArr[median + internalNumber + 1].button)
                internalNumber += 1
            }
        }else {
            let median = Int(typesBtnArr.count / 2)
            let centerMedian = typesBtnArr[median].button!
            
            // center
            centerMedian.translatesAutoresizingMaskIntoConstraints = false
            addConstraint(NSLayoutConstraint(item: centerMedian, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
            addTypesButtonConstraints(button: centerMedian)
            
            var internalNumber = 1
            while median - internalNumber >= 0 {
                addLeftTypesButtonConstraints(last: typesBtnArr[median - internalNumber + 1].button, current: typesBtnArr[median - internalNumber].button)
                addRightTypesButtonConstraints(last: typesBtnArr[median + internalNumber - 1].button, current: typesBtnArr[median + internalNumber].button)
                internalNumber += 1
            }
        }
    }
    
    func addTypesButtonConstraints(button: UIButton) {
        addConstraints([NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)])
    }
    
    func addLeftTypesButtonConstraints(last: UIButton, current: UIButton) {
        current.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: current, attribute: .right, relatedBy: .equal, toItem: last, attribute: .left, multiplier: 1.0, constant: 0))
        addTypesButtonConstraints(button: current)
    }
    
    func addRightTypesButtonConstraints(last: UIButton, current: UIButton) {
        current.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: current, attribute: .left, relatedBy: .equal, toItem: last, attribute: .right, multiplier: 1.0, constant: 0))
        addTypesButtonConstraints(button: current)
    }
    
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
