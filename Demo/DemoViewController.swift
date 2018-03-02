//
//  RootViewController.swift
//  Infancy
//
//  Created by 王浩 on 2018/3/2.
//  Copyright © 2018年 haowang. All rights reserved.
//

import UIKit
import QMUIKit
class RootViewController: BaseViewController {

    var tableView:QMUITableView!
    fileprivate var dataSource:[String]!
    fileprivate let identifier = "test"
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
            self.actionSheetToPickImage()
        default:
            break
        }
    }
}


extension RootViewController:PhotoDelegate{
    
    func didChooseImage(images: [UIImage]) {
        self.imgs = images
        self.tableView.reloadData()

    }
}

extension RootViewController{
    
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
    
}
