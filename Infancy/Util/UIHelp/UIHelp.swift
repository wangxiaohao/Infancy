//
//  QMUIButton.swift
//  anbangke
//
//  Created by 王浩 on 2018/2/3.
//  Copyright © 2018年 Shanghai curtain state network technology Co., Ltd. All rights reserved.
//

import Foundation
import QMUIKit
import ReactiveSwift
import Result
private var xoAssociationKey: UInt8 = 0  //扩展属性需要
struct UIHelp{
       //由extension分类
}

// MARK: - 通用按钮
extension UIHelp {
    
    static func generateDarkFilledButton(_ title:String,_  backcolor:UIColor)->QMUIButton{
        let button = QMUIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.adjustsButtonWhenDisabled = false
        button.layer.cornerRadius = 4
        return button
    }
    
    
    
    static func generateGhostButton(_ title:String,_  color:UIColor)->QMUIGhostButton{
        let button = QMUIGhostButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.ghostColor = color
        button.cornerRadius = 4
        return button
    }
    
}

// MARK: - 颜色字体
extension UIHelp{
    
    
    /// 16进制颜色
    ///
    /// - Parameter str: <#str description#>
    /// - Returns: <#return value description#>
    static func hexColor(_ str:String)->UIColor{
        var str = str
        if !str.contains("#"){
            str = "#" + str
        }
        return UIColor.qmui_color(withHexString: str)!
    }
    static func UIColorMake(_ r:CGFloat,_ g:CGFloat,_ b: CGFloat,_ a:CGFloat?=1)->UIColor{
        let color =  UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a!/1.0)
        return color
    }
    
}
/**扩展属性 绑定事件
 */
//extension QMUIButton{
//    var canAbled : MutableProperty<Bool>?{
//        get {
//            return objc_getAssociatedObject(self, &xoAssociationKey) as? MutableProperty<Bool>
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//}

