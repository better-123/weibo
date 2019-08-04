//
//  ReleaseTextView.swift
//  weibo
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SnapKit

class ReleaseTextView: UITextView {
    //MARK: -懒加载属性
    lazy var placeHolderLabel: UILabel = UILabel()
    
    
    //MARK: -构造函数
    //如果是从xib中加载,现加载init(coder:NSCoder),再加载awakeForNib
    //一般添加字控件用init(coder:NSCoder),如果对字控件初始化用awakeForNib(设置控件颜色,背景等这些)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurUI()
    }
    
    
}

//MARK: -设置UI界面
extension ReleaseTextView {
    private func configurUI() {
        //1.添加子控件
        addSubview(placeHolderLabel)
        //2.设置labelframe
        placeHolderLabel.snp_makeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(10)
        }
        //3.设置label属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.font = UIFont.systemFont(ofSize: 17)
        //4.设置内容内边距
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 6, right: 8)
    }
}



