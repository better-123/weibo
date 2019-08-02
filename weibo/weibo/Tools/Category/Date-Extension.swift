//
//  Date-Extension.swift
//  swift函数
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import Foundation

extension Date {
    
    static func createDateString(createAtStr:String) -> String {
//        let createAtStr = "Fri Aug 01 13:30:03 +0800 2018"
        //1.创建格式化对象
        let forMatter = DateFormatter()
        forMatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        forMatter.locale = Locale(identifier: "en")
        //2.将字符串时间转成Date类型
        guard let createDate = forMatter.date(from: createAtStr) else {
            return ""
        }
        //3.创建当前时间
        let nowDate = Date()
        //4.计算创建时间和当前时间的差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        //5.对时间间隔处理
        //  <60s
        if interval < 60 {
            return "刚刚"
        }
        //  多少分钟前 5分钟前
        if interval < 60*60 {
            return "\(interval / 60)分钟前"
        }
        //  多少小时前 1小时前
        if interval < 60*60*24 {
            return "\(interval / (60 * 60))小时前"
        }
        //  昨天 13:14
        //创建日历对象
        let calendar = Calendar.current
        if calendar.isDateInYesterday(createDate) {
            forMatter.dateFormat = "昨天 HH:mm"
            let timeStr = forMatter.string(from: createDate)
            return timeStr
        }
        //  一年之内 02-22 13:14
        let dateComponent = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if dateComponent.year! < 1 {
            forMatter.dateFormat = "MM-dd HH:mm"
            let timeStr = forMatter.string(from: createDate)
            return timeStr
        }
        //  超过一年。2017-02-13 13:14
        forMatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = forMatter.string(from: createDate)
        return timeStr
    }
}

