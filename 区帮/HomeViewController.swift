//
//  HomeViewController.swift
//  区帮
//
//  Created by apple on 2016/8/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import SnapKit
import NetworkExtension
import Firebase
import SafariServices
import Kingfisher

class HomeViewController: UITableViewController {
    let cellID = "cellid"
    var sale = [sales]()
    let view1 = UIView()
    var count = Int()
    var value: [AnyObject] = []
    lazy var scrollview: UIScrollView = {
        let view1 = UIScrollView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,150))
        view1.contentSize = CGSizeMake(5*UIScreen.mainScreen().bounds.size.width, 150)
        view1.pagingEnabled = true
        view1.delegate = self
        view1.bounces = false
        view1.showsHorizontalScrollIndicator = false
     return view1
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.navigationItem.title = "邻里置换"
        tableView.registerNib(UINib(nibName: "salecell",bundle:nil), forCellReuseIdentifier: cellID)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        initView()
        fetchsale()
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
    func fetchsale (){
        
                FIRDatabase.database().reference().child("sales").observeEventType(.ChildAdded, withBlock: { (snapshot) in
                    
                  if let dictionary = snapshot.value as?[String:AnyObject]{
                    let sale = sales()
                    sale.setValuesForKeysWithDictionary(dictionary)
                    self.sale.insert(sale, atIndex: 0)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
                
                }, withCancelBlock: nil)
       
    }
    func initView(){
        let image_W:CGFloat = UIScreen.mainScreen().bounds.size.width
        let image_H:CGFloat = self.scrollview.bounds.size.height
        let image_Y:CGFloat = 0
        let totalCount:NSInteger = 5
        for index in 0..<totalCount{
            let imageView:UIImageView = UIImageView()
            let image_X:CGFloat = CGFloat(index) * image_W
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            imageView.frame = CGRectMake(image_X, image_Y, image_W, image_H)
            imageView.image = UIImage(named: "image\(index+1)")
            self.scrollview.showsHorizontalScrollIndicator = false
            self.scrollview.addSubview(imageView)
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(touchimage)))
            imageView.userInteractionEnabled = true
        }
               self.tableView.tableHeaderView = self.scrollview
      
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
        cell.pricelabel.text = sales.price! + "_NT"
        cell.titlelabel.text = sales.Name
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



