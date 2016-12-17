//
//  orderViewController.swift
//  区帮
//
//  Created by apple on 2016/10/5.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class orderViewController: UIViewController, UITextViewDelegate{

    let discribetextview : UITextView = {
        let textview = UITextView()
        textview.text = "请输入您需要的商品与数量。。。"
        textview.layer.borderColor = UIColor.lightGrayColor().CGColor
        textview.layer.borderWidth = 2
        textview.textColor = UIColor.lightGrayColor()
        return textview
    }()
    let addresstextfield : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "请输入您的送货地址。。"
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.lightGrayColor().CGColor
        return textfield
    }()
    lazy var sendbutton : UIButton = {
        let button = UIButton()
        button.setTitle("send", forState: .Normal)
        button.addTarget(self, action: #selector(send), forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.blueColor()
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        return button
    }()
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "请输入您需要的商品与数量。。。"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(addresstextfield)
        self.view.addSubview(discribetextview)
        self.view.addSubview(sendbutton)
        discribetextview.delegate = self
        setupui()
    }
    func setupui(){
        addresstextfield.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(80)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.right.equalTo(self.view.snp_right).offset(-20)
            make.height.equalTo(30)
        }
        discribetextview.snp_makeConstraints { (make) in
            make.top.equalTo(addresstextfield.snp_bottom).offset(8)
            make.left.equalTo(addresstextfield.snp_left)
            make.right.equalTo(addresstextfield.snp_right)
            make.height.equalTo(100)
        }
        sendbutton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(discribetextview.snp_bottom).offset(80)
            make.size.equalTo(CGSizeMake(80, 80))
        }
    }
    func send (){
        let address = addresstextfield.text
        let discribe = discribetextview.text
        let fromid = FIRAuth.auth()?.currentUser?.uid
        let value :[String:AnyObject] = ["address":address!,
                                         "discribe":discribe!,
                                         "fromid":fromid!]
        let ref = FIRDatabase.database().reference().child("order").childByAutoId()
        ref.setValue(value)
        navigationController?.popViewControllerAnimated(true)
    }

 
}





