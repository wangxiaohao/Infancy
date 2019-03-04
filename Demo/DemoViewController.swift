//
//  RootViewController.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import UIKit
import QMUIKit
import Alamofire
import SwiftyJSON
import Starscream
import ReactiveSwift
import Result
class RootViewController: BaseViewController {

    var tableView:QMUITableView!
    fileprivate var dataSource:[String]!
    fileprivate let identifier = "test"
    let (siganl,obser) = Signal<Int,NoError>.pipe()
    var dis : Disposable?

    var imgs:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Infancy"
        
        tableView = {
            let table_view = QMUITableView(frame: self.view.bounds, style: .plain)
            table_view.delegate = self
            table_view.dataSource = self
            self.view.addSubview(table_view)
            return table_view
        }()
        dataSource = ["图片选择","网络请求","刷新加载","缓存","按钮","Toast"]
        
     
        
        siganl.observeValues {
            [weak self](value) in
            
            self?.toAnalysisJSON()
            print("222222222222----->\(value)")
        }
        
      
    }
    override func viewDidAppear(_ animated: Bool) {
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension RootViewController:QMUITableViewDelegate,QMUITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = QMUITableViewCell(for: tableView, with: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        if  indexPath.row < imgs.count {
            cell?.imageView?.image = imgs[indexPath.row]
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
//            self.actionSheetToPickImage()
             self.dis?.dispose()
            break
            
          
        case 1:
//            sysRequestData()
            let dis1 =    siganl.observeValues { (value) in
                value
                
                print("111111111111----->\(value)")
              
            }
            dis = dis1
        case 3:
              obser.send(value: 1)
        case 4:
              obser.send(value: 2)
            
        default:
            break
        }
    }
}
extension RootViewController:WebSocketDelegate{
    func websocketDidConnect(socket: WebSocketClient) {
        print("连接成功")

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("关闭连接")

    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("接受",text)

    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("接受data",data)

    }
    
  
    
    
}

extension RootViewController:PhotoDelegate{
    
    func didChooseImage(images: [UIImage]) {
        self.imgs = images
        self.tableView.reloadData()

    }
}

extension RootViewController{
    
    func  toAnalysisJSON(){
        NetManger.commonRequest(router: Router.getRequest("/api/v1/users/1/2", nil, .Login)) { (r ) in
            let json = r.1 as! JSON
            print("------> result \n",json)
            let sub = json["user"]
            let keyArray = sub.dictionaryValue.map({ (arg) -> String in
                return arg.key
            })
            
            for sub_key in keyArray {
                
                let v = sub[sub_key]
                switch v.type {
                case .number:
                    print("var \(sub_key) : Int = 0 ")
                    break
                case .string:
                    print("var \(sub_key) : String?")
                    break
                case .bool:
                    print("var \(sub_key) : Bool? ")
                    break
                case .array:
                    print("var \(sub_key) : Array? ")
                    break
                case .dictionary:
                    print("var \(sub_key) : [String:Any]? ")
                    break
                case .null:
                    print("var \(sub_key) : null? ")
                    break
                case .unknown:
                    print("var \(sub_key) : unknown? ")
                    break
                }
            }
        }
        
    }
    /// 适合简单的模型解析
    func requestData(){
        ToastView.showLoading()
        NetManger.requestData(router: Router.getRequest(APIList.base_url, nil, nil), model: ExampleModel())
            {
                [weak self] (result) in
                guard result.0,let json = result.1 as? [ExampleModel] else {
                    return
                }
                ToastView.hide()
            }
    }
    
    func sysRequestData(){
        ToastView.showLoading()
        Alamofire.request(Router.getRequest(APIList.base_url, ["city":"北京"], nil)).responseJSON {
            (response) in
            ToastView.hide()
            switch response.result{
            case .success:
                let json =  JSON(response.data)
                ToastView.showMessge(json["message"].stringValue)
                deprint(json)
                break
            case .failure(_):
            break
            }
            
        }
    }
}
