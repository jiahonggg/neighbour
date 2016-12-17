//
//  addthingsViewController.swift
//  区帮
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class addthingsViewController: UIViewController , UITextViewDelegate{
    
    let titletextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Please input Title"
        return textfield
    }()
    let discribetextview : UITextView = {
        let textview = UITextView()
        textview.text = "Discribe"
        textview.textColor = UIColor.lightGrayColor()
        return textview
    }()
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "Discribe"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    let titleseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let bottomseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftshortseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var sendbutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("发布", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        button.addTarget(self, action:#selector(sendthings), forControlEvents: .TouchUpInside)
        return button
    }()
    func sendthings(){
        let title = titletextfield.text
        let detaildiscribe = discribetextview.text
        let fromid = FIRAuth.auth()?.currentUser?.uid
        let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
        let ref = FIRDatabase.database().reference().child("things").childByAutoId()
        let things :[String: AnyObject] = ["title":title!,
                                            "detaildiscribe":detaildiscribe,
                                            "fromid":fromid!,
                                            "timestamp":timestamp]
        ref.setValue(things)
        let usersaleref = FIRDatabase.database().reference().child("user-things").child(fromid!)
        let saleId = ref.key
        usersaleref.updateChildValues([saleId:1])
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(titletextfield)
        self.view.addSubview(titleseparatorview)
        self.view.addSubview(discribetextview)
        self.view.addSubview(leftseparatorview)
        self.view.addSubview(rightseparatorview)
        self.view.addSubview(bottomseparatorview)
        self.view.addSubview(leftshortseparatorview)
        self.view.addSubview(sendbutton)
        discribetextview.delegate = self
        self.navigationItem.title = "发现新鲜事"
        
        setupui()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setupui(){
        titletextfield.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.top.equalTo(self.view.snp_top).offset(64)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(40)
        }
        titleseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titletextfield.snp_bottom)
            make.left.equalTo(titletextfield.snp_left)
            make.width.equalTo(titletextfield.snp_width)
            make.height.equalTo(2)
        }
        discribetextview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(titleseparatorview.snp_width)
            make.height.equalTo(300)
        }
        leftseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(2)
            make.height.equalTo(200)
        }
        rightseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.right.equalTo(titleseparatorview.snp_right)
            make.width.equalTo(2)
            make.height.equalTo(200)
        }
        bottomseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(leftseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(2)
        }
        leftshortseparatorview.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.top.equalTo(self.view.snp_top)
            make.width.equalTo(2)
            make.height.equalTo(40)
        }
        sendbutton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-80)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }


    }

}




