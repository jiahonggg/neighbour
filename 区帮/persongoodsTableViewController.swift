//
//  sendTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class persongoodsTableViewController: UITableViewController {
    var sends = [send]()
    var cellID = "cellid"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "salecell",bundle:nil), forCellReuseIdentifier: cellID)
        fetchsales()
    }
    var senddictionary = [String: send]()
    func fetchsales(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-sales").child(uid!)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let saleId = snapshot.key 
            let saleref = FIRDatabase.database().reference().child("sales").child(saleId)
            saleref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let sends = send()
                    sends.setValuesForKeysWithDictionary(dictionary)
                    if let name = sends.Name{
                        self.senddictionary[name] = sends
                        self.sends = Array(self.senddictionary.values)
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
        return sends.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "cellid"
        let send = sends[indexPath.row]
        let cell :salecell = tableView.dequeueReusableCellWithIdentifier(cellID) as!salecell
        cell.namelable.text = send.Name
        if let fromid = send.fromid{
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
        if let seconds = send.timestamp?.doubleValue {
            let timestampdate = NSDate(timeIntervalSince1970: seconds)
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "YYYY-MM-DD"
            cell.timelabel.text = dateformatter.stringFromDate(timestampdate)
        }
        cell.titlelabel.text = send.Name
        cell.imageview.layer.cornerRadius = 20
        if let imageviewurl = send.salesimageurl{
            cell.imageview.loadimageusingcachewithurlstring(imageviewurl)
            
        }

        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
}
