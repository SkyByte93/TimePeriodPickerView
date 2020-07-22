### TimePeriodPickerView

### 依赖
手动导入[DateTools](https://github.com/MatthewYork/DateTools)
### 功能实现
- [ ] 可以选择年, 月, 日, 时, 分周期.
- [ ] 适配Storyboard, XIB.
- [ ] 动态添加, 修改功能.
- [ ] 去除时间周期中指定的日期.
- [x] 适配DarkMode.
- [x] 自定义工具栏.
- [x] 显示时间正序,倒序.
- [x] 多个时间周期组合显示, 也单个时间周期显示.

### Cocoapods安装
```
pod install ...还未实现
```

### 多个时间周期组装(月, 周, 天).

<img width="276" height="243" src="https://github.com/SkyByte93/TimePeriodPickerView/raw/master/Snap/1.PNG"/><img width="276" height="243" src="https://github.com/SkyByte93/TimePeriodPickerView/raw/master/Snap/2.PNG"/><img width="276" height="243" src="https://github.com/SkyByte93/TimePeriodPickerView/raw/master/Snap/3.PNG"/>

### 单个时间周期(天)

<img width="276" height="243" src="https://github.com/SkyByte93/TimePeriodPickerView/raw/master/Snap/4.PNG"/>


## Init初始化

``` swift
// 配置时间选择器PickerView参数
let pickerConfig = SKPickerConfiguration(start: Date(timeIntervalSince1970: TimeInterval(10000)), end: Date())

// 初始化Period
let picker = SKDatePeriodPickerView(types: [.MONTH, .WEEK, .DAY], pickerConfig: [pickerConfig, pickerConfig, pickerConfig])
picker.delegate = self
UIApplication.shared.keyWindow?.addSubview(picker)
```

## SKDatePeriodDateDelegate 

``` swift 
func SKPeriod(periodView: SKDatePeriodPickerView, timeType: SKPeriodType, start: SKPeriodDate, end: SKPeriodDate) {
    set(time: "\(start.0)年\(start.1)月\(start.2)日~\(end.0)年\(end.1)月\(end.2)日 \n 时间类型:\(timeType)")
}
```

## SKPickerConfiguration

默认实现了周`WeekPickerView`,月`MonthPickerView`,天`DayPickerView`, 继承于`BasePickerView`.

## SKToolViewConfiguration

默认实现了多个时间周期组合的工具视图`SKDatePeriodToolView`和单个时间周期的工具视图`SKSingleDateToolView`, 继承于`SKToolView`.
1. 可以自定义视图并继承于`SKToolView`.

## SKToolViewConfiguation
