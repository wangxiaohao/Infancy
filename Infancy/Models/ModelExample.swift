//
//  ModelExample.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/1.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ExampleModel:ModelBase {
    static func initWith<T>(_ json: JSON) -> T {
        let banner = ExampleModel.init(json)
        return banner as! T
    }
    var url : String = ""
    var type : Int   = 0
    var id  : Int = 0
    init() {
        
    }
    init(_ json:JSON) {
        url  = json["url"].stringValue
        type = json["type"].intValue
        id   = json["id"].intValue
    }
    
}
