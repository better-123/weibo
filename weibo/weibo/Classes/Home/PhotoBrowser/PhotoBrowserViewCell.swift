//
//  PhotoBrowserViewCell.swift
//  weibo
//
//  Created by better on 2019/8/7.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate: NSObjectProtocol {
    func scrollViewClick()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    
    //MARK: - 自定义属性
    var picUrl: URL? {
        didSet{
            configurContent(picUrl: picUrl)
        }
    }
    var delegate: PhotoBrowserViewCellDelegate?
    
    
    //MARK: - 懒加载属性
    private lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    private lazy var progressView: ProgressView = ProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 设置界面
extension PhotoBrowserViewCell {
    private func configurUI() {
        //1.添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(progressView)
        //2.设置子控件的frame
        scrollView.frame = contentView.bounds
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
        //3.设置控件的属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        //4给scrollview添加手势
        let taPGes = UITapGestureRecognizer(target: self, action: #selector(scrollViewClick))
        scrollView.addGestureRecognizer(taPGes)
    }
}
//MARK: - 设置cell的内容
extension PhotoBrowserViewCell {
    private func configurContent(picUrl:URL?) {
        //1.空值校验
        guard let picUrl = picUrl else {
            return
        }
        //2.取出Image对象
        let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: picUrl.absoluteString)
        //3.计算imageView的frame
        let x: CGFloat = 0
        let width = UIScreen.main.bounds.width
        let height = (width * (image?.size.height)!) / (image?.size.width)!
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        //4.设置imageView的图片
        self.progressView.isHidden = false
        let bigPicUrl = loadBigImage(smallImageUrl: picUrl)
        imageView.sd_setImage(with: bigPicUrl, placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current)/CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        imageView.image = image
        //5.设置scrollview的contentsize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    private func loadBigImage(smallImageUrl:URL) -> URL {
        let smallImageString = smallImageUrl.absoluteString
        let bigImageString = smallImageString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigImageString)!
    }
}
//MARK: - 事件监听
extension PhotoBrowserViewCell {
    @objc private func scrollViewClick() {
        delegate?.scrollViewClick()
    }
}
