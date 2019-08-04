//
//  PicPickerCollectionViewCell.swift
//  weibo
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class PicPickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - 定义属性
    var image: UIImage? {
        didSet {
            if image != nil {
                addPhotoButton.isHidden = true
                deletePhotoButton.isHidden = false
                photoImageView.image = image
            }else {
                photoImageView.image = nil
                addPhotoButton.isHidden = false
                deletePhotoButton.isHidden = true
            }
        }
    }
    
    //MARK: - 控件属性
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var deletePhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK: - 事件监听
    @IBAction func addPicClick() {
        //创建通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: picPickerAddPhotoNote), object: nil)
    }
    
    @IBAction func deletePhotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: picPickerDeletePhotoNote), object: photoImageView.image)
        
    }
    
}
