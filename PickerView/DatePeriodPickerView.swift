//
//  DatePeriodPickerView.swift
//  skyCare
//
//  Created by jetson on 2019/10/15.
//  Copyright © 2019 jetson. All rights reserved.

@available(iOS 11.0, *)
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

import UIKit
import DateToolsSwift

enum CycleType {
    
    case DAY
    
    case WEEK
    
    case MONTH
}

class PickerViewModel {
    var pickerView: UIPickerView!
    init(picker: UIPickerView) {
        pickerView = picker
    }
}

/// (Int, Int, Int) (年，月，日)
typealias PeriodDate = (Int, Int, Int)

typealias DatePeriodConfirmBlock = ((_ type: CycleType,_ startTime: PeriodDate, _ endTime: PeriodDate)->())

class DatePeriodPickerView: UIView {
    ///
    public weak var toolDelegate: DatePeriodToolDelegate?
    ///
    public weak var delegate: DatePeriodDataDelegate?
    
    public var backgroundFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) {
        willSet { frame = newValue }
    }
    
    public var mainFrame: CGRect = CGRect(x: 0, y: kScreenH - 400, width: kScreenW, height: 400) {
        willSet { mainView.frame = newValue }
    }
    
    /// 整体背景色
    public var mainBackground: UIColor = UIColor(hex: "000000", alpha: 0.3) {
        willSet { backgroundColor = newValue }
    }
    
    /// 工具栏背景色
    public var toolViewBackground: UIColor = .white {
        willSet { toolView.backgroundColor = newValue }
    }
    
    /// 选中的PickerView
    var selectedIndex: Int = 0 {
        willSet {
            scroll.contentOffset = CGPoint(x: Int(kScreenW) * selectedIndex, y: 0)
            toolView.selectedIndex = newValue
        }
    }
    
    fileprivate var toolView: DatePeriodToolView!
    
    private(set) var pickerArr = Array<UIPickerView>()
    private(set) var type: CycleType = .WEEK
    
    fileprivate lazy var mainView: UIView = {
        let view = UIView(frame: mainFrame)
        view.backgroundColor = .lightGray
        return view
    }()
    
    fileprivate lazy var scroll: UIScrollView = {
        var height: CGFloat = 0
        if #available(iOS 11.0, *) {
            height = mainView.bounds.height - toolView.bounds.height - bottomSafeAreaHeight
        }else {
            height = mainView.bounds.height - toolView.bounds.height
        }
        let view = UIScrollView(frame: CGRect(x: 0, y: toolView.bounds.height, width: kScreenW, height: height))
        view.isPagingEnabled = true
        view.bounces = false
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var gesture: UIGestureRecognizer = {
        let gesture = UIGestureRecognizer(target: self, action: #selector(hidenView))
        return gesture
    }()
    
    init(types: Array<CycleType>, frame: CGRect? = nil) {
        guard let frame = (frame == nil ? backgroundFrame : frame) else { super.init(frame: .zero); return }
        super.init(frame: frame)
        
        backgroundColor = mainBackground
        toolView = toolView(types: types)
        #warning("点击手势出现问题, 响应链出现问题, 后期优化")
//        addGestureRecognizer(gesture)
        
        addSubview(mainView)
        mainView.addSubview(toolView)
        mainView.addSubview(scroll)
        
        ///
        makePickerView(types: types, pickerArr: &pickerArr)
        pickerViewAddMainView()
    }
    
    ///
    func makePickerView(types: Array<CycleType>, pickerArr: inout Array<UIPickerView>) {
        scroll.contentSize = CGSize(width: kScreenW * CGFloat(types.count), height: scroll.bounds.height)
        scroll.contentOffset = CGPoint(x: Int(kScreenW) * selectedIndex, y: 0)
        for (index, item) in types.enumerated() {
            let picker = UIPickerView()
            picker.frame = CGRect(x: kScreenW * CGFloat(index), y: 0, width: scroll.bounds.width, height: scroll.bounds.height)
            switch item {
            case .DAY: picker.backgroundColor = .red
            case .WEEK: picker.backgroundColor = .yellow
            case .MONTH: picker.backgroundColor = .cyan
            }
            pickerArr.append(picker)
        }
    }
    
    ///
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        guard isUserInteractionEnabled || !isHidden || !(alpha <= 0.01) else { return nil }
//        /// 遍历图层
//        for subview in subviews.reversed() {
//            let convertedPoint = subview.convert(point, from: self)
//            let hitTestView = subview.hitTest(convertedPoint, with: event)
//            if hitTestView is UIButton {
//                return toolView
//            }else {
//                return hitTestView
//            }
//        }
//        return nil
//    }
    
    ///
    func pickerViewAddMainView() {
        for item in pickerArr {
            self.scroll.addSubview(item)
        }
    }
    
    ///
    func toolView(types: Array<CycleType>) -> DatePeriodToolView {
        let tool = DatePeriodToolView(types: types)
        tool.delegate = self
        tool.selectedIndex = selectedIndex
        tool.backgroundColor = toolViewBackground
        return tool
    }
    
    ///
    @objc func hidenView() {
        animationedHiden()
    }
    
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationedShow()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationedShow()
    }
    
    /// 显示动画
    func animationedShow() {
        mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 400)
        backgroundColor = .clear
        isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.mainView.frame = self.mainFrame
            self.backgroundColor = self.mainBackground
        }
    }
    
    /// 隐藏动画
    func animationedHiden() {
        UIView.animate(withDuration: 0.3) {
            self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 400)
            self.backgroundColor = .clear
        } completion: { (bool) in
            #warning("在lazy加载一次后, 再次添加到view上, 由于DatePeriodPickerView被删除, 不能进行添加")
            self.removeFromSuperview()
        }

    }
}

extension DatePeriodPickerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scroll.bounds.width
        
        let index = ((scrollOffsetX) / scrollViewWidth)
        let remainder = index.truncatingRemainder(dividingBy: 1.0)
        let intIndex = round(index)
        print("当前ScrollView Index:\(intIndex), Index: \(remainder)")
        toolView.animationChnage(index: Int(intIndex))
    }
    
}

extension DatePeriodPickerView: ToolProtocol {
    func tool(left leftBtn: UIButton?, right rightBtn: UIButton?) {
        if let leftB = leftBtn {
            print(leftB.titleLabel?.text ?? "左边")
        } else if let rightB = rightBtn {
            print(rightB.titleLabel?.text ?? "右边")
        }
        animationedHiden()
    }
    
    func tool(selected type: CycleType, selected index: Int) {
        print("当前选中\(index), 类型是\(type)")
        scroll.contentOffset = CGPoint(x: Int(scroll.bounds.width) * index, y: 0)
    }
}

extension Int {
    /// 仅限用于日期
    func ddToDD() -> String {
        if self < 10 { return "0\(self)" }
        return "\(self)"
    }
}
