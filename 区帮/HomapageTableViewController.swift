//
//  HomapageTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/24.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import ActionButton
import SnapKit
import Kingfisher
import Firebase
import MJRefresh
class HomapageTableViewController: UITableViewController {
    let thingimage = UIImageView()
    var sale = [sales]()
    var cellID = "cellid"
    var actionbutton: ActionButton!
    lazy var thingbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "事情"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(thing), forControlEvents: .TouchUpInside)
        return button
    }()
    func thing(){
        navigationController?.pushViewController(thingTableViewController(), animated: true)
    }
    lazy var goodsbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "二手(1)"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 0/255, green: 229/255, blue: 238/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(goods), forControlEvents: .TouchUpInside)
        return button
    }()
    func goods(){
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    lazy var helpbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "帮忙(1)"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(help), forControlEvents: .TouchUpInside)
        return button
    }()
    func help(){
        navigationController?.pushViewController(helpTableViewController(), animated: true)
    }
    lazy var funbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "旅游(1)"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(fun), forControlEvents: .TouchUpInside)
        
        return button
    }()
    func fun(){
        navigationController?.pushViewController(funTableViewController(), animated: true)
    }
    lazy var sportsbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "运动(1)"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(sports), forControlEvents: .TouchUpInside)
        return button
    }()
    func sports(){
        navigationController?.pushViewController(sportsTableViewController(), animated: true)
    }
    lazy var carbutton:UIButton = {
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(named: "拼车(1)"), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.init(red: 125/255, green: 255/255, blue: 0/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
//        button.layer.cornerRadius = 40
//        button.layer.masksToBounds = true
//        button.layer.borderColor = UIColor.blackColor().CGColor
//        button.layer.borderWidth = 2;
        button.addTarget(self, action:#selector(car), forControlEvents: .TouchUpInside)
        
        return button
    }()
    func car(){
        navigationController?.pushViewController(carTableViewController(), animated: true)
    }
    let headview:UIView = {
        let headview = UIView(frame:CGRectMake(0,0,UIScreen.mainScreen().bounds.width,1100))
        return headview
    }()
    let imageview:UIImageView = {
        let imageview = UIImageView(frame:CGRectMake(0,0,UIScreen.mainScreen().bounds.width,300))
        imageview.image = UIImage(named:"公告图4")
        return imageview
    }()
    lazy var bottomview : UIImageView = {
        let titleview = UIImageView()
        titleview.layer.cornerRadius = 20
        titleview.layer.masksToBounds = true
        titleview.layer.borderColor = UIColor.yellowColor().CGColor
        titleview.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(touchimage)))
        titleview.userInteractionEnabled = true
        titleview.layer.borderWidth = 2
        return titleview
    }()
//    let separatorview1 : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.init(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
//        return view
//    }()
//    let separatorview2 : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.init(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
//        return view
//    }()
    let separatorview : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    let separatorview3 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        return view
    }()
    let toutiaoimageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"头条标签")
        return imageview
    }()
    let toplabel1 : UILabel = {
        let label = UILabel()
        label.font = label.font.fontWithSize(16)
        return label
    }()
    let toplabel2 : UILabel = {
        let label = UILabel()
        label.font = label.font.fontWithSize(16)
        return label
    }()

