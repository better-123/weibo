//
//  TitleButton.swift
//  weibo
//
//  Created by better on 2019/7/23.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    //重写控件的方法一般不重写init(),而是重写init(frame)
    override init(frame:CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "go"), for: .normal)
        setImage(UIImage(named: "back"), for: .selected)
        setTitleColor(UIColor.orange, for: .normal)
        sizeToFit()
    }
    
    //swift中规定,重写控件init(frame)方法或者init()方法,必须重写init(coder)方法,可以不写什么,但必须实现这个方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///调整Button内部控件的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width + 5
    }
    
}
