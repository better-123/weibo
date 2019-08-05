//
//  UITextView-Extension.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/5.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

extension UITextView {
    
    ///插入表情到textView
    func insertEmoticonIntoTextView(emoticon:Emoticon) {
        //1.如果点击空白表情
        if emoticon.isEmpty {
            return
        }
        //如果点击删除按钮
        if emoticon.isDelete {
//            textView.deleteBackward()
            deleteBackward()
            return
        }
        //3.如果是emoji表情
        if emoticon.emojiCode != nil {
            //现获取光标位置
//            let textRange: UITextRange = textView.selectedTextRange!
            let textRange: UITextRange = selectedTextRange!
            //将emoji表情插入到textview
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        //4.如果是普通表情(图文混排)
        //4.1根据图片路径创建图片字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        //设置图片显示属性
//        let font = textView.font!
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        //4.2创建可变字符串
//        let mutStr = NSMutableAttributedString(attributedString: textView.attributedText)
        let mutStr = NSMutableAttributedString(attributedString: attributedText)
        //4.3将图片字符串替换到可变属性字符串的光标位置
        //获取光标位置
//        let textRange: NSRange = textView.selectedRange
        let textRange: NSRange = selectedRange
        //替换属性字符串
        mutStr.replaceCharacters(in: textRange, with: attrImageStr)
        //4.4显示字符串
//        textView.attributedText = mutStr
        attributedText = mutStr
        //属性字符串有个问题(后面的字符串会变小，所以我们要将字符串重置回去)
//        textView.font = font
        self.font = font
        //设置光标到本身位置(重置完属性后,每次插入完表情,光标会自动跑到最后)
//        textView.selectedRange = NSRange(location: textRange.location + 1, length: 0)
        selectedRange = NSRange(location: textRange.location + 1, length: 0)
    }
    
    ///获取textView的字符串(就是要将表情替换为字符串显示)
    func getEmoticonString() -> String {
        //1.获取属性字符串
//        let attrMStr = NSMutableAttributedString(attributedString: textView.attributedText)
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        //2.遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMStr.string
    }
    
    
}
