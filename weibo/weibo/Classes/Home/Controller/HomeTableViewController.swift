//
//  HomeTableViewController.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    //MARK: - 懒加载属性
    private lazy var navTitleBtn : TitleButton = TitleButton()
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ///1.没有登录
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
        ///2.登录后
        configurNavigationBar()
    }
}

//MARK: - 设置UI界面
extension HomeTableViewController {
    private func configurNavigationBar() {
        ///设置左侧item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "icon0")
        ///设置右侧的item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "icon1")
        ///设置中间的titleview
        navTitleBtn.setTitle("方一岚的倾世容颜", for: .normal)
        ///监听navTitleBtn的点击
        navTitleBtn.addTarget(self, action: #selector(navTitleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = navTitleBtn
        
    }
}
//MARK: - 事件监听函数
extension HomeTableViewController {
    @objc private func navTitleBtnClick(titleBtn:TitleButton) {
        navTitleBtn.isSelected = !navTitleBtn.isSelected
        print("方一岚的倾世容颜")
    }
}
