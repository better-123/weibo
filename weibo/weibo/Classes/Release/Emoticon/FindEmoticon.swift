//
//  FindEmoticon.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/6.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    ///单例属性
    static let shareInstance: FindEmoticon = FindEmoticon()
    
    //MARK: - 懒加载属性
    private lazy var manager: EmoticonManager = EmoticonManager()
    
    ///查找属性字符串方法
    func findAttributedString(statusText: String?,font:UIFont) -> NSMutableAttributedString? {
//        let statusText = "[偷笑]我[吃惊]"
        //0.如果statusText为空志姐返回nil
        guard let statusText = statusText else {
            return nil
        }
        //1.创建匹配规则
        let pattenern = "\\[.*?\\]"
        //2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattenern, options: []) else {
            return nil
        }
        //3.匹配字符串内容
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))
        
        //4.获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        //反向遍历
        for (_,result) in results.enumerated().reversed() {
            //4.1获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            print(chs)
            //4.2根据chs获取图片路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            //4.2.1创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            let font = font
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            //4.2.2将属性字符串替换原来的文字
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
            
        }
        return attrMStr
    }
    ///根据chs查找pngPath方法
    private func findPngPath(chs:String) -> String? {
        let manager = EmoticonManager()
        for packge in manager.packages {
            for emoticon in packge.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
