//
//  CacheManger.swift
//  anbangke
//
//  Created by 王浩 on 2017/11/23.
//  Copyright © 2017年 Shanghai curtain state network technology Co., Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

/**
 * 缓存管理  图片文件等
 * 1.图片缓存分为：Kingfisher缓存 和 DATA写入
 * 2.从bundle获取数据
 */
struct CacheManger {
   
    /// 保存一组图片到磁盘 以时间戳命名 返回图片路径
    ///
    /// - Parameter images: <#images description#>
    /// - Returns: <#return value description#>
    static func  saveImageTodisk(images:[UIImage])->[URL]{
        let libraryDirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let date =  Date()
        var pathArray : [URL] = []
        for (i,sub) in images.enumerated(){
            let  data  = UIImageJPEGRepresentation(sub, 0.5)
            let imageName = "/\(Int(date.timeIntervalSince1970))index\(i)"
            let filePath = libraryDirPath! + "\(imageName).jpeg"
            let fileUrl = URL.init(fileURLWithPath: filePath)
            do {
                try data?.write(to: fileUrl, options:.atomicWrite)
            } catch {
                deprint("存储失败")
            }
            pathArray.append(fileUrl)
        }
        return pathArray
    }
    
    /// KingFisher存储
    ///
    /// - Parameters:
    ///   - img: <#img description#>
    ///   - fileName: <#fileName description#>
    static func saveImageWithKingFisher(_ img:UIImage,fileName:String){
        DispatchQueue.global().async {
            ImageCache.default.store(img, forKey: fileName)
        }
    }
    /// 删除图片
    ///
    /// - Parameter path: <#path description#>
    static func removeCaheImage(_ path:String){
        DispatchQueue.global().async {
            if !path.contains("/Doucument/"){
                ImageCache.default.removeImage(forKey: path)
            }
            else {
                let manger = FileManager()
                try? manger.removeItem(atPath: path)
            }
        }
    }
   /// 获取图片
   ///
   /// - Parameter path: <#path description#>
   /// - Returns: <#return value description#>
   static func getImageFromPath(path:String)->UIImage?{
        deprint(path)
    if path.contains("/Document/"){
        if let savedImage = UIImage.init(contentsOfFile: path)
        {
            return savedImage
        } else {
            deprint("文件不存在")
        }
        return nil
    }
    else{
        if let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
            return image
        }
        if  let image = ImageCache.default.retrieveImageInDiskCache(forKey: path)  {
            ImageCache.default.store(image, original: nil, forKey: path, processorIdentifier: "", cacheSerializer: DefaultCacheSerializer.default, toDisk: false, completionHandler: nil)
            return image
        }
        return nil
       
    }
    
    
    }
    
    /// 从Bundle获取json文件数据
    ///
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - type: <#type description#>
    /// - Returns: <#return value description#>
    /*
    static func getDataFromeBundle(_ name:String,_ type:String)->JSON{
        do {
            let path = Bundle.main.path(forResource: name, ofType: type)
            let url = URL(fileURLWithPath: path!)
            let data = try Data(contentsOf: url)
            
            let json = try JSON(data: data)
            return json
        } catch  {
            deprint("获取缓存数据失败--->\(name)")
        }
        return JSON("")
    }
    */

}
