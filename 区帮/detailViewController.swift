//
//  detailViewController.swift
//  区帮
//
//  Created by apple on 2016/8/27.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class detailViewController: UIViewController {

    var sale: sales?
    var thing: things?
    let imageview:UIImageView = {
        let imegaview = UIImageView()
        return imegaview
    }()
    let namelabel:UILabel = {
        let labell = UILabel()
        return labell
    }()
    let titlelabel:UILabel = {
        let labell = UILabel()
        return labell
    }()

    let discribtextview:UITextView = {
        let labell = UITextView()
        return labell
    }()
    let addresslabel:UILabel = {
        let labell = UILabel()
        return labell
    }()
    let pricelabell:UILabel = {
        let label = UILabel()
        return label
    }()
    let tellabell:UILabel = {
        let label = UILabel()
        return label
    }()
    let profileimageview:UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        return image
    }()
    lazy var getbutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.darkGrayColor()
        button.setTitle("获取联系方式", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action:#selector(showtel), forControlEvents: .TouchUpInside)
        return button
    }()
    lazy var chatbutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("chat", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action:#selector(showchat), forControlEvents: .TouchUpInside)
        return button
    }()
    func showchat(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            let logincontroll = loginViewController()
            self.navigationController?.pushViewController(logincontroll, animated: true)
        }else {
//            let fromid = sale?.fromid
            showchatlog(sale!)
            
        }

    }
    func showchatlog(sale:sales){
        let chatcontroller = chatTableViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatcontroller.sale = sale
        self.navigationController?.pushViewController(chatcontroller, animated: true)
    }
    func showtel() {
        if FIRAuth.auth()?.currentUser?.uid == nil{
            let logincontroll = loginViewController()
            self.navigationController?.pushViewController(logincontroll, animated: true)
        }else {
            tellabell.text = "Tel:"+(sale?.Tel)!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(imageview)
        self.view.addSubview(titlelabel)
        self.view.addSubview(namelabel)
        self.view.addSubview(pricelabell)
        self.view.addSubview(discribtextview)
        self.view.addSubview(tellabell)
        self.view.addSubview(getbutton)
        self.view.addSubview(chatbutton)
        self.view.addSubview(profileimageview)
        setupview()
        // Do any additional setup after loading the view.
    }
    
    func setupview(){
        imageview.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(70)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(250)
        }
        fetchimage()
        titlelabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageview.snp_bottom).offset(20)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.height.equalTo(20)
        }
        titlelabel.text = sale?.Name
        titlelabel.highlighted = true
        titlelabel.font = UIFont.systemFontOfSize(20)
        profileimageview.snp_makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        namelabel.snp_makeConstraints { (make) in
            make.top.equalTo(titlelabel.snp_bottom).offset(10)
            make.left.equalTo(profileimageview.snp_right).offset(6)
            make.height.equalTo(20)
        }
        pricelabell.text = "价格："+(sale?.price)!+"_NT"
        pricelabell.snp_makeConstraints { (make) in
            pricelabell.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(namelabel.snp_bottom).offset(10)
                make.left.equalTo(namelabel)
                make.height.equalTo(20)
                pricelabell.textColor = UIColor.init(red: 60/255, green: 179/255, blue: 113/255, alpha: 1)
            })
        }
        discribtextview.snp_makeConstraints { (make) in
            make.top.equalTo(pricelabell.snp_bottom).offset(10)
            make.left.equalTo(namelabel.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(80)
        }
        discribtextview.text = sale?.Discribe
        discribtextview.font = UIFont.systemFontOfSize(16)
        discribtextview.textColor = UIColor.blackColor()
        if let fromid = sale!.fromid{
            let ref = FIRDatabase.database().reference().child("users").child(fromid)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.namelabel.text = dictionary["name"] as? String
                    self.namelabel.font = UIFont.systemFontOfSize(13)
                    self.namelabel.textColor = UIColor.blueColor()
                    let imageurl = dictionary["profileimageurl"] as! String
                    self.profileimageview.kf_setImageWithURL(NSURL(string: imageurl)!)
                }
                }, withCancelBlock: nil)
        }
        tellabell.snp_makeConstraints { (make) in
            make.top.equalTo(discribtextview.snp_bottom).offset(8)
            make.left.equalTo(discribtextview.snp_left)
            make.size.equalTo(namelabel.snp_size)
        }
        getbutton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-40)
            make.height.equalTo(50)
            make.width.equalTo(self.view.snp_width)
        }
        chatbutton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(getbutton.snp_top).offset(-4)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
    func fetchimage(){
        if let imageviewurl = sale!.salesimageurl{
            let url = NSURL(string: imageviewurl)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageview.image = UIImage(data: data!)
                })
            }).resume()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
