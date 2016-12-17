//
//  personthingsTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//
import UIKit
import Firebase

class personthingsTableViewController: UITableViewController {
    var thing = [things]()
    let cellID = "thingcell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "thingTableViewCell",bundle:nil), forCellReuseIdentifier: cellID)
        fetchsales()
    }
    var thingdictionary = [String: things]()
    func fetchsales(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-things").child(uid!)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let thingID = snapshot.key
            let saleref = FIRDatabase.database().reference().child("things").child(thingID)
            saleref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let thing = things()
                    thing.setValuesForKeysWithDictionary(dictionary)
                    if let title = thing.title{
                        self.thingdictionary[title] = thing
                        self.thing = Array(self.thingdictionary.values)
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
        return thing.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "thingcell"
        let cell :thingTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! thingTableViewCell
        let Things = thing[indexPath.row]
        if let fromid = Things.fromid{
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
        if let seconds = Things.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "YYYY-MM-D"
            cell.timelabel.text = dateformatter.stringFromDate(timestampdate)
        }
        cell.titlelabel.text = Things.title
        return cell
    }
    
}
