//
//  Usercell.swift
//  区帮
//
//  Created by apple on 2016/9/25.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase


class Usercell: UITableViewCell {
    var message: Message? {
        didSet{
            setupnameandprofileimage()
            detailTextLabel?.text = message?.text
            if let seconds = message?.timestamp?.doubleValue{
                let timestampdate = NSDate(timeIntervalSince1970: seconds)
                let dateformatte = NSDateFormatter()
                dateformatte.dateFormat = "hh:mm:s a"
                 timelabel.text = dateformatte.stringFromDate(timestampdate)
            }

        }
    }
    private func setupnameandprofileimage(){
        
            if let id = message?.chatpartnerId(){
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileimageurl = dictionary["profileimageurl"]{
                        self.profileimageview.loadimageusingcachewithurlstring(profileimageurl as! String)
                    }
                }
                }, withCancelBlock: nil)
        }

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(56, textLabel!.frame.origin.y - 2, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(56, detailTextLabel!.frame.origin.y + 2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    let profileimageview : UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 20
        imageview.layer.masksToBounds = true
        return imageview
    }()
    let timelabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.darkGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileimageview)
        addSubview(timelabel)
        profileimageview.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(8)
            make.centerY.equalTo(self.snp_centerY)
            make.size.equalTo(CGSizeMake(40, 40))
        }
        timelabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right)
            make.top.equalTo(self.snp_top).offset(20)
            make.width.equalTo(100)
            make.height.equalTo((textLabel?.snp_height)!)
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

