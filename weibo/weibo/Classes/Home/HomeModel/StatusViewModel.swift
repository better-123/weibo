//
//  StatusViewModel.swift
//  weibo
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    //MARK: - 属性
    var status: Status?
    
    
    //MARK: - 数据处理的属性
    ///处理微博来源
    @objc var sourceText:String?
    ///处理创建时间
    @objc var createAtText : String?
    ///处理用户认证图标
    var verifiedImage: UIImage?
    ///处理用户会员等级
    var vipImage: UIImage?
    ///用户头像url
    var profileImageUrl : URL?
    ///微博配图url
    var picUrls: [URL] = [URL]()
    
    
    
    //MARK: -自定义构造函数
    init(status: Status) {
        self.status = status
        
        //1.对来源处理
        if let source = status.source , source != "" {
            //获取截取字符串起时位置和长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        //2.对时间进行处理
        if let createAt = status.created_at {
            createAtText = Date.createDateString(createAtStr: createAt)
        }
        //3.处理用户认证图标
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "login_logo")
        case 2,3,5:
            verifiedImage = UIImage(named: "qq")
        case 220:
            verifiedImage = UIImage(named: "weixin")
        default:
            verifiedImage = nil
        }
        //4.处理用户会员等级
        let mbrank = status.user?.mbrank ?? 0
        switch mbrank {
        case 1,2,3,4,5,6:
            vipImage = UIImage(named: "icon0-2")
        default:
            vipImage = UIImage(named: "icon0-1")
        }
        //5.处理用户头像url
        profileImageUrl = URL(string: status.user?.profile_image_url ?? "")
        
        //处理配图数据
        let picUrlDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        
        if let picUrlDicts = picUrlDicts {
            for picUrlDict in picUrlDicts{
                guard let picUrlString = picUrlDict["thumbnail_pic"] else{
                    continue
                }
                picUrls.append(URL(string: picUrlString)!)
                
            }
        }
    }
    
    
}
