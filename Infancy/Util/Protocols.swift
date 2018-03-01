//
//  Protocol.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/1.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import SwiftyJSON

//模型遵从协议 可直接从NetMangerC处解析返回模型
protocol ModelBase {
    static func initWith<T>(_ json:JSON)->T
}
