
//
//  APIRoute.swift
//  AnBankeMaster
//
//  Created by 王浩 on 2017/11/3.
//  Copyright © 2017年 haowang. All rights reserved.
//

import Foundation
import SwiftyJSON
import ReactiveSwift
import Result
import Alamofire

let NetManger = RequestAFN()
class RequestAFN {
    let reachManger = NetworkReachabilityManager(host:"www.baidu.com")
    
    /// 请求数据 简单的json转模型 直接解析返回模型 不需要的其他数据的使用
    ///
    /// - Parameters:
    ///   - router: 请求参数
    ///   - completeHandler: 回调
    func requestData<T:ModelBase>(router:Router,model:T? = nil,completeHandler:@escaping ((Bool,Any))->Void) {
        
        Alamofire.request(router).responseJSON(completionHandler: {
            [unowned self] response in
            switch response.result {
                
            case .success:
                let result = JSON(response.data as Any)
                deprint(result)
                switch self.checkoutData(result){
                case .Sucess:
                    if model != nil {
                        completeHandler(self.detailWithModel(result["content"], model!))
                    }
                    else {
                        completeHandler((true,result["content"]))
                    }
                case .Faile:
                    completeHandler((false,result))
                    break
                }
                break
            case .failure(let error):
                deprint(error)
                completeHandler((false,""))
                self.throwError("网络请求失败，请稍后再试")
                break
                
            }
            
        })
    }
    
   
    /// 通用请求 返回json数据
    ///
    /// - Parameters:
    ///   - router: 请求参数
    ///   - completeHandler: 回调
    func commonRequest(router:Router,completeHandler:@escaping ((Bool,Any))->Void){
        Alamofire.request(router).responseJSON(completionHandler: {
            [unowned self] response in
            switch response.result {
            case .success:
                let result = JSON(response.data ?? Data())
                deprint(result)
                let status =  self.checkoutData(result)
                if status  == RequestStaus.Sucess {
                    completeHandler((true,result))
                }
                else {
                    completeHandler((false,result))
                }
            case .failure( _):
                completeHandler((false,""))
                self.throwError("网络请求失败，请稍后再试")
                break
            }
            
        })
        
    }
    
    
        fileprivate func detailWithModel<T:ModelBase>(_ json:JSON,_ model:T)->(Bool,Any){
            if let datas = json["datas"].array {
                var newArray : [T] = []
                for sub in datas {
                    let new_data:T = T.initWith(sub)
                    newArray.append(new_data)
                }
                return ((true,newArray))
            }
            else {
                let new_data : T = T.initWith(json)
                return (true,new_data )
            }
        }
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - parmars: <#parmars description#>
    ///   - imagse: <#imagse description#>
    ///   - condistion: <#condistion description#>
    ///   - completHandle: <#completHandle description#>
    func uploadImage(_ url:String,parmars:[String:String]? = nil,imagse:[UIImage],condistion:ConditionType? = .Login,completHandle:@escaping (String?)->Void){
        let baseUrl = URL(string:APIList.base_url)
        let upURL  = baseUrl?.appendingPathComponent(url)
        
        /*配置请求头
         */
        let value : String = ""
        let tkIterm = URLQueryItem(name: "_tk", value: value)
        
        
        var urlcoments = URLComponents(url: upURL!, resolvingAgainstBaseURL: false)
        urlcoments?.queryItems = [tkIterm]
        let imageUpUrl = urlcoments?.url?.absoluteString
        let headers = ["content-type":"multipart/form-data"]
        let urls = CacheManger.saveImageTodisk(images: imagse)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if  let parmas =  parmars  {
                for sub in parmas{
                    multipartFormData.append(sub.value.data(using: String.Encoding.utf8)!, withName: sub.key)
                }
            }
            for (_,sub) in urls.enumerated() {
                multipartFormData.append(sub, withName: "file")
            }
        }, to: imageUpUrl!,
           method:.post,headers:headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let request,_,_):
                request.responseJSON(completionHandler: {
                    [weak self]  (response) in
                    switch response.result{
                    case .success:
                        let json = JSON(response.data ?? Data())
                        let status = self?.checkoutData(json)
                        if status == .Sucess {
                            CacheManger.removeCaheImage(urls[0].absoluteString)
                            let content = json["content"]
                            let fileName = content["fileName"].stringValue
                            let fileUrl = content["fileUrl"].stringValue
                            deprint("--->uploadfile: \(fileUrl)")
                            if fileName.count > 0 {
                                completHandle(fileName)
                                return
                            }
                        }
                        ToastView.hide()
                        ToastView.showError("图片上传失败")
                        completHandle(nil)
                    case  .failure(_):
                        ToastView.hide()
                        ToastView.showError("图片上传失败")
                        completHandle(nil)
                        
                        break
                    }
                })
            case .failure(_):
                ToastView.hide()
                ToastView.showError("图片上传失败")
                completHandle(nil)
                break
            }
        })
    }
    
    
}
//MARK: - 错误异常处理
extension RequestAFN{
    fileprivate  func checkoutData(_ result:JSON)->RequestStaus{
        let code = result["code"].intValue
        if code == 0 {
            return RequestStaus.Sucess
        }
        else {
            let messgae = result["message"].stringValue
            self.throwError(messgae,code: code)
            return RequestStaus.Faile
        }
        
    }
    
    fileprivate  func throwError(_ errormsg:String,code:Int? = 0){
        
        //处理错误返回码
        
        /** 如果需求必要  取消剩余任务
         */
//        if #available(iOS 9.0, *) {
//            Alamofire.SessionManager.default.session.getAllTasks(completionHandler: { (result) in
//                result.forEach({ (task) in
//                    task.cancel()
//                })
//
//            })
//        }
        
        ToastView.hide()
        
        ToastView.showError( errormsg)
            
        }
}



