//
//  ViewController.swift
//  区帮
//
//  Created by apple on 2016/8/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController ,UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.blackColor()
        self.tabBar.barTintColor = UIColor.whiteColor()
        addChildViewControllers()
        NSThread.sleepForTimeInterval(2.0)
        self.delegate = self
    } 
    func addChildViewControllers()
    {
        addChildViewController(HomapageTableViewController() ,title: "邻里",imageName:"邻里主页")
//        addChildViewController(HomeViewController(), title: "邻物", imageName: "邻事")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "聊天1")
        addChildViewController(personalTableViewController(), title: "我", imageName: "个人1")
        
    }
    
    //MARK: - 添加一个子控制器
    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        
        
        //添加子控制器
        //取消图片被系统自动渲染,设置原始状态代码UIImage.init(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal)
        
        //childController.tabBarItem.image = UIImage.init(named: imageName)
        childController.tabBarItem.image = UIImage.init(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal)
//        childController.tabBarItem.selectedImage = UIImage.init(named: imageName + "_highlighted")?.imageWithRenderingMode(.AlwaysOriginal)
        
        //设置自控制器的导航栏标题
        childController.title = title
        
        //包装导航控制器
        let nav = UINavigationController.init(rootViewController: childController)
        
        //将子控制器添加到UITabBarController中
        addChildViewController(nav)
    }
}

