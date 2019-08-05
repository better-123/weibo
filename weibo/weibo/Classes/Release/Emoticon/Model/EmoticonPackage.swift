//
//  EmoticonPackage.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    
    var emoticons: [Emoticon] = [Emoticon]()
    
    init(id : String) {
        super.init()
        //最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        //2.根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info", ofType: "plist", inDirectory: "Emoticons.bundle")!
        //3.根据文件路径获取数据
        let array = NSDictionary(contentsOfFile: plistPath)!["emoticons"] as! [[String : String]]

        //4.遍历数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index += 1
            if index == 20 {
                //添加删除表情
                emoticons.append(Emoticon(isDelete: true))
                index = 0
            }
        }
        self.addEmptyEmoticon(isRecently: false)
    }
    //添加空白表情,判断是否是最近表情页
    private func addEmptyEmoticon(isRecently:Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isDelete: true))
    }
}
