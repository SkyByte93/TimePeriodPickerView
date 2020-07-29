//
//  SafeArea.swift
//  CyclePickerView
//
//  Created by jetson on 2020/7/29.
//  Copyright © 2020 jetson. All rights reserved.
//

import UIKit

var leftSafeArea: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0.0
        }else {
            return 0
        }
    }
}

var rightSafeArea: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0.0
        }else {
            return 0
        }
    }
}

var bottomSafeArea: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        }else {
            return 0
        }
    }
}
