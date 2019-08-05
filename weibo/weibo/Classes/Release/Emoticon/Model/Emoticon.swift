//
//  Emoticon.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    //MARK: -定义属性
    ///emoji表情包key值
    @objc var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            //处理emoji code数据步骤
            //1.创建扫描器
            let scanner = Scanner(string: code)
            //2.调用方法,扫描出code中的值
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            //3.将value转成字符(一个UInt32不能直接转成字符串,要先转成字符,再转成字符串)
            let c = Character(UnicodeScalar(value)!)
            //4.将字符转成字符串
            emojiCode = String(c)
            
            
        }
    }
    ///默认和浪小花表情包图片对应的key值
    @objc var png: String? {
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    ///默认和浪小花表情包文字对应的key值
    @objc var chs: String?
    @objc var isDelete: Bool = false
    @objc var isEmpty: Bool = false
    
    //处理pngPath数据
    @objc var pngPath: String?
    @objc var emojiCode: String?
    
    init(dict: [String:String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    init(isDelete:Bool) {
        self.isDelete = isDelete
    }
    init(isEmpty:Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","chs","pngPath"]).description
    }
}
