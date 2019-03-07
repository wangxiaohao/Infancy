//
//  RequestRouter
//  anbangke
//
//  Created by 王浩 on 2017/11/6.
//  Copyright © 2017年 haowang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum ConditionType {
    case None
    case Login

}
enum RequestStaus : Int {
    case Sucess = 200
    case Faile  = 204
}

enum Router: URLRequestConvertible {
    fileprivate static let baseURLString = APIList.base_url
    case getRequest(String,[String:Any]?,ConditionType?)
    case postRequest(String,[String:Any],ConditionType?)
    case putRequest(String,[String:Any],ConditionType?)
    case deleteRequest(String,[String:Any],ConditionType?)
    
    fileprivate var method:Alamofire.HTTPMethod{
        switch self {
        case .getRequest:
            return .get
        case .postRequest:
            return .post
        case .putRequest:
            return .put
        case .deleteRequest:
            return .delete
        }
    }
    
    fileprivate  var path: String {
        switch self {
        case .getRequest(let url,_,_):
            return url
        case .postRequest(let url,_,_):
            return url
        case .putRequest(let url,_,_):
            return url
        case .deleteRequest(let url,_,_):
            return url
        }
    }
    fileprivate  var header : [String:String]? {
        var type : ConditionType?
        switch self {
        case .getRequest(_,_,let in_condition):
            type =   in_condition
        case .postRequest(_,_,let in_condition):
            type =   in_condition
        case .putRequest(_,_,let in_condition):
            type =   in_condition
        case .deleteRequest(_,_,let in_condition):
            type =   in_condition
        }
        guard type != nil  else {
            return nil
        }
        switch type!  {
        case .Login:
            //登录token配置
            let token = ""
            return ["X-auth-token": token]
        case .None:
            return nil
        }
        
    }
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlPath =  Router.baseURLString + path
        if path.contains("http"){
            urlPath = path
        }
        let url = try urlPath.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 10
        urlRequest.allHTTPHeaderFields = header
        deprint("========request URL \(url)")
        
        switch self {
        case .postRequest(_,let parameters ,_ ),.putRequest(_,let parameters ,_ ),.deleteRequest(_,let parameters ,_ ):
            deprint("========request Body,\(parameters)")
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .getRequest(_, let parameters, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            deprint("========request Body,\(parameters)")
            deprint("========get URL \(urlRequest.urlRequest?.url ?? url)")
        }
        return urlRequest
    }
}

