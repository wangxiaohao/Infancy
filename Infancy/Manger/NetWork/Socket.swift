 //
//  Socket.swift
//  AdvertiseProject
//
//  Created by MozzosMP4 on 2016/11/16.
//  Copyright © 2016年 4wanghao. All rights reserved.
//

import UIKit
 import Starscream
import SwiftyJSON
let socketManger = Socket()
 class Socket: NSObject {
    let ws = WebSocket(url: URL(string: "ws://127.0.0.1:6666")!)
    override init() {
        
    }
    
//    //socket
//    func echoTest(completionHandler: @escaping (_ text:String) -> Void){
//        
//        ws.event.close = { code, reason, clean in
//            print("close")
//            completionHandler("close")
//
//            
//        }
//        ws.event.error = { error in
//            print("error \(error)")
//        }
//        
//
//              ws.event.message = { message in
//             
//            if let text = message as? String {
//                print("recv: \(text)")
//                if text.contains("You are connect!"){
//                    
//                     completionHandler(text)
//                    return
//                }
////                let json =  transformToData(str: text)
////                let name  = json["user"]["nickname"].stringValue
////                let red = json["red_packets"]["amount"].stringValue
////                let str = name + "  获得了" + red + "元红包"
//                
//                
//                completionHandler(text)
//            }
//        
//        }
//    }



}
