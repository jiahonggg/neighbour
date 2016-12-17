//
//  chatmessagecell.swift
//  区帮
//
//  Created by apple on 2016/9/26.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import SnapKit

class chatmessagecell: UICollectionViewCell {
    
    var chatlogcontroll : chatlogViewController?
    
    let textview : UITextView = {
        let tv = UITextView()
        tv.text = "sample"
        tv.font = UIFont.systemFontOfSize(16)
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.whiteColor()
        return tv
    }()
    let bubbleview : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    let profileimageview : UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 16
        imageview.layer.masksToBounds = true
        imageview.contentMode = .ScaleAspectFill
        return imageview
    }()
    lazy var messageimage:UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 16
        imageview.layer.masksToBounds = true
        imageview.contentMode = .ScaleAspectFill
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(hendletouch)))
        imageview.userInteractionEnabled = true
        return imageview

    }()
    func hendletouch(tapgesture:UITapGestureRecognizer){
        if let imageview = tapgesture.view as? UIImageView{
            self.chatlogcontroll?.performzoom(imageview)
        }
        
    }
    
    
    
    
    static let bluecolor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
    var bubblewidth : NSLayoutConstraint?
    var bubbleviewrightanchor: NSLayoutConstraint?
    var bubbleviewleftanchor: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleview)
        addSubview(textview)
        addSubview(profileimageview)
        addSubview(messageimage)
        profileimageview.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(8)
            make.bottom.equalTo(self.snp_bottom)
            make.width.equalTo(32)
            make.height.equalTo(32)
            
        }
        textview.snp_makeConstraints { (make) in
            make.left.equalTo(bubbleview.snp_left).offset(8)
            make.top.equalTo(self.snp_top)
            make.width.equalTo(200)
            make.right.equalTo(bubbleview.snp_right)
            make.height.equalTo(self.snp_height)
        }
        bubbleview.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top)
            make.height.equalTo(self.snp_height)
            
        }
        messageimage.snp_makeConstraints { (make) in
            make.edges.equalTo(bubbleview.snp_edges)
        }
        bubbleviewrightanchor = bubbleview.rightAnchor.constraintEqualToAnchor(self.rightAnchor,constant: -8)
        bubbleviewrightanchor?.active = true
        
        bubbleviewleftanchor = bubbleview.leftAnchor.constraintEqualToAnchor(profileimageview.rightAnchor,constant: 8)
//        bubbleviewleftanchor?.active = false
        bubblewidth = bubbleview.widthAnchor.constraintEqualToConstant(200)
        bubblewidth?.active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
