//
//  ProfileTableViewController.swift
//  weibo
//
//  Created by better on 2019/7/21.
//  Copyright © 2019 monstar. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.configurViewInfo(imageName: "3", title: "这是一条无止境的路", subTitle: "有些人选择下面,有些人只是看看而已")
    }

}
