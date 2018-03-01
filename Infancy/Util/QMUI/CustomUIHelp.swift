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

