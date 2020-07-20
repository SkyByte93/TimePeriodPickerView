//
//  ToolViewConfiguartion.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class SKToolViewConfiguration: NSObject {
    /*
     More picker View
     */
    /// 工具栏背景色
    public var background: UIColor = .color(default: .white, darkMode: .black)
    /// 是否交换工具栏左边和右边的按钮
    public var isExchangeToolButton: Bool = false
    /// 左边按钮尺寸
    public var leftFrame: CGRect = CGRect(x: 0, y: 0, width: 60, height: 44)
    ///
    public var leftTitle: String = "取消"
    ///
    public var leftFont: UIFont = .boldSystemFont(ofSize: 16)
    ///
    public var leftColor: UIColor = .color(default: .lightGray, darkMode: .lightGray)
    
    ///
    public var rightFrame: CGRect = CGRect(x: kScreenW - 60, y: 0, width: 60, height: 44)
    ///
    public var rightTitle: String = "确定"
    
    ///
    public var rightFont: UIFont = .boldSystemFont(ofSize: 16)
    ///
    public var rightColor: UIColor = .color(default: .black, darkMode: .white)
    ///
    public var selectedButtonFont: UIFont = .boldSystemFont(ofSize: 20)
    
    ///
    public var selectedButtonColor: UIColor = .color(default: .black, darkMode: .white)
    ///
    public var normalButtonFont: UIFont = .systemFont(ofSize: 16)
    ///
    public var normalButtonColor: UIColor = .color(default: .lightGray, darkMode: .lightGray)
    
    /*
     Single picker View
     */
    ///
    public var isShowSelecteTime: Bool = true
    ///
    public var selecteTimeFont: UIFont = .systemFont(ofSize: 18)
    ///
    public var selecteTimeColor: UIColor = .color(default: .darkGray, darkMode: .darkGray)
    
    public var selecteTimeFormat: String = "YYYY-DD-MM"
    
    public var startingTimeAndEndingTime: String = "~"
    
    override init() {
        super.init()
    }
}
