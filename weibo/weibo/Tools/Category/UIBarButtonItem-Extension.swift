//
//  UIBarButtonItem-Extension.swift
//  weibo
//
//  Created by better on 2019/7/23.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    //便利构造方法一:
    convenience init(imageName:String) {
        self.init()
        let btn = UIButton(imageName: imageName)
        self.customView = btn
        
    }
    /*
     //便利构造方法二:
    convenience init(imageName:String) {
        let btn = UIButton(imageName: imageName)
        self.customView = btn
        self.init(customView: btn)
    }
 */
}
