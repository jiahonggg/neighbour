//
//  qrcodeViewController.swift
//  区帮
//
//  Created by apple on 2016/12/7.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import SnapKit
class qrcodeViewController: UIViewController {

    
    let codeimageview = UIImageView()
    let datatextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Please input Data"
        return textfield
    }()
    lazy var dataimageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "addimage")
        return imageview
    }()
    lazy var qrcodebutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("QRcode", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(qrcode), forControlEvents: .TouchUpInside )
        
        return button
    }()
    func qrcode(){
        dataimageview.image = stringtoqrcode(datatextfield.text!)
    }
    func stringtoqrcode(string : String) -> UIImage? {
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransformMakeScale(10, 10)
        let output = filter?.outputImage?.imageByApplyingTransform(transform)
        if (output != nil){
            return UIImage(CIImage: output!)
        }
        return nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(datatextfield)
        self.view.addSubview(dataimageview)
        self.view.addSubview(qrcodebutton)
        setui()
    }
    func setui (){
        
        datatextfield.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(80)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        qrcodebutton.snp_makeConstraints { (make) in
            make.top.equalTo(datatextfield)
            make.left.equalTo(datatextfield.snp_right).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        dataimageview.snp_makeConstraints { (make) in
            make.top.equalTo(datatextfield.snp_bottom).offset(80)
            make.centerX.equalTo(self.view.snp_centerX)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
    }

    
  
}
