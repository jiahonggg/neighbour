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

class helpTableViewController: UITableViewController {
    
    let cellID = "thingcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "thingTableViewCell",bundle:nil), forCellReuseIdentifier: cellID)
        self.navigationItem.title = "随缘乐助"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        fetchthings()
        
        
    }
    
    var helps = [help]()
    func fetchthings(){
        FIRDatabase.database().reference().child("helps").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value  as? [String:AnyObject]{
                let Help = help()
                Help.setValuesForKeysWithDictionary(dictionary)
                self.helps.insert(Help, atIndex: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
            }, withCancelBlock: nil)
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helps.count
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let help = self.helps[indexPath.row]
        showdetail(help)
    }
    func showdetail(helps:help){
        let detailvc = helpdetailViewController()
        detailvc.helps = helps
        navigationController?.pushViewController(detailvc, animated: true)
        
    }
    
    
}
