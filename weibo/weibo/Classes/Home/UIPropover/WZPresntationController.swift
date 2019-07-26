//
//  WZPresntationController.swift
//  weibo
//
//  Created by better on 2019/7/23.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class WZPresntationController: UIPresentationController {
    ///容器已经布局了
//    override func containerViewDidLayoutSubviews() {
//
//    }
    //Mark: - 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    
    //Mark: - 懒加载属性
    ///蒙版view
    private lazy var coverView : UIView = UIView()
    
    ///容器即将布局自己的子控件
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //被弹出view
        presentedView?.frame = presentedFrame
        
        //添加蒙版
        configurCoverView()
    }
    
}
//MARK: - 设置界面相关
extension WZPresntationController {
    ///设置蒙版view
    private func configurCoverView() {
        //1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        //2.设置蒙版属性
        coverView.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
        coverView.frame = containerView!.bounds
        //3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(WZPresntationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}
//MARK: - 事件监听方法
extension WZPresntationController {
    @objc private func coverViewClick() {
        print("退出蒙版")
        //被弹出控制器.调用消失方法
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
