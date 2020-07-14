//
//  WeekPickerView.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation
import UIKit

class WeekPickerView: UIPickerView {
    private(set) var weekData = Array<(Int, Array<((Int), (Int, Int, Int), (Int, Int, Int))>)>()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 300))
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension WeekPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return weekData.count
        }else {
            return weekData.count > 0 ? weekData[pickerView.selectedRow(inComponent: 0)].1.count : 0
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
            pickerLabel?.text = "\(weekData[row].0)年"
        }else {
            guard weekData[pickerView.selectedRow(inComponent: 0)].1.count >= row else { return pickerLabel! }
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            pickerLabel?.text = "\(weekSelcted.0)(\(weekSelcted.1.1.ddToDD()).\(weekSelcted.1.2.ddToDD())~\(weekSelcted.2.1.ddToDD()).\(weekSelcted.2.2.ddToDD()))"
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
            return "\(weekData[row].0)年"
        }else {
            let weekSelcted = weekData[pickerView.selectedRow(inComponent: 0)].1[row]
            return "\(weekSelcted.0)(\(weekSelcted.1.0.ddToDD()).\(weekSelcted.1.1.ddToDD())~\(weekSelcted.2.0.ddToDD()).\(weekSelcted.2.1.ddToDD()))"
        }
    }
}
