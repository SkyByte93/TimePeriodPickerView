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

## 可配置参数

### SKPickerConfiguration
主要对显示时间PickerView进行配置.

`selecteDate`: 自动计算并滚动到此日期, 如果不在显示的日期范围中则不会滚动, 为nil时不会进行自动选中操作, 默认为当前日期.

`selecteDateAnimation`: 滚动到`selecteDate`是否有动画, 默认有动画.

`timeLimit`: 显示的时间范围,类型为(Date, Date), 前者开始日期, 后者结束日期, 必初始化.

`selectColor`: PickerVIew中的选中颜色, 默认LightMode: red, DarkMode: red.

`selectFont`: PicerView中的选中字体, 默认LightMode: white, DarkMode: white.

`normalColor`: PickerView中没有选中的颜色, 默认系统字体18.

`normalFont`: PickerView中没有选中的字体样式, 默认系统字体18.

`splitLimitColor`: 在iOS13.0及以下的分割线颜色设置, 默认LightMode: lightGray, DarkMode: lightGray.

`splitLimitHeight`: 在iOS13.0及以下的分割线高度设置, 默认高度1.

`splitLimitHidden`: 在iOS13.0及以下的分割线是否隐藏, 默认不隐藏.

`order`: PickerView显示时间时间顺序参数(enum:`SKPeriodOrder`) , 默认Asc.

```
enum SKPeriodOrder {
    /// 升序
    case Asc
    /// 降序
    case Desc
}
```

### SKToolViewConfiguration
主要对工具View进行配置, 也可自定义ToolView, 请继承自SKToolView.

多个PicekrView组装显示, 适配单个PicekrView参数无效.

`background`:  工具栏背景色, 默认LightMode: white, DarkMode: black.

`isExchangeToolButton`: 是否交换左边、右边按钮.

`leftFrame`:左边按钮Frame.

`leftTitle`:左边按钮文字设置, 默认`取消`.

`leftFont`: 左边按钮字体样式, 默认系统加粗字体16.

`leftColor`: 左边按钮字体颜色, 默认lightMode: lightGray, DarkMode: lightGray.

`rightFrame`: 右边按钮Frame.

`rightTitle`: 右边按钮文字设置, 默认`确定`.

`rightFont`: 右边按钮字体样式, 默认系统加粗字体16.

`rightColor`: 右边按钮字体颜色, 默认lightMode: black, DarkMode: white.

`selectedButtonFont`: 选中按钮字体, 默认系统加粗字体20.

`selectedButtonColor`: 选中按钮颜色, 默认lightMode: black, DarkMode: white.

`normalButtonFont`: 常用按钮字体, 默认系统字体16.

`normalButtonColor`: 常用按钮颜色, 默认lightMode: lightGray, DarkMode: lightGray.

单个PicekrView显示, 适配多个PickerView参数无效.

`isShowSelecteTime`: 是否显示选中的时间周期, 默认显示.

`selecteTimeFont`: 显示时间周期文字的字体大小, 默认系统字体18.

`selecteTimeColor`: 显示时间周期文字的颜色, 默认lightMode: darkGray, DarkMode: darkGray.

`selecteTimeFormat`: 显示时间周期格式, 默认`yyyy-MM-dd`.

`startingTimeAndEndingTime`: 显示时间周期中间分隔, 默认`~`.

### SKDatePeriodPickerView

主要对整个时间周期选择器进行配置.

`backgroundFrame`: 遮罩层尺寸, 主要默认是使用在底部弹窗模式中, 默认全屏尺寸, 覆盖安全区域.

`mainFrame`: 显示PickerView尺寸, 包括ToolView尺寸, 默认高度:400, 宽度:屏幕宽度.

`mainBackground`: 显示PickerView颜色, 默认lightMode: white, DarkMode: black.

`shadeBackground`: 遮罩层颜色, 默认颜色`red: 0, green: 0, blue: 0, alpha: 0.3`.

`selectedIndex`: 在多个pickerView组装显示时, 最初显示PickerView的位置, 默认为第一个.

`autoLocationDate`: 是否自动定位到上次选中的时间位置, 按`确认`按钮有效.

`scrollSwitchAnimation`: pickerView左右切换是否有动画, 默认有.

`isAdaptiveDrakMode`: 是否适配暗黑模式, 默认适配.

`periodStartTime`: 周期时间周期开始时间, 可以在多个PickerView需要显示的时候统一配置, 此配置后`timeLimit`配置将无效.

`periodEndTime`: 显示时间周期结束时间, 可以在多个PickerView需要显示的时候统一配置, 此配置后`timeLimit`配置将无效.

`customerToolView`: 如果自定工具栏, 请赋值给此.

