//
//  personalTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/18.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class personalTableViewController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var persondataarray = ["👤个人资料","我的物品","我的求助","我的好事","我的旅游","我的运动","我的拼车","收藏"]
    var cellid = "cellid"
    let headview: UIView = {
        let view = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width,220))
        return view
    }()
    let profileimageview :UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"profileimage")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 40
        imageview.layer.masksToBounds = true
        imageview.contentMode = .ScaleAspectFill
        return imageview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.headview.addSubview(profileimageview)
        initheadview()
        addprofileview()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登出",style: .Plain,target: self,action: #selector(logout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册／登录",style: .Plain,target: self,action: #selector(login))
        checkuser()
    }
    func logout(){
        do {
            try FIRAuth.auth()?.signOut()
            self.navigationItem.title = "我"
        }catch let logoutError{
            print(logoutError)
        }

    }
    func checkuser(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(login), withObject: nil, afterDelay: 0)
        }else{
            fetchuserandsetnavigationtitle()
        }
    }
    func fetchuserandsetnavigationtitle(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
                self.navigationItem.title = dictionary["name"] as? String
                let imageurl = dictionary["profileimageurl"] as? String
                self.profileimageview.kf_setImageWithURL(NSURL(string: imageurl!)!,placeholderImage:nil)
                
            }
            }, withCancelBlock: nil)
    }
    func login(){
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let logincontroller = loginViewController()
        let messagecontroll = MessageTableViewController()
        logincontroller.messageTableViewControll = messagecontroll
        logincontroller.personalTableViewControll = self
        presentViewController(logincontroller, animated: true, completion: nil)
    }
    func initheadview(){
        headview.backgroundColor = UIColor.whiteColor()
        self.tableView.tableHeaderView = self.headview
    }
    func addprofileview(){
        profileimageview.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(80, 80))
            make.centerX.equalTo(headview.snp_centerX)
            make.centerY.equalTo(headview.snp_centerY)
        }
 
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persondataarray.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle,reuseIdentifier: cellid)
        cell.textLabel?.text = persondataarray[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row as Int
        if row == 0{
            let personalpage = personalpageViewController()
            navigationController?.pushViewController(personalpage, animated: true)
        }
        
        if row == 1{
            let send = persongoodsTableViewController()
            navigationController?.pushViewController(send, animated: true)
        }
        if row == 2{
            let send = perhelpTableViewController()
            navigationController?.pushViewController(send, animated: true)
        }

        if row == 3{
            let thing = personthingsTableViewController()
            navigationController?.pushViewController(thing, animated: true)
        }
        if row == 4{
            let thing = personfunsTableViewController()
            navigationController?.pushViewController(thing, animated: true)
        }
        if row == 5{
            let thing = persportsTableViewController()
            navigationController?.pushViewController(thing, animated: true)
        }
        if row == 6{
            let thing = persportsTableViewController()
            navigationController?.pushViewController(thing, animated: true)
        }
    }
        
}








