//
//  chatTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/24.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class chatTableViewController: UICollectionViewController, UITextFieldDelegate {

    var users:User?
    var sale: sales?
    lazy var inputtextfield : UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Enter message..."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        fetchuser()
        setupinputview()
        
    }
    func setupinputview(){
        let containview = UIView()
        view.addSubview(containview)
        
        let sendbutton = UIButton(type: .System)
        sendbutton.setTitle("Send", forState: .Normal)
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
                make.bottom.equalTo(self.view.snp_bottom).offset(-44)
                make.left.equalTo(self.view.snp_left)
                make.height.equalTo(50)
                make.width.equalTo(self.view.snp_width)
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
        
    }
    func fetchuser(){
       
        let fromid = sale?.fromid
        FIRDatabase.database().reference().child("users").child(fromid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                print(dictionary)
            self.navigationItem.title = dictionary["name"] as? String
            
            }
            }, withCancelBlock: nil)
    }
    func handlesend(){
        let toid = sale?.fromid
        let fromuid = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = NSDate().timeIntervalSince1970
            let ref = FIRDatabase.database().reference().child("message").childByAutoId()
            let values = ["text":inputtextfield.text!,"toid":toid!,"fromuid":fromuid,"timestamp":timestamp]
            ref.updateChildValues(values)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handlesend()
        return true
    }
}









