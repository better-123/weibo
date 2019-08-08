//
//  PhotoBrowserViewController.swift
//  weibo
//
//  Created by better on 2019/8/6.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let photoBrowserCell = "photoBrowserCell"

class PhotoBrowserViewController: UIViewController {
    
    //Mark: -自定义属性
    var indexPath: IndexPath?
    var picUrls: [URL] = [URL]()
    
    //Mark: -懒加载属性
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    private lazy var closeBtn: UIButton = UIButton(title: "关 闭", bgColor: UIColor.lightGray, fontSize: 14)
    private lazy var saveBtn: UIButton = UIButton(title: "保 存", bgColor: UIColor.lightGray, fontSize: 14)
    
    //Mark: -系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        //1.设置界面
        configurUI()
        //2.滚动到相对应点击位置
        collectionView.scrollToItem(at: indexPath!, at: .left, animated: false)
    }
    
    init(indexPath:IndexPath,picUrls:[URL]) {
        super.init(nibName: nil, bundle: nil)
        self.indexPath = indexPath
        self.picUrls = picUrls
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//Mark: -设置UI界面
extension PhotoBrowserViewController {
    private func configurUI() {
        //1.添加字控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
//        collectionView.backgroundColor = UIColor.purple
        //2.设置控件的frame
        collectionView.frame = view.bounds
//        closeBtn.snp_makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.bottom.equalTo(-20)
//            make.size.equalTo(CGSize(width: 90, height: 32))
//        }
//        saveBtn.snp_makeConstraints { (make) in
//            make.right.equalTo(-20)
//            make.bottom.equalTo(closeBtn.snp_bottom)
//            make.size.equalTo(closeBtn.snp_size)
//        }
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        //3.设置collectionview的属性
        //注册cell
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        collectionView.dataSource = self
        //4.监听按钮点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
}

//Mark: -事件监听方法
extension PhotoBrowserViewController {
    @objc private func closeBtnClick() {
        print("退出图片浏览控制器")
        dismiss(animated: true, completion: nil)
    }
    @objc private func saveBtnClick() {
        print("保存图片")
        //1.获取当前显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        //2.将image保存到相册中
        //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        //completionTarget:监听者,completionSelector:监听方法
//        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc private func image(image:UIImage,didFinishSavingWithError error:Error,contextInfo:AnyObject) {
        print("---------------------")
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}



//Mark: -实现UI collectionView的数据源方法
extension PhotoBrowserViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.yellow : UIColor.green
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    
}

//Mark: -实现UI collectionView的数据源方法
extension PhotoBrowserViewController: PhotoBrowserViewCellDelegate{
    func scrollViewClick() {
        closeBtnClick()
    }
}

//Mark: -实现动画消失的接口
extension PhotoBrowserViewController: AnimatorDismissDelegate {
    func indexPathForDismiss() -> IndexPath {
        //1.获取当前正在显示的cell
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)!
    }
    
    func imageViewForDismiss() -> UIImageView {
        //1.创建imageview对象
        let imageView = UIImageView()
        //2.设置imageView的frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
        
    }
    
    
}



//MARK: -自定义布局item
//方式一:设置item布局
class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //设置layout属性
        itemSize = UIScreen.main.bounds.size
        //每个item之间的间距
        minimumInteritemSpacing = 0
        //行间距
        minimumLineSpacing = 0
        //滑动方向(水平滑动)
        scrollDirection = .horizontal
        //分页
        collectionView?.isPagingEnabled = true
        //滚动条是否可见
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        //如果需要设置内边距
//        let margin = ((collectionView?.bounds.height)! - 3 * itemWH) / 2
//        collectionView?.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
    }
    
}
