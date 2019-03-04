//
//  ModelExample.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/1.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import SwiftyJSON
import YYModel


@objc class BaseModel:NSObject,YYModel,NSCoding{
    @objc var d_id:Int = 0
    override init() {
        super.init()
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["d_id":"id"]
    }
}
