//
//  SKTimePeriod.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/15.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

struct ListModel {
    var title: String!
    var detail: String!
}

class SKTimePeriodTableView: UITableViewController {
    var datas = [("样式",[ListModel(title: "弹窗样式", detail: "PopupStyleViewController"),
                            ListModel(title: "默认样式", detail: "DefaultStyleViewController"),
                            ListModel(title: "XIB适配", detail: "XIBStyleViewController"),
                            ListModel(title: "单个周期选择器", detail: "SingleViewController"),
                            ListModel(title: "多个周期选择器", detail: "MoreViewController")
                ]),
                 ("格式",[ListModel(title: "年", detail: "DefaultFormatViewController"),
                            ListModel(title: "月", detail: "MonthFormatViewController"),
                            ListModel(title: "日", detail: "DayFormatViewController"),
                            ListModel(title: "时", detail: "HourFormatViewController"),
                            ListModel(title: "分", detail: "MinthFormatViewController")
                 ]),
                 ("自定义",[ListModel(title: "工具栏自定义", detail: "ToolCustomViewController"),
                               ListModel(title: "自定义时间格式", detail: "TimeFormatCustomViewController")
                 ])
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "时间周期选择器"
        
        tableView(UITableView(), didSelectRowAt: IndexPath(row: 3, section: 0))
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier")
        let model = datas[indexPath.section].1[indexPath.row]
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.detail
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datas[section].0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0 ,0): push(vc: PopupStyleViewController(), indexPath)
        case (0, 1): push(vc: DefaultStyleViewController(), indexPath)
        case (0, 2): pushXIB(vc: XIBStyleViewController(), indexPath)
        case (0, 3): push(vc: SingleViewController(), indexPath)
        case (0, 4): push(vc: PopupStyleViewController(), indexPath)
        case (1, 0): push(vc: DefaultFormatViewController(), indexPath)
        case (_, _): break
        }
    }
    
    fileprivate func pushXIB(vc: BaseViewController,_ indexPath: IndexPath) {
        guard let name = datas[indexPath.section].1[indexPath.row].detail else { return }
        guard let resource = Bundle.main.loadNibNamed(name, owner: nil, options: nil), let xib = resource[0] as? BaseViewController else { return }
        navigationController?.pushViewController(xib, animated: true)
    }
    
    fileprivate func push(vc: BaseViewController,_ indexPath: IndexPath) {
        vc.modalPresentationStyle = .fullScreen
        vc.titleText = datas[indexPath.section].1[indexPath.row].detail
        navigationController?.pushViewController(vc, animated: true)
    }
}
