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
