//
//  HomeViewCell.swift
//  weibo
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15

class HomeViewCell: UITableViewCell {
    //MARK:-控件属性
    
    ///头像图标
    @IBOutlet weak var headView: UIImageView!
    ///认证图标
    @IBOutlet weak var verifiedView: UIImageView!
    ///昵称
    @IBOutlet weak var screenNameLable: UILabel!
    ///vip图标
    @IBOutlet weak var vipView: UIImageView!
    ///微博发布时间
    @IBOutlet weak var timeLable: UILabel!
    ///微博来源
    @IBOutlet weak var sourceLable: UILabel!
    ///正文
    @IBOutlet weak var contentLable: UILabel!
    
    
    //MARK: -约束属性
    ///正文内容lable宽度
    @IBOutlet weak var contentLableWidth: NSLayoutConstraint!
    
    //MARK: -自定义属性
    var viewModel :StatusViewModel? {
        didSet{
            //1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            //2.给控件设值
            //头像
            headView.setImageWith(viewModel.profileImageUrl!, placeholderImage: UIImage(named: "icon2-1"))
            //设置认证图标
            verifiedView.image = viewModel.verifiedImage
            //设置昵称
            screenNameLable.text = viewModel.status?.user?.screen_name
            screenNameLable.textColor = viewModel.status?.user?.mbrank == 0 ? UIColor.black : UIColor.orange
            //设置会员
            vipView.image = viewModel.vipImage
            //设置微博发布时间
            timeLable.text = viewModel.createAtText
            //设置微博来源
            sourceLable.text = viewModel.sourceText
            //设置正文
            contentLable.text = viewModel.status?.text
            
        }
    }
    
    
    //从xib中加载控件的时候就会执行
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLableWidth.constant = UIScreen.main.bounds.width - 2*edgeMargin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
