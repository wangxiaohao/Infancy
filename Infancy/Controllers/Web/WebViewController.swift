//
//  WebViewController.swift
//  anbangkefitter
//
//  Created by Cunese on 2017/11/14.
//  Copyright © 2017年 Shanghai curtain state network technology Co., Ltd. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate{

    var urlString: String = ""
    
    var wk: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        
        self.wk = WKWebView(frame: UIScreen.main.bounds)
    
        let url = URL(string: self.urlString )
        guard url != nil else {
            deprint("url错误")
            return
        }
        self.wk.load(URLRequest(url: url!))
       
        self.view.addSubview(self.wk)
        
        self.wk.backgroundColor = UIColor.white
        self.wk.navigationDelegate = self
        self.wk.uiDelegate = self
//        ToastView.showLoading("加载中...")
    }
    //处理网页开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        ToastView.hide()
        deprint("didFinishNavigation")
    }
    private func webView(_ webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
//        ToastView.hide()
        
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //如果目标主视图不为空,则允许导航
        if !(navigationAction.targetFrame?.isMainFrame != nil) {
            self.wk.load(navigationAction.request)
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
