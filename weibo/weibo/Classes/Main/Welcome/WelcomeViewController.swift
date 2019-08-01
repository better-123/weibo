//
//  WelcomeViewController.swift
//  weibo
//
//  Created by better on 2019/8/1.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    //MARK:- 拖线属性
    ///imageview距离底部的约束
    @IBOutlet weak var imageViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileImagegString = UserAccountViewModel.shareInstance.account?.profile_image_url
        let profileImagegUrl = URL(string: profileImagegString ?? "")
        
        //设置头像
        imageView.setImageWith(profileImagegUrl!, placeholderImage: UIImage(named: "icon2-2"))
        //改变约束的值
        imageViewBottomCons.constant = UIScreen.main.bounds.height - 200
        //执行动画
        //Damping:阻力系数，阻力系数越大弹的效果越不明显(0,1),initialSpringVelocity:初始化速度,options:枚举类型(动画效果类型,先快后慢或者先慢后快以及其他)
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (Bool) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        }
    }


    

}
