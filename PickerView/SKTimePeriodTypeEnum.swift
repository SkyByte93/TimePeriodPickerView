//
//  SKTimePeriodTypeEnum.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/14.
//  Copyright © 2020 jetson. All rights reserved.
//

import Foundation

enum SKPeriodType {
    /// 秒
    case SECOND
    /// 分钟
    case MINUTE
    /// 小时
    case HOUR
    /// 天
    case DAY
    /// 周
    case WEEK
    /// 月
    case MONTH
}

enum SKPeriodOrder {
    /// 升序
    case Asc
    /// 降序
    case Desc
}

/// 显示模式
enum SKShowMode {
    /// 后缀
    case suffix
    /// 固定
    case fixed
}

enum YearMode {
    ///
    case yyyy
    ///
    case yy
    ///
    case YYYY
}

enum DayMode {
    ///
    case dd
    ///
    case DD
    ///
    case d
}

enum MonthMode {
    ///
    case MM
    ///
    case mm
    ///
    case m
}
