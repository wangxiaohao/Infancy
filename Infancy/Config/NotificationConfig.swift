//
//  NotificationConfig.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
//配置case
enum InNotificationName:String {
    case  login
    case  loginout

    var stringValue:String{
        return "In" + rawValue
    }
    var notificationName:NSNotification.Name{
        return NSNotification.Name(stringValue)
    }
}

// MARK: - 系统注册/发送通知
extension NotificationCenter{
    func post(InNotification  name:InNotificationName , obj:Any?=nil){
        NotificationCenter.default.post(name: name.notificationName, object: obj)
    }
    
    func add(InNotificationName name:InNotificationName,obj:Any?=nil,queue:OperationQueue?,block:@escaping (Notification)->Void){
        addObserver(forName: name.notificationName, object: obj, queue: queue) { (noti) in
            block(noti)
        }
    }
    
    func add(_ observer:Any,selector:Selector,name:InNotificationName,obj:Any?=nil){
        addObserver(observer, selector: selector, name: name.notificationName, object: obj)
    }
    
}

// MARK: - Reactive注册通知
extension Reactive where Base:NotificationCenter{
    
    func add(forName name: InNotificationName?, object: AnyObject? = nil) -> Signal<Notification, NoError> {
        return Signal { [base = self.base] observer, lifetime in
            let notificationObserver = base.addObserver(forName: name?.notificationName, object: object, queue: nil) { notification in
                observer.send(value: notification)
            }
            lifetime.observeEnded {
                base.removeObserver(notificationObserver)
            }
        }
    }
}

