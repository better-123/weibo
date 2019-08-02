//
//  Status.swift
//  weibo
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class Status: NSObject {
    //MARK: - 属性
    ///微博创建时间
    @objc var created_at: String?
    ///微博来源
    @objc var source: String?
    ///微博内容
    @objc var text: String?
    ///mid
    var mid: Int = 0
    ///用户
    @objc var user: User?
    
    //自定义构造函数
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String:AnyObject] {
            user = User(dict: userDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
