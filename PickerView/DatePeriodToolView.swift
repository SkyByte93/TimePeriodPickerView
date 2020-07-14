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

protocol ToolProtocol: NSObjectProtocol {
    func tool(left leftBtn: UIButton?, right rightBtn: UIButton?)
    func tool(selected type: CycleType, selected index: Int)
}

class DateTypeModel: Equatable {
    static func == (lhs: DateTypeModel, rhs: DateTypeModel) -> Bool {
        return lhs.button == rhs.button
    }
    
    var isSelected: Bool!
    var index: Int!
    var type: CycleType!
    var button: UIButton!
    init(isSelected: Bool,index: Int,type: CycleType,button: UIButton) {
        self.isSelected = isSelected
        self.index = index
        self.type = type
        self.button = button
    }
}

class DatePeriodToolView: UIView {
    public weak var delegate: ToolProtocol?
    
    /// 是否交换工具栏左边和右边的按钮
    public var isExchangeToolButton: Bool = false {
        willSet { makeLeftAndRightButton(newValue) }
    }
    
    public var leftFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 44) {
        willSet { leftButton.frame = newValue }
    }
    
    public var rightFrame: CGRect = CGRect(x: kScreenW - 60, y: 0, width: 60, height: 44) {
        willSet { rightButton.frame = newValue }
    }
    ///
    public var leftTitle: String = "取消" {
        willSet { leftButton.setTitle(newValue, for: .normal) }
    }
    
    public var leftFont: UIFont = .boldSystemFont(ofSize: 16) {
        willSet { leftButton.titleLabel?.font = newValue }
    }
    
    public var leftColor: UIColor = .lightGray {
        willSet { leftButton.setTitleColor(newValue, for: .normal) }
    }
    
    public var rightTitle: String = "确定" {
        willSet { rightButton.setTitle(newValue, for: .normal) }
    }
    
    public var rightFont: UIFont = .boldSystemFont(ofSize: 16) {
        willSet { rightButton.titleLabel?.font = newValue }
    }
    
    public var rightColor: UIColor = .black {
        willSet { rightButton.setTitleColor(newValue, for: .normal)}
    }
    
    public var selectedButtonFont: UIFont = .boldSystemFont(ofSize: 20) {
        willSet {
            for item in typesBtnArr where item.isSelected {
                item.button.titleLabel?.font = newValue
            }
        }
    }
    
    public var selectedButtonColor: UIColor = .black {
        willSet {
            for item in typesBtnArr where item.isSelected {
                item.button.setTitleColor(newValue, for: .normal)
            }
        }
    }
    
    public var normalButtonFont: UIFont = .systemFont(ofSize: 16) {
        willSet {
            for item in typesBtnArr where !item.isSelected {
                item.button.titleLabel?.font = newValue
            }
        }
    }
    
    public var normalButtonColor: UIColor = .lightGray {
        willSet {
            for item in typesBtnArr where !item.isSelected {
                item.button.setTitleColor(newValue, for: .normal)
            }
        }
    }
    
    public var selectedIndex: Int = 0 {
        willSet { animationChnage(index: newValue) }
    }
    
    ///
    private(set) var type: CycleType = .WEEK
    
    ///
    fileprivate var typesBtnArr = Array<DateTypeModel>()
    
    ///
    fileprivate lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(leftTitle, for: .normal)
        button.setTitleColor(leftColor, for: .normal)
        button.titleLabel?.font = leftFont
        button.addTarget(self, action: #selector(leftButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    fileprivate lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(rightTitle, for: .normal)
        button.setTitleColor(rightColor, for: .normal)
        button.titleLabel?.font = rightFont
        button.addTarget(self, action: #selector(rightButtonEvent), for: .touchUpInside)
        return button
    }()
    
    ///
    fileprivate func setTypeButton(_ item: inout DateTypeModel, selected: Bool) {
        let color = selected ? selectedButtonColor : normalButtonColor
        let font = selected ? selectedButtonFont : normalButtonFont
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
        assert(index < typesBtnArr.count, "给定位置错误!")
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
//
//        return nil
//    }

    
    ///
    fileprivate func makeLeftAndRightButton(_ bool: Bool) {
        if !bool {
            leftButton.frame = leftFrame
            rightButton.frame = rightFrame
        }else {
            leftButton.frame = rightFrame
            rightButton.frame = leftFrame
        }
    }
    
    ///
    public init(types: Array<CycleType>) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        makeLeftAndRightButton(isExchangeToolButton)
        
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
