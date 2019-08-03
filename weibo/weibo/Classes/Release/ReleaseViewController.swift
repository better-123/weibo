//
//  ReleaseViewController.swift
//  weibo
//
//  Created by better on 2019/8/3.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class ReleaseViewController: UIViewController {
    
    //MARK: - 懒加载属性
    private lazy var titleView: ReleaseTitleView = ReleaseTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏
        configurNavigationItems()
    }



}
//MARK: - 初始化界面方法
extension ReleaseViewController {
    private func configurNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(returnItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        //设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}
//MARK: - 事件监听函数
extension ReleaseViewController {
    @objc private func returnItemClick() {
        print("返回")
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendItemClick() {
        print("发送")
    }
}
