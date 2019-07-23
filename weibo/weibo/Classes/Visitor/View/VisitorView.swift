//
//  VisitorView.swift
//  weibo
//
//  Created by better on 2019/7/23.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //MARK: - 控件属性
    ///图片
    @IBOutlet weak var backImageView: UIImageView!
    ///标题文字
    @IBOutlet weak var titleLable: UILabel!
    ///副标题文字
    @IBOutlet weak var subTitleLable: UILabel!
    ///注册按钮
    @IBOutlet weak var registBtn: UIButton!
    ///登录按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: -  提供快速通过xib加载创建类方法
    class func visitorView() -> VisitorView {
        //保证从XIB中加载视图
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.last as! VisitorView
    }

    
    //MARK: - 自定义函数
    func configurViewInfo(imageName:String,title:String,subTitle:String) {
        backImageView.image = UIImage(named: imageName)
        titleLable.text = title
        subTitleLable.text = subTitle
    }
    
    func addRotationAnimation() {
        //1>创建动画(核心动画CAKeyframeAnimation(属性values可以传很多值),CABasicAnimation:)
        let rotationAnimation =  CABasicAnimation(keyPath: "transform.rotation.z")
        //2>设置动画属性
        rotationAnimation.fromValue = 0   //开始位置
        rotationAnimation.toValue = Double.pi * 2    //结束位置
        rotationAnimation.repeatCount = MAXFLOAT     //旋转次数
        rotationAnimation.duration = 5            //旋转事件
        rotationAnimation.isRemovedOnCompletion = false  //解决切换界面,重新加载页面动画停止的问题
        
        //3>将动画添加到layer中
        backImageView.layer.add(rotationAnimation, forKey: nil)
    }
}
