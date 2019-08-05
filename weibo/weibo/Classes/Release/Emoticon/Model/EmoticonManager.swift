//
//  EmoticonManager.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    
    init() {
        //1.添加最近表情包
        packages.append(EmoticonPackage(id: ""))
        //2.添加默认表情包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        //3.添加emoji表情包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        //4.添加浪小花表情包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
