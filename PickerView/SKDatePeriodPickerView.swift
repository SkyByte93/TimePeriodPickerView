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

/// (Int, Int, Int) (年，月，日)
typealias SKPeriodDate = (Int, Int, Int)

typealias DatePeriodConfirmBlock = ((_ type: SKPeriodType,_ startTime: SKPeriodDate, _ endTime: SKPeriodDate)->())

class SKDatePeriodPickerView: UIView {
    
    /// 代理
    public weak var delegate: SKDatePeriodDateDelegate?
    
    /// 尺寸
    public var backgroundFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) {
        willSet { frame = newValue }
    }
    
    /// 主要页面尺寸
    public var mainFrame: CGRect = CGRect(x: 0, y: kScreenH - 400, width: kScreenW, height: 400) {
        willSet { mainView.frame = newValue }
    }
    
    ///
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
            if let tool = toolView as? SKDatePeriodToolView {
                tool.selectedIndex = newValue
            }
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
    /// 周期开始时间
    public var periodStartTime: Date?
    /// 周期结束时间
    public var periodEndTime: Date?
    /// 自定义工具栏
    public var customerToolView: SKToolView?
    /// 当前选中的时间, 用于缓存
    private(set) var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int))? = nil {
        didSet {
            if let startTime = currentPeriodDate?.0, let endTime = currentPeriodDate?.1 {
                if let block = toolView.selectedBlock { block(SKPeriodType.DAY, 0, startTime, endTime) }
            }
        }
    }
    ///
    private(set) var toolView: SKToolView!
    ///
    private var pickerArr = Array<PickerViewModel>()
    ///
    fileprivate lazy var mainView: UIView = {
        let view = UIView(frame: mainFrame)
        view.backgroundColor = mainBackground
        return view
    }()
    ///
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
    ///
    fileprivate lazy var gesture: UIGestureRecognizer = {
        let gesture = UIGestureRecognizer(target: self, action: #selector(hidenView))
        return gesture
    }()
    ///
    public init(types: Array<SKPeriodType>,
                frame: CGRect? = nil,
                toolConfig toolConfigration: SKToolViewConfiguration? = nil,
                pickerConfig pickerConfiguration: Array<SKPickerConfiguration>? = nil) {
        
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
    func makePickerView(types: Array<SKPeriodType>, pickerArr: inout Array<PickerViewModel>, config: Array<SKPickerConfiguration>?) {
        scroll.contentSize = CGSize(width: kScreenW * CGFloat(types.count), height: scroll.bounds.height)
        scroll.contentOffset = CGPoint(x: Int(kScreenW) * selectedIndex, y: 0)
        
        for (index, item) in types.enumerated() {
            let frame = CGRect(x: kScreenW * CGFloat(index), y: 0, width: scroll.bounds.width, height: scroll.bounds.height)
            let config = config == nil ? nil : config![index]
            let isSelecte = selectedIndex == index
            switch item {
            case .DAY:
                pickerArr.append(PickerViewModel(type: .DAY, picker: dayPickerView(frame: frame, config: config), isSelected: isSelecte))
            case .WEEK:
                pickerArr.append(PickerViewModel(type: .WEEK, picker: weekPickerView(frame: frame, config: config),isSelected: isSelecte))
            case .MONTH:
                pickerArr.append(PickerViewModel(type: .MONTH, picker: monthPickerView(frame: frame, config: config), isSelected: isSelecte))
            case .MINUTE:
                break
            case .HOUR:
                break
            case .SECOND:
                break
            }
        }
    }
    
    ///
    func dayPickerView(frame: CGRect, config: SKPickerConfiguration?) -> DayPickerView {
        let pickerView = DayPickerView.init(frame: frame, config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func weekPickerView(frame: CGRect, config: SKPickerConfiguration?) -> WeekPickerView {
        let pickerView = WeekPickerView(frame: frame, config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func monthPickerView(frame: CGRect, config: SKPickerConfiguration?) -> MonthPickerView {
        let pickerView = MonthPickerView(frame: frame, config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func pickerViewAddMainView() {
        for item in pickerArr {
            scroll.addSubview(item.pickerView)
        }
    }
    
    ///
    func toolView(types: Array<SKPeriodType>, config: SKToolViewConfiguration?) -> SKToolView {
        if let customer = customerToolView {
            return customer
        }else {
            if types.count == 1 {
                let tool = SKSingleDateToolView(config: config ?? SKToolViewConfiguration())
                tool.delegate = self
                return tool
            }else {
                let tool = SKDatePeriodToolView(types: types, config: config ?? SKToolViewConfiguration())
                tool.delegate = self
                tool.selectedIndex = selectedIndex
                return tool
            }
        }
    }
    
    ///
    @objc func hidenView() {
        animationedHiden()
    }
    
    ///
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    override func layoutSubviews() {
        super.layoutSubviews()
        animationedShow()
    }
    
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        animationedShow()
    }
    
    ///
    func animationedShow() {
        mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 400)
        backgroundColor = .clear
        isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.mainView.frame = self.mainFrame
            self.backgroundColor = self.shadeBackground
        }
    }
    
    ///
    func animationedHiden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 400)
            self.backgroundColor = .clear
        }) { (bool) in
            #warning("在lazy加载一次后, 再次添加到view上, 由于DatePeriodPickerView被删除, 不能进行添加, 后期优化")
            self.pickerArr.removeAll()
            self.removeFromSuperview()
        }
    }
    
}

extension SKDatePeriodPickerView:UIScrollViewDelegate, SKToolViewProtocol, SKDatePeriodPickerViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x / scroll.bounds.width)
        let intIndex = round(index)
        
        if let tool = toolView as? SKDatePeriodToolView {
            tool.animationChnage(index: Int(intIndex))
        }
        changeCurrentTime(index: Int(intIndex))
    }
    
    ///
    fileprivate func changeCurrentTime(index: Int) {
        guard index >= 0 && index < pickerArr.count  else { return }
        let model = pickerArr[index]
        if let picker = model.pickerView as? BasePickerView {
            let start: (Int, Int, Int) = (picker.currentPeriod.0.year, picker.currentPeriod.0.month, picker.currentPeriod.0.day)
            let end: (Int, Int, Int) = (picker.currentPeriod.1.year, picker.currentPeriod.1.month, picker.currentPeriod.1.day)
            currentPeriodDate = (start, end)
        }
        
        if let delegate = delegate, let date = currentPeriodDate {
            delegate.SKPeriod(periodView: self, timeType: model.type, start: date.0, end: date.1)
        }
    }
    
    func pickerView(pickerView: UIPickerView, type: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
        guard pickerArr.count > selectedIndex else { return }
        if pickerArr.count == 1 || pickerView == pickerArr[selectedIndex].pickerView {
            currentPeriodDate = (start, end)
            if let delegate = delegate {
                delegate.SKPeriod(periodView: self, timeType: type, start: start, end: end)
            }
        }
    }
    
    func hidenTimePeriod() {
        animationedHiden()
    }
    
    func selectePickerView(selected type: SKPeriodType, selected index: Int) {
        if scrollSwitchAnimation {
            UIView.animate(withDuration: 0.3) { self.scrollOffSet(index) }
        }else {
            scrollOffSet(index)
        }
    }
    
    ///
    fileprivate func scrollOffSet(_ index: Int) {
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
