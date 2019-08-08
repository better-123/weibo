//
//  HomeViewCell.swift
//  weibo
//
//  Created by better on 2019/8/2.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage
///边距
private let edgeMargin: CGFloat = 15
///微博配图间距
private let itemMargin: CGFloat = 10

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
    ///微博配图
    @IBOutlet weak var PicViewCollection: PicViewCollectionView!
    ///转发微博正文
    @IBOutlet weak var retweetedContentLable: UILabel!
    //转发背景
    @IBOutlet weak var retweetedBgColor: UIView!
    
    //MARK: -约束属性
    ///正文内容lable宽度约束
    @IBOutlet weak var contentLableWidth: NSLayoutConstraint!
    ///微博配图Collection的宽度约束
    @IBOutlet weak var picViewCollectionWidth: NSLayoutConstraint!
    ///微博配图Collection的高度约束
    @IBOutlet weak var picViewCollectionHeight: NSLayoutConstraint!
    ///微博配图Collection的距离底部工具栏的高度约束
    @IBOutlet weak var pickViewcollectionBottom: NSLayoutConstraint!
    ///转发微博label顶部距离正文label底部的距离约束
    @IBOutlet weak var retweetedLableTop: NSLayoutConstraint!
    
    
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
//            let statusText = viewModel.status?.text
//            contentLable.attributedText = FindEmoticon.shareInstance.findAttributedString(statusText: statusText, font: contentLable.font)
            contentLable.text = viewModel.status?.text
            
            //9.计算picView的宽度和高度约束
            let picViewSize = calculatePicViewSize(count: viewModel.picUrls.count)
            picViewCollectionWidth.constant = picViewSize.width
            picViewCollectionHeight.constant = picViewSize.height
            
            //10.传给colletion数据
            PicViewCollection.picUrls = viewModel.picUrls
            
            //11.设置转发微博正文
            if viewModel.status?.retweeted_status != nil {
                if let retweetedScreenName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetedText = viewModel.status?.retweeted_status?.text {
                    //设置转发微博正文距离顶部微博正文的距离
                    retweetedLableTop.constant = 15
                    ///转发正文内容
//                    let retweetedText = "@" + "\(retweetedScreenName): " + retweetedText
//                    retweetedContentLable.attributedText = FindEmoticon.shareInstance.findAttributedString(statusText: retweetedText, font: retweetedContentLable.font)
                    retweetedContentLable.text = "@" + "\(retweetedScreenName): " + retweetedText
                }
                //设置转发背景显示
                retweetedBgColor.isHidden = false
                
            }else {
                retweetedContentLable.text = nil
                //设置转发背景显示
                retweetedBgColor.isHidden = true
                //设置转发微博正文距离顶部微博正文的距离
                retweetedLableTop.constant = 0
                
            }
            
        }
    }
    
    
    //从xib中加载控件的时候就会执行
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文宽度约束
        contentLableWidth.constant = UIScreen.main.bounds.width - 2*edgeMargin
        
        //取出picView对应的laout(items布局方式)
        //方式一:(不管图片只有一种的情况)
//        let layOut = PicViewCollection.collectionViewLayout as! UICollectionViewFlowLayout
//        let imageWH = (UIScreen.main.bounds.width - 2*edgeMargin - 2*itemMargin)/3
//        //一张图片时设置itemsize
//        layOut.itemSize = CGSize(width: imageWH, height: imageWH)
        //方式二:(添加图片只有一种的情况)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
//MARK: -计算方法
extension HomeViewCell {
    private func calculatePicViewSize(count:Int) -> CGSize {
        //1.没有配图
        if count == 0 {
            //没有配图设置collection距离底部距离为0
            pickViewcollectionBottom.constant = 0
            //没有配图设置返回icon的size为0
            return CGSize.zero
        }
        //方式二:(添加图片只有一种的情况)
        //取出picView对应的layout
        let layOut = PicViewCollection.collectionViewLayout as! UICollectionViewFlowLayout
        
//        //2.一张配图
        if count == 1 {
            //取出图片
            let urlString = viewModel?.picUrls.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: urlString)
//            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
            //一张图片时设置itemsize
            layOut.itemSize = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            //直接返回图片的size，系统回默认将图片大小压缩一倍,所以下面设置图片宽高各乘2倍
            return CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        }
        //有配图设置collection距离底部距离为10
        pickViewcollectionBottom.constant = 10
        
        //每张微博配图的宽高
        let imageWH = (UIScreen.main.bounds.width - 2*edgeMargin - 2*itemMargin)/3
        //方式二:(添加图片只有一种的情况)
        //一张图片时设置itemsize
        layOut.itemSize = CGSize(width: imageWH, height: imageWH)
        
        //2.四张配图
        if count == 4 {
            let picViewWH = imageWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //3.其他配图
        //3.1计算行数
        let rows = CGFloat((count-1)/3+1)
        //picview的高度
        let picViewH = rows * imageWH + (rows-1)*itemMargin
        //picview的宽度
        let picViewW = UIScreen.main.bounds.width - 2*edgeMargin
        return CGSize(width: picViewW, height: picViewH)
        
        
    }
    
}
