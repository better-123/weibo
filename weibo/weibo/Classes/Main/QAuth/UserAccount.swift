//
//  UserAccount.swift
//  weibo
//
//  Created by better on 2019/7/28.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding {
   
    

    //MARK:- 属性
    ///access_token
    @objc var access_token: String?
    ///过期时间(秒)
    var expires_in: TimeInterval = 157679999.0
    {
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
//        return dictionaryWithValues(forKeys: ["access_token","expires_in","expires_date","uid","profile_image_url","screen_name"]).description
//
//    }
    
    
    //MARK: -归档和解档(如果要保存一个对象,这个对象对应的这个模型必须遵守NSCoding协议)
    ///归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    ///解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        profile_image_url = aDecoder.decodeObject(forKey: "profile_image_url") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        
    }
    
}

