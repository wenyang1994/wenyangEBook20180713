//
//  HJReadView.swift
//  eBookRead
//
//  Created by 文阳 on 2017/5/5.
//  Copyright © 2017年 wen. All rights reserved.
//

import UIKit

class HJReadView: UIView {

    /// 当前文字
    var content:String!
    
    /// 当前视图文字
    var frameRef:CTFrame? {
        
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {
            
            return
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.textMatrix = CGAffineTransform.identity
        ctx?.translateBy(x: 0, y: self.bounds.size.height);
        ctx?.scaleBy(x: 1.0, y: -1.0);
        CTFrameDraw(frameRef!, ctx!);
    }

}
