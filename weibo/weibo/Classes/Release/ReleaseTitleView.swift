//
//  ReleaseTitleView.swift
//  weibo
//
//  Created by better on 2019/8/3.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SnapKit

class ReleaseTitleView: UIView {
    //MARK: - 懒加载属性
    ///titleLable
    private lazy var titleLabel: UILabel = UILabel()
    ///subTitleLabel
    private lazy var subTitleLabel: UILabel = UILabel()
    
    
    
    //构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ReleaseTitleView {
    private func configurUI() {
        //1.将字控件添加到view中
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        //2.设置控件的frame
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
//        titleLabel.snp_makeConstraints { (make:ConstraintMaker) in
////            make.centerX.equalTo(self)
//            make.top.equalTo(self)
//            make.left.equalTo(self)
//            make.right.equalTo(self)
//        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
//        subTitleLabel.snp_makeConstraints { (make:ConstraintMaker) in
////            make.centerX.equalTo(titleLabel.snp_centerX)
//            make.top.equalTo(titleLabel.snp_bottom).offset(3)
//            make.bottom.equalTo(self)
//            make.left.equalTo(self)
//            make.right.equalTo(self)
//        }
        //设置控件属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = UIColor.lightGray
        //设置文字内容
        titleLabel.text = "发微博"
        subTitleLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
