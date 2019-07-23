//
//  UIButton-Extension.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
extension UIButton {
    ///类方法:给图片名字,创建并设置图片给按钮返回按钮
    //类方法是以class 开头的方法
    class func createButton(imageName:String) -> UIButton {
        let btn = UIButton()
//        btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
//        btn.setBackgroundImage(UIImage(named: bgImageName), for: .highlighted)
        btn.setImage(UIImage(named: imageName+"-1"), for: .normal)
        btn.setImage(UIImage(named: imageName+"-2"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
    
    ///便利构造函数:给图片名字,创建并设置图片给按钮返回按钮
    //构造函数不需要写返回值
    //convenience:它修饰的构造函数,叫便利构造函数,通常用在对系统类进行构造函数扩充使用
    //特点:1写在extension中,2需要在前面加convenience,3在便利构造函数中需要明确写上self.init()
    convenience init(imageName:String){
        self.init()
        setImage(UIImage(named: imageName + "-1"), for: .normal)
        setImage(UIImage(named: imageName + "-2"), for: .highlighted)
        sizeToFit()
    }
    
    
}
