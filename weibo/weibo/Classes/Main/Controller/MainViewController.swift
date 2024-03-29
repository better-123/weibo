//
//  MainViewController.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //发布按钮
    //类方法创建按钮
//    private lazy var relaeseBtn : UIButton = UIButton.createButton(imageName: "icon0")
    //便利构造函数创建按钮
    private lazy var releaseBtn : UIButton = UIButton(imageName: "icon0")
    override func viewDidLoad() {
        super.viewDidLoad()

        //纯代码初始化项目方法
        /*
        //方式三:通过json文件方式初始化项目
        //获取json路径
        guard let jsonPath = Bundle.main.path(forResource: "main.json", ofType: nil) else {
            print("没有获取到对应文件路径")
            return
        }
        //读取json文件中的内容
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            print("没有获取到json中的数据")
            return
        }
        
        let data = jsonData as Data
        
        //json解析
        guard let anyObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            print("没有数据")
            return
        }
        //将anyObject转成数组
        guard let dictArr = anyObject as? [[String:AnyObject]] else {
            print("未转成数组")
            return
        }
        for dict in dictArr {
            print(dict)
            //获取控制器对应字符串
            guard let viewName = dict["viewName"] as? String else {
                continue
            }
            guard let title = dict["title"] as? String else {
                continue
            }
            guard let tabImage = dict["tabImage"] as? String else {
                continue
            }
            guard let tabSelImage = dict["tabSelImage"] as? String else {
                continue
            }
            guard let navTitle = dict["navTitle"] as? String else {
                continue
            }
            addChildViewControlle(chlidVc: viewName, title: title, tabImage: tabImage, tabSelImage: tabSelImage, navTitle: navTitle)
        }
        
        
        //方式一:通过方法设置直接初始化项目
        //方式二:通过字符长方式初始化项目
        //首页
//        addChildViewControlle(chlidVc: "HomeTableViewController", title: "首页", tabImage: "icon0-1", tabSelImage: "icon0-2", navTitle: "首页")
//        //消息
//        addChildViewControlle(chlidVc: "MessageTableViewController", title: "消息", tabImage: "icon1-1", tabSelImage: "icon1-2", navTitle: "消息")
//        //发现
//        addChildViewControlle(chlidVc: "DiscoverTableViewController", title: "发现", tabImage: "icon1-1", tabSelImage: "icon1-2", navTitle: "发现")
//        //我的
//        addChildViewControlle(chlidVc: "ProfileTableViewController", title: "我的", tabImage: "icon2-1", tabSelImage: "icon2-2", navTitle: "我的")
        
      */
        
        //设置发布按钮
        configurReleaseBtn()
    }
    
    //方法重载:方法名相同,参数不同
    //private:在当前文件中可用,其他文件不能访问
    /*
    private func addChildViewControlle(chlidVc:String,title:String,tabImage:String,tabSelImage:String,navTitle:String) {
        
        //获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有拿到命名空间")
            return
        }
        //根据对应字符串,获取到对应的class
        guard let childClass:AnyObject = NSClassFromString(nameSpace + "." + chlidVc) else {
            print("没有拿到字符串对应的class")
            return
        }
        print("拿到对应class")
        //将对应的anyObject转成控制器类型
        guard let childType = childClass as? UIViewController.Type else {
            print("没有获取到对应的控制器类型")
            return
        }
        //创建对应控制器对象
        let childView = childType.init()
        
        
        childView.title = title
        childView.tabBarItem.image = UIImage(named: tabImage)
        childView.tabBarItem.selectedImage = UIImage(named: tabSelImage)
        
        let chlidNav = UINavigationController(rootViewController: childView)
        
        addChild(chlidNav)
        
    }
    */


}
//MARK: - 设置UI界面
extension MainViewController {
    //设置发布安妮
    func configurReleaseBtn() {
        //将发布按钮添加到TabBar上
        tabBar.addSubview(releaseBtn)
        /*
        relaeseBtn.setImage(UIImage(named: "icon0-1"), for: .normal)
        relaeseBtn.setImage(UIImage(named: "icon0-2"), for: .highlighted)
        relaeseBtn.sizeToFit()
         */
        //设置发布按钮位置
        releaseBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height*0.5)
        //监听发布按钮的点击
        //Selector():两种写法,1>Selector("方法的名字"),2>直接“方法的名字”
        releaseBtn.addTarget(self, action: #selector(MainViewController.releaseBtnClick), for: .touchUpInside)
    }
    
}
//MARK: - 事件监听
extension MainViewController {
    //事件监听本质是发送消息,但是发送消息是OC特性(OC中:将方法包装成@SEL类型->去类中查找方法列表->根据@SEL找到imp函数指针->执行调用这个函数)
    //swift:如果在swift中将函数声明成private,那么函数不会被添加到方法列表中,使用@SEL方法去监听函数,程序就会报错,要想解决这个问题,要么去掉private,要么在private前面加上@objc
    @objc private func releaseBtnClick() {
        print("releaseClick")
        //1.创建Releaseview
        let releaseViewController = ReleaseViewController()
        //2.包装导航控制器
        let releaseNav = UINavigationController(rootViewController: releaseViewController)
        //3.弹出发布控制器view
        present(releaseNav, animated: true, completion: nil)
        
        
    }
}
