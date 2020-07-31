//
//  DatePeriodPickerView.swift
//  skyCare
//
//  Created by jetson on 2019/10/15.
//  Copyright © 2019 jetson. All rights reserved.

import UIKit
/// (Int, Int, Int) (年，月，日)
typealias SKPeriodDate = (Int, Int, Int)

typealias DatePeriodConfirmBlock = ((_ type: SKPeriodType,_ startTime: SKPeriodDate, _ endTime: SKPeriodDate)->())

class SKDatePeriodPickerView: UIView {
    
    /// 代理
    public weak var delegate: SKDatePeriodDateDelegate?
    
    /// 尺寸
    public var shadeFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) {
        willSet { frame = newValue }
    }
    
    /// 主要页面高度
    public var mainViewHeight: CGFloat = 40 + bottomSafeArea + 216 {
        willSet {
            mainViewHeightConstraint.constant = newValue
        }
    }
    
    /// 主要页面颜色
    public var mainBackground: UIColor = .color(light: .white, dark: .black) {
        willSet { mainView.backgroundColor = newValue }
    }
    
    /// 遮罩层背景色
    public var shadeBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3) {
        willSet { backgroundColor = newValue }
    }
    
    /// 选中的Index
    public var selectedIndex: Int = 0 {
        willSet {
            scroll.contentOffset = CGPoint(x: Int(bounds.width) * newValue, y: 0)
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
    /// 显示模式
    public var showMode: SKPickerMode = .popup
    ///pickerView数组
    public var periodArrTypes: Array<SKPeriodType>!
    ///toolView配置信息
    public var toolViewConfigration: SKToolViewConfiguration!
    /// pickerView配置信息
    public var pickerArrConfiguration: Array<SKPickerConfiguration>!
    /// 当前选中的时间, 用于缓存
    private(set) var currentPeriodDate: ((Int, Int, Int),(Int, Int, Int))? = nil {
        didSet {
            if let startTime = currentPeriodDate?.0, let endTime = currentPeriodDate?.1 {
                if let block = toolView.selectedBlock { block(SKPeriodType.DAY, 0, startTime, endTime) }
            }
        }
    }
    ///
    private var mainViewBottomConstraint: NSLayoutConstraint!
    
    private var mainViewHeightConstraint: NSLayoutConstraint!
    ///
    private(set) var toolView: SKToolView!
    ///
    private var pickerArr = Array<PickerViewModel>()
    ///
    fileprivate lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = mainBackground
        return view
    }()
    ///
    fileprivate lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.backgroundColor = mainBackground
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    
    ///
    public init(types: Array<SKPeriodType>,
                frame: CGRect? = nil,
                mode: SKPickerMode = .popup,
                toolConfig toolConfigration: SKToolViewConfiguration? = nil,
                pickerConfig pickerConfiguration: Array<SKPickerConfiguration>? = nil) {
        guard let frame = (frame == nil ? shadeFrame : frame) else { super.init(frame: .zero);return }
        super.init(frame: frame)
        
        toolView = toolView(types: types, config: toolConfigration)
        
        periodArrTypes = types
        toolViewConfigration = toolConfigration ?? SKToolViewConfiguration()
        pickerArrConfiguration = makeConfiguration(types: periodArrTypes)
        
        backgroundColor = shadeBackground
        isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissEvent)))
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noEvent)))
    }
    
    @objc func onDeviceOrientationDidChange() {
        switch UIDevice.current.orientation {
        case .portrait:
            scroll.contentSize = CGSize(width: scroll.bounds.width * CGFloat(pickerArr.count), height: 216)
//            for (index, item) in pickerArr.enumerated() where item.isSelected {
//                scroll.contentOffset = CGPoint(x: Int(bounds.width) * index, y: 0)
//            }
            mainViewHeight = 40 + bottomSafeArea + 216
        case .landscapeLeft, .landscapeRight:
            scroll.contentSize = CGSize(width: scroll.bounds.width * CGFloat(pickerArr.count), height: 162)
//            for (index, item) in pickerArr.enumerated() where item.isSelected {
//                scroll.contentOffset = CGPoint(x: Int(bounds.width) * index, y: 0)
//            }
            mainViewHeight = 40 + bottomSafeArea + 162
        default: break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getMainViewDefaultHeight() -> CGFloat {
        switch UIDevice.current.orientation {
        case .portrait:
            return 40 + bottomSafeArea + 216
        case .landscapeLeft, .landscapeRight:
            return 40 + bottomSafeArea + 162
        default:
            return 40 + bottomSafeArea + 216
        }
    }
    
    func makeConfiguration(types: Array<SKPeriodType>) -> Array<SKPickerConfiguration> {
        var arr = Array<SKPickerConfiguration>()
        for item in types {
            switch item {
            case .DAY: arr.append(SKPickerConfiguration(type: .DAY))
            case .MONTH: arr.append(SKPickerConfiguration(type: .MONTH))
            case .WEEK: arr.append(SKPickerConfiguration(type: .WEEK))
            }
        }
        return arr
    }
    
    func mainViewAddConstrains() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainViewBottomConstraint = NSLayoutConstraint(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        mainViewHeightConstraint = NSLayoutConstraint(item: mainView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: getMainViewDefaultHeight())
        addConstraints([NSLayoutConstraint(item: mainView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint(item: mainView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0),
                        mainViewHeightConstraint, mainViewBottomConstraint])
    }
    
    func toolViewAddConstrains() {
        toolView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addConstraints([NSLayoutConstraint(item: toolView!, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: toolView!, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: toolView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40),
                                 NSLayoutConstraint(item: toolView!, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0)])
    }
    
    func scrollToMainViewAddConstrains() {
        scroll.translatesAutoresizingMaskIntoConstraints = false
        mainView.addConstraints([NSLayoutConstraint(item: scroll, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .top, relatedBy: .equal, toItem: toolView, attribute: .bottom, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)])
    }
    func scrollAddConstrains() {
        scroll.translatesAutoresizingMaskIntoConstraints = false
        mainView.addConstraints([NSLayoutConstraint(item: scroll, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                                 NSLayoutConstraint(item: scroll, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)])
    }
    
    @objc func dismissEvent() {
        animationedHiden()
    }
    
    @objc func noEvent() {}
    ///
    func makePickerView(types: Array<SKPeriodType>, config: Array<SKPickerConfiguration>?) {
        scroll.contentSize = CGSize(width: bounds.width * CGFloat(types.count), height: 216)
        scroll.contentOffset = CGPoint(x: Int(bounds.width) * selectedIndex, y: 0)
        
        for (index, item) in types.enumerated() {
            let config = config == nil ? nil : config![index]
            let isSelecte = selectedIndex == index
            switch item {
            case .DAY:
                pickerArr.append(PickerViewModel(type: .DAY, picker: dayPickerView(config: config), isSelected: isSelecte))
            case .WEEK:
                pickerArr.append(PickerViewModel(type: .WEEK, picker: weekPickerView(config: config),isSelected: isSelecte))
            case .MONTH:
                pickerArr.append(PickerViewModel(type: .MONTH, picker: monthPickerView(config: config), isSelected: isSelecte))
            }
        }
    }
    
    ///
    func dayPickerView(config: SKPickerConfiguration?) -> DayPickerView {
        let pickerView = DayPickerView(config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func weekPickerView(config: SKPickerConfiguration?) -> WeekPickerView {
        let pickerView = WeekPickerView(config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func monthPickerView(config: SKPickerConfiguration?) -> MonthPickerView {
        let pickerView = MonthPickerView(config: config)
        pickerView.periodDelegate = self
        return pickerView
    }
    
    ///
    func pickerViewAddScroll() {
        for (index, item) in pickerArr.enumerated() {
            scroll.addSubview(item.pickerView)
            let lastPickerView: UIPickerView? = index >= 1 ? pickerArr[index - 1].pickerView : nil
            pickerViewAddConstraints(lastPickerView: lastPickerView, pickerView: item.pickerView)
        }
    }
    
    func pickerViewAddConstraints(lastPickerView: UIPickerView?, pickerView: UIPickerView) {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        scroll.addConstraints([NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: scroll, attribute: .top, multiplier: 1.0, constant: 0),
                               NSLayoutConstraint(item: pickerView, attribute: .width, relatedBy: .equal, toItem: scroll, attribute: .width, multiplier: 1.0, constant: 0)])
        if let last = lastPickerView {
            scroll.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .left, relatedBy: .equal, toItem: last, attribute: .right, multiplier: 1.0, constant: 0))
        }else {
            scroll.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .left, relatedBy: .equal, toItem: scroll, attribute: .left, multiplier: 1.0, constant: 0))
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
    
    /// xib or stoaryboard load
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///
    override func layoutSubviews() {
        super.layoutSubviews()
        addView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addView()
    }
    
    
    func addView() {
        
        if pickerArrConfiguration.count > 0 {
            makePickerView(types: periodArrTypes, config: makeConfiguration(types: periodArrTypes))
        }else {
            makePickerView(types: periodArrTypes, config: pickerArrConfiguration)
        }
        
        
        if showMode == .customer {
            addSubview(scroll)
            scrollAddConstrains()
        }else {
            addSubview(mainView)
            mainViewAddConstrains()
            
            mainView.addSubview(toolView)
            toolViewAddConstrains()
            
            mainView.addSubview(scroll)
            scrollToMainViewAddConstrains()
        }
        
        pickerViewAddScroll()
    }
    
    ///
    func animationedShow() {
        mainViewBottomConstraint.constant = -mainViewHeight
        backgroundColor = .clear
        isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.mainViewBottomConstraint.constant = 0
            self.backgroundColor = self.shadeBackground
        }
    }
    
    ///
    func animationedHiden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.mainViewBottomConstraint.constant = -self.mainViewHeight
            self.backgroundColor = .clear
        }) { (bool) in
            #warning("在lazy加载一次后, 再次添加到view上, 由于DatePeriodPickerView被删除, 不能进行添加, 后期优化")
            self.pickerArr.removeAll()
            self.removeFromSuperview()
        }
    }
    
}

extension SKDatePeriodPickerView:UIScrollViewDelegate, SKToolViewProtocol, SKDatePeriodPickerViewDelegate {
    
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = (scrollView.contentOffset.x / scroll.bounds.width)
        let intIndex = index.isNaN ? 0 : round(index)
        if let tool = toolView as? SKDatePeriodToolView {
            tool.animationChnage(index: Int(intIndex))
        }
        changeCurrentTime(index: Int(intIndex))
    }
    
    ///
    fileprivate func changeCurrentTime(index: Int) {
        guard index >= 0 && index < pickerArr.count else { return }
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
    
    ///
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
