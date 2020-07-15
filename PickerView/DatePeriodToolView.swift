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

class DatePeriodToolView: UIView {
    ///
    public weak var delegate: ToolProtocol?
    
    public var selectedIndex: Int = 0 {
        willSet { animationChnage(index: newValue) }
    }
    
    var configuation: ToolViewConfiguration!
    ///
    private(set) var typesBtnArr = Array<DateTypeModel>()
    
    ///
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuation.leftTitle, for: .normal)
        button.setTitleColor(configuation.leftColor, for: .normal)
        button.titleLabel?.font = configuation.leftFont
        button.addTarget(self, action: #selector(leftButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(configuation.rightTitle, for: .normal)
        button.setTitleColor(configuation.rightColor, for: .normal)
        button.titleLabel?.font = configuation.rightFont
        button.addTarget(self, action: #selector(rightButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    fileprivate func setTypeButton(_ item: inout DateTypeModel, selected: Bool) {
        let color = selected ? configuation.selectedButtonColor : configuation.normalButtonColor
        let font = selected ? configuation.selectedButtonFont : configuation.normalButtonFont
        item.button.titleLabel?.font = font
        item.button.setTitleColor(color, for: .normal)
        item.isSelected = selected
    }
    
    ///
    @objc func typesButton(_ sender: UIButton) {
        for (index, item) in typesBtnArr.enumerated() where item.button == sender {
            if let delegate = delegate {
                delegate.tool(selected: item.type, selected: index)
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
    
    @objc func rightButtonEvent() {
        guard let delegate = delegate else { return }
        delegate.tool(left: nil, right: rightButton)
    }
    
    @objc func leftButtonEvent() {
        guard let delegate = delegate else { return }
        delegate.tool(left: leftButton, right: nil)
    }
    
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
    
    ///
    fileprivate func makeLeftAndRightButton(_ bool: Bool) {
        if !bool {
            leftButton.frame = configuation.leftFrame
            rightButton.frame = configuation.rightFrame
        }else {
            leftButton.frame = configuation.rightFrame
            rightButton.frame = configuation.leftFrame
        }
    }
    
    ///
    public init(types: Array<CycleType>, config: ToolViewConfiguration) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        
        configuation = config
        makeLeftAndRightButton(configuation.isExchangeToolButton)
        backgroundColor = configuation.background
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        makeTypeItem(types)
    }
    
    /// 制作类型日期选项按钮
    fileprivate func makeTypeItem(_ types: Array<CycleType>) {
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
    fileprivate func makeTypeButtonArray(types: Array<CycleType>, in array: inout Array<DateTypeModel>) {
        for (index, item) in types.enumerated() {
            let button = UIButton()
            button.addTarget(self, action: #selector(typesButton(_:)), for: .touchUpInside)
            switch item {
            case .DAY: button.setTitle("天", for: .normal)
            case .MONTH: button.setTitle("月", for: .normal)
            case .WEEK: button.setTitle("周", for: .normal)
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
