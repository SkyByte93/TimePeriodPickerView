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
    var datas = Array<(String, Array<ListModel>)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "时间周期选择器"
        datas = [("样式",[ListModel(title: "弹窗样式", detail: "PopupStyleViewController"),
                            ListModel(title: "默认样式", detail: "DefaultStyleViewController"),
                            ListModel(title: "XIB适配", detail: "XIBStyleViewController")]),
                 ("格式",[ListModel(title: "年, 月, 日", detail: "DefaultFormatViewController")]),
                 ("自定义",[ListModel(title: "工具栏自定义", detail: "ToolCustomViewController")])
        ]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "123")
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
        case (1, 0): push(vc: DefaultFormatViewController(), indexPath)
        case (_, _): break
        }
    }
    
    fileprivate func pushXIB(vc: BaseViewController,_ indexPath: IndexPath) {
        guard let name = datas[indexPath.section].1[indexPath.row].detail else { return }
        guard let resource = Bundle.main.loadNibNamed(name, owner: nil, options: nil), let xib = resource[0] as? BaseViewController else { return }
        vc.titleText = name
        navigationController?.pushViewController(xib, animated: true)
    }
    
    fileprivate func push(vc: BaseViewController,_ indexPath: IndexPath) {
        vc.modalPresentationStyle = .fullScreen
        vc.titleText = datas[indexPath.section].1[indexPath.row].detail
        navigationController?.pushViewController(vc, animated: true)
    }
}
