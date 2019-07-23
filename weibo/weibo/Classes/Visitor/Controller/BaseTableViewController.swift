//
//  BaseTableViewController.swift
//  weibo
//
//  Created by better on 2019/7/23.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    ///访客视图
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    ///是否登录
    var isLogin : Bool = false
    
    ///加载视图
    override func loadView() {
        isLogin ? super.loadView() : configurVisitorView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurNavigationItems()
    }

  
}

//MARK: - 设置UI界面
extension BaseTableViewController {
    
    //MARK: - 设置访客视图UI
    ///加载访客视图方法
    private func configurVisitorView() {
//        visitorView.backgroundColor = UIColor.yellow
        view = visitorView
        visitorView.registBtn.addTarget(self, action: #selector(BaseTableViewController.registBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), for: .touchUpInside)
    }
    
    //MARK: - 设置导航栏左右item
    ///设置导航栏左右item
    private func configurNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseTableViewController.registBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
}

//MARK: - 事件监听方法
extension BaseTableViewController {
    ///注册
    @objc private func registBtnClick() {
        print("注册")
    }
    ///登录
    @objc private func loginBtnClick() {
        print("登录")
    }
}
