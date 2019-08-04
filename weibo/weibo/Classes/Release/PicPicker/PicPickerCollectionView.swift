//
//  PicPickerCollectionView.swift
//  weibo
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let margin: CGFloat = 10
class PicPickerCollectionView: UICollectionView {
    
    //MARK: -自定义属性
    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    

    //MARK: -系统回调函数
    override func awakeFromNib() {
        //设置collection 的布局
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4*margin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        //设置collectionview的内边距
        contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
        register(UINib(nibName: "PicPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
    }

}

extension PicPickerCollectionView :UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerCollectionViewCell
        cell.backgroundColor = UIColor.yellow
        if indexPath.item <= (images.count-1) {
            cell.image = images[indexPath.item]
        }else {
            cell.image = nil
        }
        return cell
    }
    
    
}
