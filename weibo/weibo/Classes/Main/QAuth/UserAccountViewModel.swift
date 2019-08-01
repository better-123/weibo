//
//  UserAccountTool.swift
//  weibo
//
//  Created by better on 2019/8/1.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
//视图模型,就是某个视图模型进行封装
class UserAccountViewModel {
    //MARK: - 设计单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    
    //MARK: - 属性
    var account: UserAccount?
    
    //MARK: - 计算属性
    var accountPath:String {
        //获取沙盒路径
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        accountPath = accountPath + "/account.plist"
        return accountPath
    }
    var isLogin: Bool {
        if account == nil {
            return false
        }
//        guard let expiresDate = account?.expires_date else{
//            return false
//        }
//        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
        return true
    }
    
    
    init() {
        //读取用户信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
}
