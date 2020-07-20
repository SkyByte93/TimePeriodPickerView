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

class SKDatePeriodToolView: SKToolView {
    
    ///
    public var selectedIndex: Int = 0 {
        willSet { animationChnage(index: newValue) }
    }
    
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
    @objc func rightButtonEvent() {
        hidenPeriodTimeView()
    }
    
    ///
    @objc func leftButtonEvent() {
        hidenPeriodTimeView()
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
    public init(types: Array<SKPeriodType>, config: SKToolViewConfiguration) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        
        configuration = config
        makeLeftAndRightButton(configuration.isExchangeToolButton)
        backgroundColor = configuration.background
        
        addSubview(leftButton)
        addSubview(rightButton)
        
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
            case .HOUR: button.setTitle("小时", for: .normal)
            case .MINUTE: button.setTitle("分", for: .normal)
            case .SECOND: break
            }
            
            array.append(DateTypeModel(isSelected: selectedIndex == index, index: index,type: item, button: button))
            setTypeButton(&array[index], selected: selectedIndex == index)
        }
    }
    
    /// 添加类型日期选项按钮到toolView上
    fileprivate func addTypesButtonToToolView() {
        let totalWidth = typesBtnArr.count * 60
        for (index, item) in typesBtnArr.enumerated() {
            item.button.frame = CGRect(x: (Int(kScreenW) - totalWidth) / 2 + (60 * index), y: 0, width: 60, height: 44)
            addSubview(item.button)
        }
    }
    
    ///
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
