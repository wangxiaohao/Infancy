//
//  App.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/1.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation

struct AppInfo {
    
    static let  _DEBUG = true   //切换开发环境/生产环境
    
    static let document_path: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
    
    static let product_Name  = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
}
