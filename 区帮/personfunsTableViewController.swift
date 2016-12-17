//
//  personfunsTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class personfunsTableViewController: UITableViewController {
    var funs = [fun]()
    let cellID = "thingcell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "thingTableViewCell",bundle:nil), forCellReuseIdentifier: cellID)
        fetchsales()
    }
    var fundictionary = [String: fun]()
    func fetchsales(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-travels").child(uid!)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let funID = snapshot.key
            let funpref = FIRDatabase.database().reference().child("travels").child(funID)
            funpref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let funs = fun()
                    funs.setValuesForKeysWithDictionary(dictionary)
                    if let title = funs.title{
                        self.fundictionary[title] = funs
                        self.funs = Array(self.fundictionary.values)
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
        return funs.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "thingcell"
        let cell :thingTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! thingTableViewCell
        let fun = funs[indexPath.row]
        if let fromid = fun.fromid{
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
        if let seconds = fun.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "YYYY-MM-D"
            cell.timelabel.text = dateformatter.stringFromDate(timestampdate)
        }
        cell.titlelabel.text = fun.title
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
