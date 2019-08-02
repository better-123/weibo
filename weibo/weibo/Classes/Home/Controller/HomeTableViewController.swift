//
//  HomeTableViewController.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

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
        loadStatuese()
        
        //根据约束设置tableviewcell必须设置这两个参数
        self.tableView.rowHeight = UITableView.automaticDimension
        //设置tableviewcell的估算高度
        tableView.estimatedRowHeight = 200
        
    }
}

//MARK: - 设置UI界面
extension HomeTableViewController {
    private func configurNavigationBar() {
        ///设置左侧item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "icon0")
        ///设置右侧的item(通过给类增加便利构造函数来创建我们想要的view)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "icon1")
        ///设置中间的titleview
        navTitleBtn.setTitle("方一岚的倾世容颜", for: .normal)
        ///监听navTitleBtn的点击
        navTitleBtn.addTarget(self, action: #selector(navTitleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = navTitleBtn
        
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
}
//MARK: - 请求数据
extension HomeTableViewController {
    private func loadStatuese() {
        NetworkTools.shareInstance.loadStatuses { (result:[[String : AnyObject]]?, error:Error?) in
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
            for statusesDict in resultArray {
                let status = Status(dict: statusesDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            //4.刷新表格
            self.tableView.reloadData()
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

