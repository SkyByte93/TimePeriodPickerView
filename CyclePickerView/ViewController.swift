//
//  ViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) { view.backgroundColor = .systemBackground }
        
        addConstaint()
    }
    
    lazy var time: UILabel = {
        let text = UILabel()
        text.text = ""
        if #available(iOS 13.0, *) {
            text.textColor = .label
        }else {
            text.textColor = .black
        }
        text.font = .systemFont(ofSize: 20)
        return text
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        if #available(iOS 13.0, *) {
            button.setTitleColor(.label, for: .normal)
        } else {
            button.setTitleColor(.black, for: .normal)
        }
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showPickerView(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func showPickerView(_ sender: UIButton) {
        let configuation = ToolViewConfiguration()
        configuation.isExchangeToolButton = false
        let picker = DatePeriodPickerView.init(types: [.WEEK, .MONTH, .DAY], configuration: configuation)
        picker.delegate = self
        view.addSubview(picker)
    }
}
extension ViewController: DatePeriodDataDelegate {
    func selected(pickerView: DatePeriodPickerView, type: CycleType, start: PeriodDate, end: PeriodDate) {
        time.text = "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日"
    }
}

extension ViewController {
    
    func addConstaint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        time.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(time)
        view.addConstraints([NSLayoutConstraint(item: time, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: time, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -100)])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.addConstraints([NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)])
    }
}
