//
//  persportsTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class persportsTableViewController: UITableViewController {
    var sport = [sports]()
    let cellID = "sportsCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "sportsCell",bundle:nil), forCellReuseIdentifier: cellID)
        fetchsales()
    }
    var sportdictionary = [String: sports]()
    func fetchsales(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-sports").child(uid!)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let sportID = snapshot.key
            let sportref = FIRDatabase.database().reference().child("sports").child(sportID)
            sportref.observeEventType(.Value, withBlock: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let sport = sports()
                    sport.setValuesForKeysWithDictionary(dictionary)
                    if let title = sport.title{
                        self.sportdictionary[title] = sport
                        self.sport = Array(self.sportdictionary.values)
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
        return sport.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
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
        return cell
}
}