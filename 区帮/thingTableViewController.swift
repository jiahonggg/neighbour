//
//  thingTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/19.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class thingTableViewController: UITableViewController {

    let cellID = "thingcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "thingTableViewCell",bundle:nil), forCellReuseIdentifier: cellID)
        self.navigationItem.title = "社区吐槽"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        fetchthings()


    }
    var thing = [things]()
    func fetchthings(){
        FIRDatabase.database().reference().child("things").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value  as? [String:AnyObject]{
                let Thing = things()
                Thing.setValuesForKeysWithDictionary(dictionary)
                self.thing.insert(Thing, atIndex: 0)
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
        return thing.count
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let thing = self.thing[indexPath.row]
        showdetail(thing)
    }
    func showdetail(thing:things){
        let detailvc = thingdetailViewController()
        detailvc.thing = thing
        navigationController?.pushViewController(detailvc, animated: true)
        
    }


}

    