//    let wulabel: UILabel = {
//        let label = UILabel()
//        label.text = "二手"
//        return label
//    }()
//    let shilabel: UILabel = {
//        let label = UILabel()
//        label.text = "事情"
//        return label
//    }()
//    let banglabel: UILabel = {
//        let label = UILabel()
//        label.text = "互帮"
//        return label
//    }()
//    let wanlabel: UILabel = {
//        let label = UILabel()
//        label.text = "旅游"
//        return label
//    }()
//    let donglabel: UILabel = {
//        let label = UILabel()
//        label.text = "运动"
//        return label
//    }()
//    let carlabel: UILabel = {
//        let label = UILabel()
//        label.text = "拼车"
//        return label
//    }()
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫描",style: .Plain,target: self,action: #selector(jump))
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableHeaderView = headview
        tableView.registerNib(UINib(nibName: "salecell",bundle:nil), forCellReuseIdentifier: cellID)
        self.headview.addSubview(imageview)
        self.headview.addSubview(thingbutton)
        self.headview.addSubview(goodsbutton)
        self.headview.addSubview(helpbutton)
        self.headview.addSubview(funbutton)
        self.headview.addSubview(sportsbutton)
        self.headview.addSubview(carbutton)
        self.headview.addSubview(bottomview)
        self.headview.addSubview(separatorview3)
        self.headview.addSubview(separatorview)
        self.headview.addSubview(toutiaoimageview)
        self.headview.addSubview(toplabel1)
        self.headview.addSubview(toplabel2)
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
        setupbutton()
        addactionbutton()
        fetchimageurl()
        fetchhot()
        fetchheadline()
    }
    func jump(){
        navigationController?.pushViewController(qrcodeViewController(), animated: true)
        
    }
    func touchimage(){
        let market = supermarketController(collectionViewLayout:UICollectionViewFlowLayout())
        navigationController?.pushViewController(market, animated: true)
    }
    func addactionbutton(){
        let thing = ActionButtonItem(title: "发好事", image: UIImage(named: "小事"))
        thing.action = { item in
            
            let addcontroller = addthingsViewController()
            self.navigationController?.pushViewController(addcontroller, animated: true)
        }
        
        let help = ActionButtonItem(title: "求帮忙", image: UIImage(named: "小帮"))
        help.action = { item in
            
            
            let addcontroller = addhelpViewController()
            self.navigationController?.pushViewController(addcontroller, animated: true)
            
        }
        let fun = ActionButtonItem(title: "去拼车", image: UIImage(named: "小车"))
        fun.action = { item in
            
            
            let addcontroller = addcarsViewController()
            self.navigationController?.pushViewController(addcontroller, animated: true)
            
        }
        let sports = ActionButtonItem(title: "约运动", image: UIImage(named: "小动"))
        sports.action = { item in
            
            
            let addcontroller = addsportsViewController()
            self.navigationController?.pushViewController(addcontroller, animated: true)
            
        }
        let goods = ActionButtonItem(title: "发好物", image: UIImage(named: "小物"))
        goods.action = { item in
            
            
            let three = addViewController()
            self.navigationController?.pushViewController(three, animated: true)
            
        }
        let travel = ActionButtonItem(title: "约出游", image: UIImage(named: "小旅"))
        travel.action = { item in
            
            
            let three = addfunsViewController()
            self.navigationController?.pushViewController(three, animated: true)
            
        }
        actionbutton = ActionButton(attachedToView: headview, items: [thing, help,fun,sports,goods,travel])
        actionbutton.action = { button in button.toggleMenu() }
    }
    func fetchheadline(){
        FIRDatabase.database().reference().child("headline").child("line1").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let text = snapshot.value as? String{
                self.toplabel1.text = "⭐️" + (text)
            }
        }, withCancelBlock: nil)
        FIRDatabase.database().reference().child("headline").child("line2").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let text = snapshot.value as? String{
                self.toplabel2.text = "⭐️" + (text)

            }
            }, withCancelBlock: nil)
    }
    func setupbutton(){
        helpbutton.snp_makeConstraints { (make) in
            make.top.equalTo(imageview.snp_bottom).offset(100)
            make.left.equalTo(self.headview.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(167, 170))
        }
        thingbutton.snp_makeConstraints { (make) in
            make.top.equalTo(imageview.snp_bottom).offset(100)
            make.right.equalTo(self.headview.snp_right).offset(-20)
            make.size.equalTo(CGSizeMake(167, 170))
        }
        goodsbutton.snp_makeConstraints { (make) in
            make.top.equalTo(helpbutton.snp_bottom)
            make.left.equalTo(self.headview.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(167, 170))
        }
        sportsbutton.snp_makeConstraints { (make) in
            make.top.equalTo(thingbutton.snp_bottom)
            make.right.equalTo(self.headview.snp_right).offset(-20)
            make.size.equalTo(CGSizeMake(167, 170))
        }
        funbutton.snp_makeConstraints { (make) in
            make.top.equalTo(goodsbutton.snp_bottom)
            make.left.equalTo(self.headview.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(167, 170))
        }
        carbutton.snp_makeConstraints { (make) in
            make.top.equalTo(sportsbutton.snp_bottom)
            make.right.equalTo(self.headview.snp_right).offset(-20)
            make.size.equalTo(CGSizeMake(167, 170))
        }

        bottomview.snp_makeConstraints { (make) in
            make.top.equalTo(funbutton.snp_bottom).offset(40)
            make.left.equalTo(self.headview.snp_left).offset(40)
            make.right.equalTo(self.headview.snp_right).offset(-40)
            make.bottom.equalTo(headview.snp_bottom).offset(-20)
        }
//        separatorview1.snp_makeConstraints { (make) in
//            make.top.equalTo(helpbutton.snp_bottom).offset(20)
//            make.left.equalTo(headview.snp_left)
//            make.right.equalTo(headview.snp_right)
//            make.height.equalTo(16)
//        }
//        separatorview2.snp_makeConstraints { (make) in
//            make.top.equalTo(goodsbutton.snp_bottom).offset(20)
//            make.left.equalTo(headview.snp_left)
//            make.right.equalTo(headview.snp_right)
//            make.height.equalTo(16)
//        }
        separatorview.snp_makeConstraints { (make) in
            make.top.equalTo(funbutton.snp_bottom).offset(20)
            make.left.equalTo(headview.snp_left)
            make.right.equalTo(headview.snp_right)
            make.height.equalTo(16)
        }
        separatorview3.snp_makeConstraints { (make) in
            make.top.equalTo(imageview.snp_bottom).offset(8)
            make.left.equalTo(headview.snp_left)
            make.right.equalTo(headview.snp_right)
            make.height.equalTo(50)
        }
        toutiaoimageview.snp_makeConstraints { (make) in
            make.left.equalTo(separatorview3.snp_left)
            make.top.equalTo(separatorview3.snp_top)
            make.size.equalTo(CGSizeMake(50, 50))
        }
        
        toplabel1.snp_makeConstraints { (make) in
            make.left.equalTo(toutiaoimageview.snp_right).offset(10)
            make.top.equalTo(separatorview3.snp_top).offset(4)
            make.right.equalTo(separatorview3.snp_right)
            make.height.equalTo(20)
        }
        toplabel2.snp_makeConstraints { (make) in
            make.left.equalTo(toutiaoimageview.snp_right).offset(10)
            make.top.equalTo(toplabel1.snp_bottom).offset(4)
            make.right.equalTo(separatorview3.snp_right)
            make.height.equalTo(20)
        }
//        wulabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(goodsbutton.snp_centerX)
//            make.top.equalTo(goodsbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
//        shilabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(thingbutton.snp_centerX)
//            make.top.equalTo(thingbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
//        banglabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(helpbutton.snp_centerX)
//            make.top.equalTo(helpbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
//        wanlabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(funbutton.snp_centerX)
//            make.top.equalTo(funbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
//        donglabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(sportsbutton.snp_centerX)
//            make.top.equalTo(sportsbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
//        carlabel.snp_makeConstraints { (make) in
//            make.centerX.equalTo(carbutton.snp_centerX)
//            make.top.equalTo(carbutton.snp_bottom).offset(8)
//            make.size.equalTo(CGSizeMake(40, 20))
//        }
    }
    func fetchhot(){
        let ref = FIRDatabase.database().reference().child("hottitle")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let sale = sales()
                sale.setValuesForKeysWithDictionary(dictionary)
                self.sale.insert(sale, atIndex: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            }, withCancelBlock: nil)
    }
    func fetchimageurl(){
        FIRDatabase.database().reference().child("homeimage").child("topimage").observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            if let imageurl = snapshot.value {
                self.imageview.kf_setImageWithURL(NSURL(string: imageurl as! String)!,placeholderImage:nil)
            }
            }, withCancelBlock: nil)
        FIRDatabase.database().reference().child("homeimage").child("bottomimage").observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            if let imageurl = snapshot.value {
                self.bottomview.kf_setImageWithURL(NSURL(string: imageurl as! String)!,placeholderImage:nil)
            }
            }, withCancelBlock: nil)

    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y>0{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
      override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sale.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellid"
        let cell :salecell = tableView.dequeueReusableCellWithIdentifier(cellID) as!salecell
        let sales = sale[indexPath.row]
        if let fromid = sales.fromid{
            let ref = FIRDatabase.database().reference().child("users").child(fromid)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    cell.namelable.text = dictionary["name"] as? String
                    let imageurl = dictionary["profileimageurl"] as? String
                    cell.profileimage.kf_setImageWithURL(NSURL(string: imageurl!)!)
                    cell.profileimage.layer.cornerRadius = 14
                    cell.profileimage.layer.masksToBounds = true
                    
                }
                }, withCancelBlock: nil)
        }
        if let seconds = sales.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "YYYY-MM-DD"
            cell.timelabel.text = dateformatter.stringFromDate(timestampdate)
        }
        cell.titlelabel.text = sales.Name
        cell.pricelabel.text = sales.price! + "_NT"
        cell.imageview.layer.cornerRadius = 20
        if let imageviewurl = sales.salesimageurl{
            cell.imageview.loadimageusingcachewithurlstring(imageviewurl)
            
        }
        
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        let sale = self.sale[indexPath.row]
        showdetail(sale)
    }
    func showdetail(sale:sales){
        let detailvc = detailViewController()
        detailvc.sale = sale
        navigationController?.pushViewController(detailvc, animated: true)
        
    }


}
