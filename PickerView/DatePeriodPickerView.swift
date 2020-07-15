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

/// (Int, Int, Int) (年，月，日)
typealias PeriodDate = (Int, Int, Int)

typealias DatePeriodConfirmBlock = ((_ type: CycleType,_ startTime: PeriodDate, _ endTime: PeriodDate)->())

class DatePeriodPickerView: UIView {
    ///
    public weak var delegate: DatePeriodDataDelegate?
    
    public var backgroundFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) {
        willSet { frame = newValue }
    }
    
    public var mainFrame: CGRect = CGRect(x: 0, y: kScreenH - 400, width: kScreenW, height: 400) {
        willSet { mainView.frame = newValue }
    }
    
    public var mainBackground: UIColor = .color(default: .white, darkMode: .black) {
        willSet { mainView.backgroundColor = newValue }
    }
    /// 遮罩层背景色
    public var shadeBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3) {
        willSet { backgroundColor = newValue }
    }
    /// 选中的Index
    public var selectedIndex: Int = 0 {
        willSet {
            scroll.contentOffset = CGPoint(x: Int(kScreenW) * newValue, y: 0)
            toolView.selectedIndex = newValue
        }
    }
    /// 是否定位到上次选中时间的位置
    public var autoLocationDate: Bool = false {
        willSet {}
    }
    /// 选择器左右切换动画, 默认有.
    public var scrollSwitchAnimation: Bool = true
    /// 是否适配暗黑模式, 默认是
    public var isAdaptiveDrakMode: Bool = true
    
    /// 当前选中的时间, 用于缓存
    private(set) var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int))? = nil
    ///
    private(set) var toolView: DatePeriodToolView!
    ///
    private var pickerArr = Array<PickerViewModel>()
    ///
    private var currentType: CycleType? = nil
    
    fileprivate lazy var mainView: UIView = {
        let view = UIView(frame: mainFrame)
        view.backgroundColor = mainBackground
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
        view.backgroundColor = mainBackground
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var gesture: UIGestureRecognizer = {
        let gesture = UIGestureRecognizer(target: self, action: #selector(hidenView))
        return gesture
    }()
    
    init(types: Array<CycleType>, frame: CGRect? = nil, configuration toolConfigration: ToolViewConfiguration? = nil, configuration pickerConfiguration: Array<PickerConfig>? = nil) {
        guard let frame = (frame == nil ? backgroundFrame : frame) else { super.init(frame: .zero); return }
        super.init(frame: frame)
        
        backgroundColor = shadeBackground
        toolView = toolView(types: types, config: toolConfigration)
        #warning("点击手势出现问题, 响应链出现问题, 后期优化")
//        addGestureRecognizer(gesture)
        
        addSubview(mainView)
        mainView.addSubview(toolView)
        mainView.addSubview(scroll)
        
        ///
        makePickerView(types: types, pickerArr: &pickerArr, config: pickerConfiguration)
        pickerViewAddMainView()
    }
    
    ///
    func makePickerView(types: Array<CycleType>, pickerArr: inout Array<PickerViewModel>, config: Array<PickerConfig>?) {
        
        scroll.contentSize = CGSize(width: kScreenW * CGFloat(types.count), height: scroll.bounds.height)
        scroll.contentOffset = CGPoint(x: Int(kScreenW) * selectedIndex, y: 0)
        
        for (index, item) in types.enumerated() {
            let frame = CGRect(x: kScreenW * CGFloat(index), y: 0, width: scroll.bounds.width, height: scroll.bounds.height)
            let config = config == nil ? nil : config![index]
            switch item {
            case .DAY:
                pickerArr.append(PickerViewModel(type: .DAY, picker: dayPickerView(frame: frame)))
            case .WEEK:
                pickerArr.append(PickerViewModel(type: .WEEK, picker: weekPickerView(frame: frame, config: config)))
            case .MONTH:
                pickerArr.append(PickerViewModel(type: .MONTH, picker: monthPickerView(frame: frame, config: config)))
            case .Minute: break
            case .Hour: break
            }
        }
    }
    
    func dayPickerView(frame: CGRect) -> DayPickerView {
        let pickerView = DayPickerView.init(frame: frame)
        return pickerView
    }
    
    func weekPickerView(frame: CGRect, config: PickerConfig?) -> WeekPickerView {
        let pickerView = WeekPickerView(frame: frame, config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    func monthPickerView(frame: CGRect, config: PickerConfig?) -> MonthPickerView {
        let pickerView = MonthPickerView(frame: frame, config: config)
        pickerView.periodDelegate = self
        return pickerView
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
            scroll.addSubview(item.pickerView)
        }
    }
    
    ///
    func toolView(types: Array<CycleType>, config: ToolViewConfiguration?) -> DatePeriodToolView {
        let tool = DatePeriodToolView(types: types, config: config ?? ToolViewConfiguration())
        tool.delegate = self
        tool.selectedIndex = selectedIndex
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
            self.backgroundColor = self.shadeBackground
        }
    }
    
    /// 隐藏动画
    func animationedHiden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 400)
            self.backgroundColor = .clear
        }) { (bool) in
            #warning("在lazy加载一次后, 再次添加到view上, 由于DatePeriodPickerView被删除, 不能进行添加, 后期优化")
            self.removeFromSuperview()
        }
    }
    
    func changeCurrentTime(index: Int) {
        guard index >= 0 && index < pickerArr.count  else { return }
        let model = pickerArr[index]
        if model.type == .DAY, let _ = model.pickerView as? DayPickerView {
        }else if model.type == .WEEK, let picker = model.pickerView as? WeekPickerView {
            currentPeriodDate = picker.currentPeriodDate
        }else if model.type == .MONTH, let picker = model.pickerView as? MonthPickerView {
            currentPeriodDate = picker.currentPeriodDate
        }
        if let delegate = delegate, let date = currentPeriodDate {
            delegate.SKPeriod(periodView: self, timeType: model.type, start: date.0, end: date.1)
        }
    }
    
}
extension DatePeriodPickerView: DatePeriodPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, type: CycleType, start: PeriodDate, end: PeriodDate) {
//        print("type:\(type), date:\(start.0)Y\(start.1)M\(start.2)th~\(end.0)Y\(end.1)M\(end.2)th")
        currentPeriodDate = (start, end)
        if let delegate = delegate {
            delegate.SKPeriod(periodView: self, timeType: type, start: start, end: end)
        }
    }
}
extension DatePeriodPickerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x / scroll.bounds.width)
        let intIndex = round(index)
        
        toolView.animationChnage(index: Int(intIndex))
        changeCurrentTime(index: Int(intIndex))
    }
    
}

extension DatePeriodPickerView: ToolProtocol {
    func tool(left leftBtn: UIButton?, right rightBtn: UIButton?) {
        if leftBtn != nil {
            if let delegate = delegate, let date = currentPeriodDate {
                delegate.SKPeriodLeftButton(periodView: self, timeType: .MONTH, start: date.0, end: date.1)
            }
        } else if rightBtn != nil {
            if let delegate = delegate, let date = currentPeriodDate {
                delegate.SKPeriodRightButton(periodView: self, timeType: .MONTH, start: date.0, end: date.1)
            }
        }
        animationedHiden()
    }
    
    func tool(selected type: CycleType, selected index: Int) {
//        print("current index:\(index), type:\(type)")
        if scrollSwitchAnimation {
            UIView.animate(withDuration: 0.3) { self.scrollOffSet(index) }
        }else {
            scrollOffSet(index)
        }
    }
    func scrollOffSet(_ index: Int) {
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
