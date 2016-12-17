//
//  fundetailViewController.swift
//  区帮
//
//  Created by apple on 2016/9/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class fundetailViewController: UITableViewController,UITextFieldDelegate{
    
    var funs:fun?
    let namelabel:UILabel = {
        let labell = UILabel()
        return labell
    }()
    let discribetextview :UITextView = {
        let textview = UITextView()
        return textview
    }()
    let imageview:UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        return image
    }()
    let topview:UIView = {
        let view = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,300))
        return view
    }()
    lazy var inputtextfield : UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "请输入您的评论。。。。"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.tableHeaderView = self.topview
        self.view.addSubview(topview)
        setupview()
        setupinputview()
        fetchdiscuss()
        super.viewDidLoad()
        
    }
    func setupview(){
        topview.addSubview(namelabel)
        topview.addSubview(discribetextview)
        topview.addSubview(imageview)
        namelabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.topview.snp_top).offset(8)
            make.left.equalTo(self.topview.snp_left).offset(20)
            make.right.equalTo(self.topview.snp_right).offset(8)
            make.height.equalTo(20)
        }
        imageview.snp_makeConstraints { (make) in
            make.top.equalTo(namelabel.snp_bottom).offset(8)
            make.left.equalTo(namelabel.snp_left)
            make.right.equalTo(topview.snp_right).offset(-20)
            make.height.equalTo(100)
            
        }
        discribetextview.snp_makeConstraints { (make) in
            make.top.equalTo(imageview.snp_bottom).offset(8)
            make.left.equalTo(imageview.snp_left)
            make.right.equalTo(imageview.snp_right)
            make.height.equalTo(100)
        }
        let imageurl = funs?.salesimageurl
        imageview.loadimageusingcachewithurlstring(imageurl!)
        discribetextview.text = funs?.detaildiscribe
        namelabel.text = funs?.title
    }
    var containerviewbottom : NSLayoutConstraint?
    func setupinputview(){
        
        let containview = UIView()
        containview.backgroundColor = UIColor.whiteColor()
        topview.addSubview(containview)
        
        let sendbutton = UIButton(type: .System)
        sendbutton.setTitle("评论", forState: .Normal)
        sendbutton.translatesAutoresizingMaskIntoConstraints = false
        containview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendbutton)
        sendbutton.addTarget(self, action: #selector(handlesend), forControlEvents: .TouchUpInside)
        sendbutton.snp_makeConstraints { (make) in
            make.right.equalTo(containview.snp_right)
            make.centerY.equalTo(containview.snp_centerY)
            make.width.equalTo(80)
            make.height.equalTo(containview.snp_height)
        }
        containview.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.topview.snp_bottom)
            make.left.equalTo(self.topview.snp_left)
            make.height.equalTo(50)
            make.width.equalTo(self.topview.snp_width)
        }
        containview.addSubview(inputtextfield)
        inputtextfield.snp_makeConstraints { (make) in
            make.left.equalTo(containview.snp_left).offset(8)
            make.centerY.equalTo(containview.snp_centerY)
            make.right.equalTo(sendbutton.snp_left)
            make.height.equalTo(containview.snp_height)
        }
        let separatorlineview = UIView()
        separatorlineview.backgroundColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        separatorlineview.translatesAutoresizingMaskIntoConstraints = false
        containview.addSubview(separatorlineview)
        separatorlineview.snp_makeConstraints { (make) in
            make.top.equalTo(containview.snp_top)
            make.left.equalTo(containview.snp_left)
            make.width.equalTo(containview.snp_width)
            make.height.equalTo(1)
        }
        let separatorlineview2 = UIView()
        separatorlineview2.backgroundColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        separatorlineview2.translatesAutoresizingMaskIntoConstraints = false
        containview.addSubview(separatorlineview2)
        separatorlineview2.snp_makeConstraints { (make) in
            make.top.equalTo(containview.snp_bottom)
            make.left.equalTo(containview.snp_left)
            make.width.equalTo(containview.snp_width)
            make.height.equalTo(1)
        }
    }
    func handlesend(){
        let name = funs?.title
        let discuss = inputtextfield.text
        let fromid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("discuss").child(name!).childByAutoId()
        let value = ["discuse":discuss!,"fromid":fromid!]
        ref.updateChildValues(value)
        self.inputtextfield.text = nil
    }
    var discusses = [discuss]()
    func fetchdiscuss(){
        let name = funs?.title
        FIRDatabase.database().reference().child("discuss").child(name!).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let Discusses = discuss()
            guard let dictionary = snapshot.value as? [String:AnyObject] else{
                return
            }
            Discusses.setValuesForKeysWithDictionary(dictionary)
            self.discusses.insert(Discusses, atIndex: 0)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            }, withCancelBlock: nil)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discusses.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle,reuseIdentifier: "cellId")
        let discuss = discusses[indexPath.row]
        if let fromid = discuss.fromid{
            let ref = FIRDatabase.database().reference().child("users").child(fromid)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    cell.detailTextLabel?.text = dictionary["name"] as? String
                }
                }, withCancelBlock: nil)
        }
        cell.textLabel?.text = discuss.discuse
        return cell
    }
    
    
    
}