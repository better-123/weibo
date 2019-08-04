//
//  ReleaseViewController.swift
//  weibo
//
//  Created by better on 2019/8/3.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class ReleaseViewController: UIViewController {
    
    //MARK: - 懒加载属性
    private lazy var titleView: ReleaseTitleView = ReleaseTitleView()
    private lazy var images: [UIImage] = [UIImage]()
    
    //MARK: - 控件属性
    @IBOutlet weak var releaseTextView: ReleaseTextView!
    ///toolbar
    @IBOutlet weak var toolBar: UIToolbar!
    ///照片按钮
    @IBOutlet weak var pictureClick: UIButton!
    ///照片选择view
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    @IBOutlet weak var emoticonButton: UIButton!
    
    
    //MARK: - 约束属性
    ///toolbar距离底部的约束
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    ///照片选择view高度约束
    @IBOutlet weak var picturePickerHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航栏
        configurNavigationItems()
        //监听通知
        configurNotifications()
        
        //监听按键点击
        pictureClick.addTarget(self, action: #selector(pictureChooseClick), for: .touchUpInside)
        emoticonButton.addTarget(self, action: #selector(emoticonButtonClick), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //进入发布界面自动弹出键盘(让releaseTextView成为第一响应者)
        releaseTextView.becomeFirstResponder()
    }
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
}
//MARK: - 初始化界面方法
extension ReleaseViewController {
    private func configurNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(returnItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        //设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    //监听通知
    private func configurNotifications() {
        //监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //监听照片弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: picPickerAddPhotoNote), object: nil)
        //监听删除照片通知
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhotoClick(noto:)), name: NSNotification.Name(rawValue: picPickerDeletePhotoNote), object: nil)
    }
}
//MARK: - 事件监听函数
extension ReleaseViewController {
    @objc private func returnItemClick() {
        print("返回")
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendItemClick() {
        print("发送")
    }
    //通知方法
    @objc private func keyboardWillChangeFrame(note:Notification) {
        //1.获取动画时间
        let duration = note.userInfo![AnyHashable("UIKeyboardAnimationDurationUserInfoKey")]  as! TimeInterval
        //2.获取最终键盘的Y值
        let endFrame = note.userInfo![AnyHashable("UIKeyboardFrameEndUserInfoKey")] as! CGRect
        let y = endFrame.origin.y
        
        //3.计算底部工具栏距底部的间距
        let margin = UIScreen.main.bounds.height - y
        //4.执行动画
        toolBarBottom.constant = -margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    //图片按键点击
    @objc private func pictureChooseClick() {
        //退出键盘
        releaseTextView.resignFirstResponder()
        //执行动画
        picturePickerHeight.constant = UIScreen.main.bounds.height*0.65
        UIView.animate(withDuration: 0.25) {
            //统一布局
            self.view.layoutIfNeeded()
        }
    }
    //表情按钮点击
    @objc private func emoticonButtonClick() {
        //切换键盘三步
        //1.退出键盘
        releaseTextView.resignFirstResponder()
        //2.切换键盘
        releaseTextView.inputView = releaseTextView.inputView != nil ? nil : UISwitch()
        //3.设置新的键盘为第一响应者
        releaseTextView.becomeFirstResponder()
    }
}
//MARK: - 添加照片和删除照片的事件
extension ReleaseViewController {
    @objc private func addPhotoClick() {
        //1.判断照片源是否可以
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            return
        }
        //2.创建照片选择控制器
        let ipc = UIImagePickerController()
        //3.设置照片源
        ipc.sourceType = .photoLibrary
        //4.设置代理
        ipc.delegate = self
        //5.弹出控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc private func deletePhotoClick(noto: Notification) {
        //删除对应images数组中的数据
        //1.获取image对象
        guard let image = noto.object as? UIImage else {
            return
        }
        //2获取image对象所在下标值
        
        guard let index = images.index(of: image) else {
            return
        }
        //3.将图片从数组中删除
        images.remove(at: index)
        //4.重新赋值给collectionview中的数组
        picPickerView.images = images
        
        }
}


//MARK: - 代理
extension ReleaseViewController : UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: - textview代理
    //监听textView是否有值
    func textViewDidChange(_ textView: UITextView) {
        //隐藏提示label
        self.releaseTextView.placeHolderLabel.isHidden = textView.hasText
        //发送按钮可点击
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    //监听textView滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滑动textview，退出键盘
        releaseTextView.resignFirstResponder()
    }
    
    //MARK: - 图库代理
    //拿到图库里照片数据
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1拿到选中照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //2将选中照片添加到数组中
        images.append(image)
        //3.将数组赋值给collectionview,让collectionview自己展示
        picPickerView.images = images
        //退出照片选择控制器
        picker.dismiss(animated: true, completion: nil)
    }
    
}

