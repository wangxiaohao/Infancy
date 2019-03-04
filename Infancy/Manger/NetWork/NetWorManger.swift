
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
    func requestData<T:BaseModel>(router:Router,data_key:[String]?=["content"],completeHandler:@escaping (Bool,[T]?)->Void) {
        Alamofire.request(router).responseJSON(completionHandler: {
            [unowned self] response in
            switch response.result {
                
            case .success:
                let result = JSON(response.data as Any)
                deprint(result)
                switch self.checkoutData(result){
                case .Sucess:
                    var data_json = result
                    for sub in data_key!{
                        data_json = data_json[sub]
                    }
                    var result_array : [T] = []
                    switch data_json.type {
                    case .dictionary:
                        guard let new_data : T = T.yy_model(withJSON: data_json) else  {
                            break;
                        }
                        result_array.append(new_data)
                    case .array:
                        for sub in data_json.array ?? [] {
                            guard let dic = sub.dictionaryObject, let new_data : T = T.yy_model(withJSON: dic) else {
                                break;
                            }
                            result_array.append(new_data)
                        }
                        break
                    default:
                        break
                    }
                    completeHandler(true,result_array)
                    break
                case .Faile:
                    //                    completeHandler((false,result))
                    break
                }
                break
            case .failure(let error):
                deprint(error)
                completeHandler(false,nil)
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
    func commonRequest(router:Router,completeHandler:@escaping (Bool,JSON?)->Void){
        Alamofire.request(router).responseJSON(completionHandler: {
            [unowned self] response in
            switch response.result {
            case .success:
                let result = JSON(response.data ?? Data())
                deprint(result)
                let status =  self.checkoutData(result)
                if status  == RequestStaus.Sucess {
                    completeHandler(true,result)
                }
            case .failure( _):
                completeHandler(false,nil)
                self.throwError("网络请求失败，请稍后再试")
                break
            }
            
        })
    }
    
    func  requestDataWith<T:BaseModel>(router:Router,data_key:[String]?=nil)->SignalProducer<[T],NSError>{
        return SignalProducer{
            [weak self] producer, disposable -> () in
            Alamofire.request(router).responseJSON(completionHandler: {
                [weak self] response in
                switch response.result {
                case .success:
                    let result = JSON(response.data as Any)
                    deprint(result)
                    switch self?.checkoutData(result){
                    case .Sucess?:
                        var data_json = result
                        if let data_key =  data_key {
                            for sub in data_key{
                                data_json = data_json[sub]
                            }
                        }
                        var result_array : [T] = []
                        switch data_json.type {
                        case .dictionary:
                            guard let new_data : T = T.yy_model(withJSON: data_json.dictionaryObject!) else  {
                                break;
                            }
                            result_array.append(new_data)
                        case .array:
                            for sub in data_json.array ?? [] {
                                guard let dic = sub.dictionaryObject, let new_data : T = T.yy_model(withJSON: dic) else {
                                    break;
                                }
                                result_array.append(new_data)
                            }
                            break
                        default:
                            break
                        }
                        producer.send(value: result_array)
                    default:
                        producer.send(error: NSError.init(domain: result["msg"].string ?? "请求失败", code: result["code"].intValue, userInfo: nil))
                        break
                    }
                case .failure(let error):
                    deprint(error)
                    self?.throwError("网络请求失败，请稍后再试")
                    break
                }
                
            })
            }.start(on: UIScheduler())
        
    }
    
    func  requestJSON(router:Router)->SignalProducer<JSON,NSError>{
        return SignalProducer{
            [weak self] producer, disposable -> () in
            Alamofire.request(router).responseJSON(completionHandler: {
                [weak self] response in
                switch response.result {
                case .success:
                    let result = JSON(response.data as Any)
                    deprint(result)
                    switch self?.checkoutData(result){
                    case .Sucess?:
                        producer.send(value: result)
                    default:
                        producer.send(error: NSError.init(domain: result["msg"].string ?? "请求失败", code: result["code"].intValue, userInfo: nil))
                        break
                    }
                case .failure(let error):
                    deprint(error)
                    self?.throwError("网络请求失败，请稍后再试")
                    break
                }
                
            })
            }.start(on: UIScheduler())
        
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
                        completHandle(nil)
                    case  .failure(_):

                        completHandle(nil)
                        
                        break
                    }
                })
            case .failure(_):
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
        
            
        }
}



