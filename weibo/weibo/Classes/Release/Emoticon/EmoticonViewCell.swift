//
//  EmoticonViewCell.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/5.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //MARK: - 定义的属性
    var emoticon : Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            //设置emoyiconBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            //2.设置删除按钮
            if emoticon.isDelete {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    //MARK: - 懒加载属性
    private lazy var emoticonBtn: UIButton = UIButton()
    
    //重写构造函数添加控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuarUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension EmoticonViewCell {
    private func configuarUI() {
        //1.添加子控件
        contentView.addSubview(emoticonBtn)
        //2.设置按钮的frame
        emoticonBtn.frame = contentView.bounds
        //3.设置btn属性
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
