//
//  User.swift
//  weibo
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    
    //MARK: -属性
    //头像地址
    @objc var profile_image_url: String?
    //昵称
    @objc var screen_name: String?
    //认证
    @objc var verified_type: Int = -1
    //会员等级
    @objc var mbrank: Int = 0
    
    
    
    //自定义构造函数
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    
}
