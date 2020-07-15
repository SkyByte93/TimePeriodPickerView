//
//  BaseViewController.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var titleText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleText
        view.backgroundColor = .color(default: .white, darkMode: .black)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
