//
//  BaseViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @objc func showPickerView(_ sender: UIButton) {}
    public var titleText: String?
    
    var SKPickerView: SKDatePeriodPickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        view.backgroundColor = .color(light: .white, dark: .black)
    }
    
    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.setTitleColor(.color(light: .black, dark: .white), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showPickerView(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var time: UILabel = {
        let text = UILabel()
        text.textAlignment = .center
        text.numberOfLines = 0
        text.textColor = .color(light: .black, dark: .white)
        text.font = .systemFont(ofSize: 20)
        return text
    }()
    
    func set(time text: String) {
        self.time.text = text
    }
    
    func addPickerViewConstraints() {
        guard let view = navigationController?.view else { return }
        guard let pickerview = SKPickerView else { return }
        pickerview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerview)
        view.addConstraints([NSLayoutConstraint(item: pickerview, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: pickerview, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: pickerview, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: pickerview, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)])
    }
    
    func addDisplayButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.addConstraints([NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)])
    }
    
    func addDisplayTimeLabel() {
        time.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(time)
        view.addConstraints([NSLayoutConstraint(item: time, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: time, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -100),
                             NSLayoutConstraint(item: time, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: time, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)])
    }
    
}
