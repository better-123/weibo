//
//  HomeTableViewController.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeTableViewController: BaseTableViewController {

    
    //MARK: - 懒加载属性
    private lazy var navTitleBtn : TitleButton = TitleButton()
    //注意:在闭包中如果使用当前对象的属性或者调用方法,需要加self
    //两个地方需要用self:1>如果在函数中出现属性歧义(方法参数名和对象属性名相同),2>在闭包中使用当前对象的属性和方法需要加self
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (Bool) in
        self?.navTitleBtn.isSelected = Bool
    }
    
    ///微博数据数组
    private lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    ///提示label
    private lazy var tipLabel: UILabel = UILabel()
    ///照片弹出控制器动画
    private lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///1.没有登录
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
        
        ///2.登录后
        configurNavigationBar()
        ///3.登录后请求数据
//        loadStatuese()
        
        //根据约束设置tableviewcell必须设置这两个参数
        self.tableView.rowHeight = UITableView.automaticDimension
        //设置tableviewcell的估算高度
        tableView.estimatedRowHeight = 200
        
        //5.布局header
        configurHeaderView()
        configurFooterView()
        //6.布局提示label
        configurTipLabel()
        
        ///7.监听通知
        configurNatifications()
    }
}

//MARK: - 设置UI界面
extension HomeTableViewController {
    //布局nav的左右按钮和title
    private func configurNavigationBar() {
        ///设置左侧item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "icon0")
        ///设置右侧的item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "icon1")
        ///设置中间的titleview
        let screen_name = UserAccountViewModel.shareInstance.account?.screen_name
        if let screen_name = screen_name {
            navTitleBtn.setTitle("\(screen_name)", for: .normal)
        }
//        navTitleBtn.setTitle("方一岚的倾世容颜", for: .normal)
        ///监听navTitleBtn的点击
        navTitleBtn.addTarget(self, action: #selector(navTitleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = navTitleBtn
        
    }
    //布局下拉刷新按钮
    private func configurHeaderView() {
        //1.创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadNewStatuses))
        //2.设置header属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("松开刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        //3.设置tableview的header
        tableView.mj_header = header
        //4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    //布局上拉加载更多按钮
    private func configurFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadMoreStatuses))
    }
    //布局提示label
    private func configurTipLabel() {
        //1.将提示label添加到付控件
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        //2.设置label的frame
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 32)
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    ///监听通知方法
    private func configurNatifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: showPhoneBrowserNote), object: nil)
    }
    
}

//MARK: - 事件监听函数
extension HomeTableViewController {
    @objc private func navTitleBtnClick(titleBtn:TitleButton) {
        
        print("方一岚的倾世容颜")
        
        //1>创建控制器
        let popoverView = PopoverViewController()
        //2>设置控制器的弹出样式(保证控制器modal弹出后,底部的东西还是存在的)
        //modal出控制器,就是将弹出控制器放在一个容器中
        popoverView.modalPresentationStyle = .custom
        
        //3>自定义转场代理
        popoverView.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect.init(x: 120, y: 80, width: 120, height: 250)
        //3>弹出控制器
        present(popoverView, animated: true, completion: nil)
        
        //4>改变按钮状态(使用代理更好,通知(多层传递使用通知),闭包)
        //采用的闭包形式,在创建popoverAnimator对象时,赋值修改按钮的状态
    }
    @objc private func showPhotoBrowser(note:Notification) {
        //0.取出数据,传递给图片浏览控制器
        let indexPath = note.userInfo!["indexPath"] as! IndexPath
        let picUrls = note.userInfo!["picUrls"] as! [URL]
        //这个对象就是PicViewCollectionView类型对象
        let object = note.object as! AnimatorPresentedDelegate
        
        //1.创建图片浏览控制器
        let photoBrowserVc = PhotoBrowserViewController(indexPath: indexPath, picUrls: picUrls)
        
        //2.设置modal样式
        photoBrowserVc.modalPresentationStyle = .custom
        //3.设置转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        //4.设置动画代理
        photoBrowserAnimator.delegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        //modal出图片浏览器控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }
}
//MARK: - 请求数据
extension HomeTableViewController {
    
    //下拉刷新加载最新数据
    @objc private func loadNewStatuses() {
        print("下拉刷新")
        loadStatuese(isNewData: true)
        
    }
    //上拉加载更多数据
    @objc private func loadMoreStatuses() {
        print("上拉刷新")
       loadStatuese(isNewData: false)
    }
    
    private func loadStatuese(isNewData: Bool) {
        //1.获取since_id/max_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id-1)
        }
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result:[[String : AnyObject]]?, error:Error?) in
            //错误校验
            if error != nil {
                print(error as Any)
                return
            }
            //获取可选类型数组
            guard let resultArray = result else {
                return
            }
            //遍历微博对应字典
            var tempViewModel = [StatusViewModel]()
            for statusesDict in resultArray {
                let status = Status(dict: statusesDict)
                let viewModel = StatusViewModel(status: status)
                //  self.viewModels.append(viewModel)
                tempViewModel.append(viewModel)
                
            }
            //将数据放入到成员变量数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels
            }else {
                self.viewModels += tempViewModel
            }
            
            //4.缓存图片(为显示微博单张配图)
            self.cacheImages(viewModels: self.viewModels)
            //5.刷新表格
//            self.tableView.reloadData()
            //显示提示label
//            self.showTipLable(count: tempViewModel.count)
//            //6.结束刷新
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    //显示提示label
    private func showTipLable(count : Int) {
        //1.设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "更新\(count)条数据"
        //2.执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 0
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
    
    private func cacheImages(viewModels:[StatusViewModel]) {
        //1.创建组
        let group = DispatchGroup()
        //2.缓存图片
        for viewModel in viewModels {
            for picUrl in viewModel.picUrls {
                group.enter()
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picUrl, options: [], progress: nil, completed: { (image, _, _, _) in
//                    print("下载一张图片")
//                    print(image!)
                    SDWebImageManager.shared().saveImage(toCache: image, for: picUrl)
                    group.leave()
                })
            }
        }
        //刷新表格
        group.notify(queue: .main) {
            self.tableView.reloadData()
//            print("刷新表格")
            //显示提示label
            self.showTipLable(count: viewModels.count)
            //6.结束刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }

    }
}

//MARK:- tableView数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        
        //给cell设置数据
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        return cell
        
        
    }
}

