//
//  ViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/6.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class PopupStyleViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PopupStyleViewController"
        addConstaint()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showPickerView(UIButton())
        }
    }
    
    lazy var time: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 0
        text.textColor = .color(default: .black, darkMode: .white)
        text.font = .systemFont(ofSize: 20)
        return text
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.setTitleColor(.color(default: .black, darkMode: .white), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showPickerView(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func showPickerView(_ sender: UIButton) {
        let configuation = ToolViewConfiguration()
        configuation.isExchangeToolButton = false
        
        let config = PickerConfig()
        config.splitLimitHidden = false
        let pickerConfiguration = [config, config, config]
        let picker = DatePeriodPickerView.init(types: [.MONTH, .WEEK, .DAY], configuration: configuation, configuration: pickerConfiguration)
        picker.delegate = self
        
        UIApplication.shared.keyWindow?.addSubview(picker)
    }
}

extension PopupStyleViewController: DatePeriodDataDelegate {
    func SKPeriod(periodView: DatePeriodPickerView, timeType: CycleType, start: PeriodDate, end: PeriodDate) {
        time.text = "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)"
    }
    
    func SKPeriodLeftButton(periodView: DatePeriodPickerView, timeType: CycleType, start: PeriodDate, end: PeriodDate) {
        print("左边按钮")
    }
    
    func SKPeriodRightButton(periodView: DatePeriodPickerView, timeType: CycleType, start: PeriodDate, end: PeriodDate) {
        print("右边按钮")
    }
}

extension PopupStyleViewController {
    func addConstaint() {
        
        time.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(time)
        view.addConstraints([NSLayoutConstraint(item: time, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: time, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -100),
                             NSLayoutConstraint(item: time, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: time, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.addConstraints([NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)])
    }
}
