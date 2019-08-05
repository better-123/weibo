//
//  EmoticonViewController.swift
//  EmoticonKeyBoard
//
//  Created by better on 2019/8/4.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonViewController: UIViewController {
    
    //MARK: -定义属性
    var emoticonCallBack:(_ emoticon:Emoticon)->()
    
    
    //MARK: -懒加载属性
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar:UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    //MARK: -系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        configurUI()
    }
    //MARK: -自定义构造函数
    init(emoticonCallBack:@escaping (_ emoticon:Emoticon)->()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    //重写构造函数后必须实现
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: -设置界面ui
extension EmoticonViewController {
    private func configurUI() {
        //1.添加字控件
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.init(red: 242, green: 242, blue: 242, alpha: 1)
        view.addSubview(toolBar)
        toolBar.backgroundColor = UIColor.yellow
        //2.设置子控件约束(这里采用vfl方式)
        //如果通过代码添加autolayout约束,一定要把translatesAutoresizingMaskIntoConstraints这个属性设置为false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["collectionView":collectionView,"toolBar":toolBar]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(constraints)
        
        //3.准备collectionview,toolBar
        prepareForCollectionView()
        prepareForToolBar()
        
    }
    
    private func prepareForCollectionView() {
        //1.注册cell设置数据源
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        //设置数据源
        collectionView.dataSource = self
        //设置代理
        collectionView.delegate = self
    }
    private func prepareForToolBar() {
        //1.定义toolbar标题
        let titles = ["最近","默认","emoji","浪小花"]
        //2.遍历标题生成items
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            //
            item.tag = index
            index += 1
            //将item暂存临时数组,直接存入数组不会显示item
            tempItems.append(item)
            //添加弹簧
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        //3设置toolbar的item数组
        //移除最后一个弹簧
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    
    @objc private func itemClick(item:UIBarButtonItem) {
        //获取点击的item的tag
        let tag = item.tag
        //2.根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: tag)
        //3.滚动到对应位置
        //.left:滚动到屏幕的左边
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        
    }
}

//MARK: -实现collection数据源方法
extension EmoticonViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        
        return package.emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        //设置cell数据
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        
//        cell.backgroundColor = (indexPath.item % 2) == 0 ? UIColor.white : UIColor.green
        return cell
    }
    
    
}
//MARK: -代理方法
extension EmoticonViewController :UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.取出点击表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //2.将点击的表情添加到最近分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        //3.将表情回调给外界控制器
        emoticonCallBack(emoticon)
    }
    private func insertRecentlyEmoticon(emoticon:Emoticon) {
        //1.如果是空白表情或删除按钮就不需要显示
        if emoticon.isDelete || emoticon.isEmpty {
            return
        }
        //2.删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            //在最近组中包含了已经添加的表情,就将这个表情删除,然后再添加到该组最前面
            //取出该表情的下标值
            let index = (manager.packages.first?.emoticons.index(of:emoticon))!
            manager.packages.first!.emoticons.remove(at: index)
        }else {
            //在最近组中没有包含这个表情,先删除倒数第二个表情,然后将这个表情添加到最近组最前面
            manager.packages.first!.emoticons.remove(at: 19)
        }
        //3.将表情添加到分组中
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}

//MARK: -自定义布局item
//方式一:设置item布局
class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //计算item的宽高
        let itemWH = UIScreen.main.bounds.width / 7
        //设置layout属性
        itemSize = CGSize(width: itemWH, height: itemWH)
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
        let margin = ((collectionView?.bounds.height)! - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
    }
    
}
//方式二:设置item布局
//设置collection 的布局
//let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
//let itemWH = (UIScreen.main.bounds.width - 4*margin) / 3
//layout.itemSize = CGSize(width: itemWH, height: itemWH)
