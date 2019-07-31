//
//  UserAccount.swift
//  weibo
//
//  Created by better on 2019/7/28.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class UserAccount: NSObject {

    //MARK:- 属性
    ///access_token
    @objc var access_token: String?
    ///过期时间(秒)
    var expires_in: TimeInterval = 0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    ///用户ID
    @objc var uid: String?
    ///过期日期
    var expires_date : Date?
    ///用户昵称
    @objc var screen_name: String?
    ///用户头像地址
    @objc var profile_image_url: String?
    
    
    
    //MARK:- 自定义构造函数
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
//    override var description: String {
//        //模型对象转换为字典
//        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid","profile_image_url","screen_name"]).description
//
//    }
    
}
