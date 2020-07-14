//
//  MonthPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class MonthPickerView: UIPickerView {
    private(set) var monthData = Array<(Int, Array<Int>)>()
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 300))
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MonthPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthData.count
        }else {
            return monthData.count > 0 ? monthData[pickerView.selectedRow(inComponent: 0)].1.count : 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return bounds.width / 2
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //设置分割线
        for view in pickerView.subviews where view.frame.size.height <= 1 {
            view.isHidden = false
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: 1)
            view.backgroundColor = .white
        }
        // 修改字体样式
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.font = UIFont.systemFont(ofSize: 18)
        pickerLabel?.textColor = .red
        
        if component == 0 {
            pickerLabel?.text = "\(monthData[row].0)年"
        }else {
            guard monthData[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            pickerLabel?.text = "\(monthData[pickerView.selectedRow(inComponent: 0)].1[row])月"
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(monthData[row].0)年"
        }else {
            return "\(monthData[pickerView.selectedRow(inComponent: 0)].1[row])月"
        }
    }
}
