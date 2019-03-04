//
//  UIView+Toast.swift
//  GuideDog
//
//  Created by 王小浩 on 2019/3/4.
//  Copyright © 2019 haowang. All rights reserved.
//

import Foundation
import QMUIKit
private let timeHide = 1.5
extension UIView {
    
    fileprivate var tips:QMUITips{
        get{
            let tips = QMUITips.createTips(to: self)
            let contentView = tips.contentView as! QMUIToastContentView
            contentView.minimumSize = CGSize(width: 90, height: 90)
            return tips
        }
    }
    func showLoading(with text:String?=""){
        tips.showLoading(text)
    }
    func showSuccess(with text:String? = "",compelte:(()->Void)? = nil){
        tips.showSucceed(text, hideAfterDelay: timeHide)
        if let handle =  compelte {
            tips.didHideBlock = {
                _,_ in
                handle()
            }
        }
    }
    func showError(with text:String?="",compelte:(()->Void)? = nil){
        tips.showError(text, hideAfterDelay: timeHide)
        if let handle =  compelte {
            tips.didHideBlock = {
                _,_ in
                handle()
            }
        }
    }

    func showMessge(_ text:String, compelte:(()->Void)? = nil){
        tips.show(withText: nil, detailText: text, hideAfterDelay: timeHide)
        if let handle =  compelte {
            tips.didHideBlock = {
                _,_ in
                handle()
            }
        }
    }
    func hide(){
        QMUITips.hideAllTips(in: self)
        QMUITips.hideAllToast(in: self, animated: true)
    }

    
}
