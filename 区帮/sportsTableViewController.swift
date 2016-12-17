//
//  helpTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/19.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class sportsTableViewController: UITableViewController {
    
    let cellID = "sportsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "sportsCell",bundle:nil), forCellReuseIdentifier: cellID)
        self.navigationItem.title = "飞扬运动"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        fetchthings()
        
        
    }
    
    var sport = [sports]()
    func fetchthings(){
        FIRDatabase.database().reference().child("sports").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value  as? [String:AnyObject]{
                let Sport = sports()
                Sport.setValuesForKeysWithDictionary(dictionary)
                self.sport.insert(Sport, atIndex: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
            }, withCancelBlock: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sport.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "sportsCell"
        let cell :sportsCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! sportsCell
        let sports = sport[indexPath.row]
        if let fromid = sports.fromid{
            let ref = FIRDatabase.database().reference().child("users").child(fromid)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let imageurl = dictionary["profileimageurl"] as? String
                    cell.profileimage.kf_setImageWithURL(NSURL(string: imageurl!)!)
                    cell.profileimage.layer.cornerRadius = 14
                    cell.profileimage.layer.masksToBounds = true
                    
                }
                }, withCancelBlock: nil)
        }
        cell.titlelabel.text = sports.title
        cell.addresslabel.text = sports.address
        cell.numberlabel.text = sports.number + "人"
        cell.datelabel.text = sports.time
        let imageurl = sports.salesimageurl as String
        cell.sportsimage.kf_setImageWithURL(NSURL(string: imageurl)!,placeholderImage: nil)
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let sport = self.sport[indexPath.row]
        showdetail(sport)
    }
    func showdetail(sport:sports){
        let detailvc = sportsdetailViewController()
        detailvc.sport = sport
        navigationController?.pushViewController(detailvc, animated: true)
        
    }
    
    
}