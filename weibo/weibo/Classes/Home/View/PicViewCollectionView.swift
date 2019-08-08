//
//  PicViewCollectionView.swift
//  weibo
//
//  Created by better on 2019/8/3.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage

class PicViewCollectionView: UICollectionView {
    //MARK： - 自定义属性
    var picUrls: [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    //MARK： - 系统回调函数
    override func awakeFromNib() {
        dataSource = self
        delegate = self
    }
    
    
}
//MARK: -collection的数据源方法
extension PicViewCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        //2.设置cell数据
        cell.picUrl = picUrls[indexPath.item]
        return cell
        
    }
}
//MARK: -collection的代理方法
extension PicViewCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //modal出一个图片控制器控制器(自己本身是一个view所以不能modal出一个控制器,只有交给HomeViewController)
        //1.将需要传递的参数传递过去
        let userInfo = ["indexPath":indexPath,"picUrls":picUrls] as [String : Any]
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhoneBrowserNote), object: self, userInfo: userInfo)
        
    }
}

//MARK: -collectionview实现AnimatorPresentedDelegate接口方法
extension PicViewCollectionView: AnimatorPresentedDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        //1.获取到选中的cell
        let cell = self.cellForItem(at: indexPath)!
        //2.获取cell的frame(这个方法可以将cell.frame在父控件的frame转换为整个屏幕的frame)
        let startRect = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startRect
        
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        //1.获取该位置的image 对象
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: picUrl.absoluteString)
        //2.计算结束后的frame
        let width  = UIScreen.main.bounds.width
        let height = (width * (image?.size.height)!) / (image?.size.width)!
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        }else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        return CGRect(x: 0, y: y, width: width, height: height)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        //1.创建imageview对象
        let imageView = UIImageView()
        //2.获取该位置的image属性
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromMemoryCache(forKey: picUrl.absoluteString)
        //3.设置imageview的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
    }
    
    
}


class PicCollectionViewCell: UICollectionViewCell {
    //MARK: -定义模型属性
    var picUrl: URL? {
        didSet {
            guard let picUrl = picUrl else {
                return
            }
            iconView.setImageWith(picUrl, placeholderImage: UIImage(named: "icon0-1"))
        }
    }
    
    
    //微博配图imageView
    @IBOutlet weak var iconView: UIImageView!
}
