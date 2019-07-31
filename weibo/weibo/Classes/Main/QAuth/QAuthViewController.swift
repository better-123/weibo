//
//  QAuthViewController.swift
//  weibo
//
//  Created by better on 2019/7/28.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SVProgressHUD

class QAuthViewController: UIViewController {
    
    //MARK: -控件属性
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏内容
        configurNavigationBar()
        //加载网页
        loadWebView()
    }



}
//MARK: -设置UI界面相关
extension QAuthViewController {
    private func configurNavigationBar() {
        ///设置左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(returnItemClick))
        ///设置右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        ///设置标题
        title = "登录"
    }
    
    
    private func loadWebView() {
        //获取加载地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        //创建对应的url
        guard let url = URL(string: urlString) else {
            return
        }
        //创建request对象
        let request = URLRequest(url: url)
        //加载request
        webView.loadRequest(request)
        
        
    }
}


//MARK:- 事件监听方法
extension QAuthViewController {
    ///登录返回
    @objc private func returnItemClick() {
        print("返回")
        dismiss(animated: true, completion: nil)
    }
    ///填充账号和密码
    @objc private func fillItemClick() {
        print("填充")
        //写js代码
        let jsCode = "document.getElementById('userId').value='wz547114264@qq.com';document.getElementById('passwd').value='9594@loveyou521';"

        //执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
        
    }
}

//MARK: - webView的代理方法
extension QAuthViewController :UIWebViewDelegate {
    ///webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    ///webView加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    ///webView加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    ///当准备加载某个网页时,会执行该方法(返回true:继续加载该页面,返回false:不加载该页面)
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        guard let url = request.url else {
            return true
        }
        //获取url的字符串
        let urlString = url.absoluteString
        guard urlString.contains("code=") else {
            return true
        }
        //将code截取出来
        let code = urlString.components(separatedBy: "code=").last!

        //请求accessToken
        loadAccessToken(code: code)
        return false
    }
}
//MARK:- 请求数据
extension QAuthViewController {
    private func loadAccessToken(code: String) {
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result : [String : AnyObject]?, error:Error?) in
            //错误校验
            if error != nil {
                print("返回数据错误")
                print(error as Any)
                return
            }
            //拿到结果
            guard let accountDict = result else {
                print("没有获取授权后的数据")
                return
            }
            let account = UserAccount(dict: accountDict)
            print(account)
            
            
        }
    }
}
