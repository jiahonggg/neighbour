//
//  perhelpsTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class perhelpTableViewController: UITableViewController {
    var helps = [help]()
    let cellID = "thingcell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "thingTableViewCell",bundle:nil), forCellReuseIdentifier: cellID)
        fetchsales()
    }
    var helpdictionary = [String: help]()
    func fetchsales(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-helps").child(uid!)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let helpID = snapshot.key
            let shelpref = FIRDatabase.database().reference().child("helps").child(helpID)
            shelpref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let helps = help()
                    helps.setValuesForKeysWithDictionary(dictionary)
                    if let title = helps.title{
                        self.helpdictionary[title] = helps
                        self.helps = Array(self.helpdictionary.values)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return helps.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "thingcell"
        let cell :thingTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! thingTableViewCell
        let help = helps[indexPath.row]
        if let fromid = help.fromid{
            let ref = FIRDatabase.database().reference().child("users").child(fromid)
            ref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    cell.namelabel.text = dictionary["name"] as? String
                    let imageurl = dictionary["profileimageurl"] as? String
                    cell.profleimage.kf_setImageWithURL(NSURL(string: imageurl!)!)
                    cell.profleimage.layer.cornerRadius = 14
                    cell.profleimage.layer.masksToBounds = true
                    
                }
                }, withCancelBlock: nil)
        }
        if let seconds = help.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "YYYY-MM-D"
            cell.timelabel.text = dateformatter.stringFromDate(timestampdate)
        }
        cell.titlelabel.text = help.title
        return cell
    }
    
}
