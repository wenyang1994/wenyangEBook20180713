//
//  HJManager.swift
//  eBookRead
//
//  Created by 文阳 on 2017/5/5.
//  Copyright © 2017年 wen. All rights reserved.
//

import UIKit

class HJManager: NSObject {

    /// 获取单利对象
    class var shareManager : HJManager {
        struct Static {
            static let instance : HJManager = HJManager()
        }
        return Static.instance
    }
    
    
    /// 当前正在显示的控制器
    weak var displayController:UIViewController?
}
