//
//  Function.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/1.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation


/// DEBUG 调试
///
/// - Parameter iterm: <#iterm description#>
func deprint(_ iterm:@autoclosure ()->Any){
    #if DEBUG
        print(iterm())
    #endif
}


/// 通用闭包传值
typealias block = (Any) -> Void
