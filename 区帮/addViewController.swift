//
//  addViewController.swift
//  区帮
//
//  Created by apple on 2016/8/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class addViewController: UIViewController ,UITabBarControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate{
    
    lazy var addimageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "addimage")
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(touchimage)))
        imageview.userInteractionEnabled = true
        return imageview
    }()
    var bottomConstraint: Constraint?
    let nametext: UITextField = {
        let name = UITextField()
        name.placeholder = "商品名称"
        name.borderStyle = UITextBorderStyle.RoundedRect
        return name
    }()
    let discribetext: UITextField = {
        let discribe = UITextField()
        discribe.placeholder = "商品描述"
        discribe.borderStyle = UITextBorderStyle.RoundedRect
        return discribe
    }()
    let jiagetext: UITextField = {
        let discribe = UITextField()
        discribe.placeholder = "商品价格"
        discribe.borderStyle = UITextBorderStyle.RoundedRect
        return discribe
    }()

    let teltext: UITextField = {
        let tel = UITextField()
        tel.placeholder = "您的电话"
        tel.borderStyle = UITextBorderStyle.RoundedRect
        return tel
    }()
    let addresstext: UITextField = {
        let address = UITextField()
        address.placeholder = "交易地址"
        address.borderStyle = UITextBorderStyle.RoundedRect
        return address
    }()
    
       override func viewDidLoad() {
        super.viewDidLoad()
        nametext.delegate = self
        teltext.delegate = self
        discribetext.delegate = self
        addresstext.delegate = self
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboard), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardwilldisappear), name: UIKeyboardDidHideNotification, object: nil)
        addviews()
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nametext.resignFirstResponder()
        teltext.resignFirstResponder()
        discribetext.resignFirstResponder()
        addresstext.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nametext.resignFirstResponder()
        teltext.resignFirstResponder()
        discribetext.resignFirstResponder()
        addresstext.resignFirstResponder()
        return true
    }
    func addviews (){
        view.addSubview(addimageview)
        addimageview.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(44)
            make.left.equalTo(self.view.snp_left).offset(40)
            make.size.equalTo(CGSizeMake(160, 160))

        }
             view.addSubview(nametext)
            nametext.snp_makeConstraints { (make) in
            make.top.equalTo(addimageview.snp_bottom).offset(40)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(120, 40))
        }
        view.addSubview(jiagetext)
        jiagetext.snp_makeConstraints { (make) in
            make.top.equalTo(nametext.snp_bottom).offset(2)
            make.left.equalTo(nametext.snp_left)
            make.size.equalTo(CGSizeMake(140, 40))
        }

        view.addSubview(discribetext)
        discribetext.snp_makeConstraints { (make) in
            make.top.equalTo(jiagetext.snp_bottom).offset(2)
            make.left.equalTo(nametext.snp_left)
            make.size.equalTo(CGSizeMake(200, 40))
        }
        
        view.addSubview(teltext)
        teltext.snp_makeConstraints { (make) in
            make.top.equalTo(discribetext.snp_bottom).offset(2)
            make.left.equalTo(nametext.snp_left)
            make.size.equalTo(CGSizeMake(200, 40))
        }
        view.addSubview(addresstext)
        addresstext.snp_makeConstraints { (make) in
            make.top.equalTo(teltext.snp_bottom).offset(2)
            make.left.equalTo(nametext.snp_left)
            make.size.equalTo(CGSizeMake(200, 40))

        }
        let send = UIButton()
        send.backgroundColor = UIColor.whiteColor()
        send.setTitle("发布", forState: UIControlState.Normal)
        send.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        view.addSubview(send)
        send.addTarget(self, action:#selector(jump), forControlEvents:.TouchUpInside)
        send.snp_makeConstraints { (make) in
            make.top.equalTo(addresstext.snp_bottom).offset(20)
            make.centerX.equalTo(self.view.snp_centerX)
            make.size.equalTo(CGSizeMake(80, 50))
        }
        }
    func keyboard (notification:NSNotification){
        addimageview.snp_updateConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(-100)
        }
    }
    
    func keyboardwilldisappear(notification:NSNotification){
        addimageview.snp_updateConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(44)
        }
    
    }
//    func keyboardWillChange(notification: NSNotification) {
//        if let userInfo = notification.userInfo,
//            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
//            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
//            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
//            
//            let frame = value.CGRectValue()
//            let intersection = CGRectIntersection(frame, self.view.frame)
//            
//            //self.view.setNeedsLayout()
//            //改变下约束
//            self.bottomConstraint?.updateOffset(-CGRectGetHeight(intersection))
//            
//            UIView.animateWithDuration(duration, delay: 0.0,
//                                       options: UIViewAnimationOptions(rawValue: curve),
//                                       animations: { _ in
//                                        self.view.layoutIfNeeded()
//                }, completion: nil)
//        }
//    }
}
