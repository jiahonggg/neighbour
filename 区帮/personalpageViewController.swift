//
//  personalpageViewController.swift
//  区帮
//
//  Created by apple on 2016/9/19.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import ActionButton

class personalpageViewController: UIViewController {

    let namelabel :UILabel = {
        let label = UILabel()
        label.text = "Name "
        return label
    }()
    let nametextview : UITextView = {
        let textview = UITextView()
        return textview
    }()
    let profileimageview :UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"profileimage")
        imageview.layer.cornerRadius = 50
        imageview.layer.masksToBounds = true
        return imageview
    }()
    let nameseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    let emailseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    let emaillabel :UILabel = {
        let label = UILabel()
        label.text = "Email "
        return label
    }()
    let emailtextview : UITextView = {
        let textview = UITextView()
        return textview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(profileimageview)
        self.view.addSubview(namelabel)
        self.view.addSubview(nametextview)
        self.view.addSubview(nameseparatorview)
        self.view.addSubview(emaillabel)
        self.view.addSubview(emailtextview)
        self.view.addSubview(emailseparatorview)
        fetchuser()
        setupui()
        
    }
        func fetchuser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
                return
            }
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                    self.nametextview.text = dictionary["name"] as? String
                    self.emailtextview.text = dictionary["email"] as?String
                }
                }, withCancelBlock: nil)

    }
    func setupui(){
        profileimageview.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(self.view.snp_centerX)
            make.top.equalTo(self.view.snp_top).offset(80)
        }
        namelabel.snp_makeConstraints { (make) in
            make.top.equalTo(profileimageview.snp_bottom).offset(40)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        nametextview.snp_makeConstraints { (make) in
            make.top.equalTo(namelabel.snp_top)
            make.left.equalTo(namelabel.snp_right)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(26)
        }
        nameseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(nametextview.snp_bottom)
            make.left.equalTo(namelabel.snp_left)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(1)
        }
        emaillabel.snp_makeConstraints { (make) in
            make.top.equalTo(nametextview.snp_bottom).offset(4)
            make.left.equalTo(namelabel.snp_left)
            make.width.equalTo(namelabel.snp_width)
            make.height.equalTo(namelabel.snp_height)
        }
        emailtextview.snp_makeConstraints { (make) in
            make.top.equalTo(nametextview.snp_bottom).offset(4)
            make.width.equalTo(nametextview)
            make.height.equalTo(nametextview)
            make.left.equalTo(nametextview.snp_left)
        }
        emailseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(emailtextview.snp_bottom)
            make.left.equalTo(emaillabel.snp_left)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(1)
        }
    }

   
}
