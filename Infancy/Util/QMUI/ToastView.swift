//
//  ToastView.swift
//  anbangke
//
//  Created by 王浩 on 2018/2/3.
//  Copyright © 2018年 Shanghai curtain state network technology Co., Ltd. All rights reserved.
//

import Foundation
import QMUIKit

/// QMUITost
struct ToastView{
    fileprivate static func tips()->QMUITips{
        let view = UIApplication.shared.keyWindow?.rootViewController?.view!
        let tips = QMUITips.createTips(to: view!)
        let contentView = tips.contentView as! QMUIToastContentView
        contentView.minimumSize = CGSize(width: 90, height: 90)
        return tips
    }
    /// loading
    static func showLoading(_ text:String?=""){
        tips().showLoading(text)
    }
    static func hide(){
        let view = UIApplication.shared.keyWindow?.rootViewController?.view!
        if let toast = QMUIToastView.toast(in: view){
            toast.hide(animated: true)
        }
    }
    static func showSucess(_ text:String?=""){
        tips().showSucceed(text, hideAfterDelay: 1.5)
    }
    static func showError(_ text:String?=""){
        tips().showError(text, hideAfterDelay: 1.5)
    }
    static func showMessge(_ text:String, finsh:(()->Void)?=nil){
        let tip  = tips()
        (tip.contentView as! QMUIToastContentView).detailTextLabel.font = UIFont.systemFont(ofSize: 15)
        tip.show(withText: nil, detailText: text, hideAfterDelay: 1.5)
        tip.didHideBlock = {
            _,_ in
            finsh?()
        }
    }
    static func showInfo(_ title:String?,_ info:String?){
        tips().showInfo(title, detailText: info, hideAfterDelay: 2)
    }

}
