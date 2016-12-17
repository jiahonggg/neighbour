//
//  funTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/19.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//
import UIKit
import Firebase
import Kingfisher

class funTableViewController: UITableViewController {
    
    let cellID = "sportsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "sportsCell",bundle:nil), forCellReuseIdentifier: cellID)
        self.navigationItem.title = "说走就走"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        fetchthings()
        
        
    }
    
    var funs = [fun]()
    func fetchthings(){
        FIRDatabase.database().reference().child("travels").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value  as? [String:AnyObject]{
                let funs = fun()
                funs.setValuesForKeysWithDictionary(dictionary)
                self.funs.insert(funs, atIndex: 0)
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
        return funs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "sportsCell"
        let cell :sportsCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! sportsCell
        let fun = funs[indexPath.row]
        if let fromid = fun.fromid{
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
        cell.titlelabel.text = fun.title
        cell.addresslabel.text = fun.address
        cell.numberlabel.text = fun.number
        cell.datelabel.text = fun.time
        let imageurl = fun.salesimageurl as String
        cell.sportsimage.kf_setImageWithURL(NSURL(string: imageurl)!,placeholderImage: nil)
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let funs = self.funs[indexPath.row]
        showdetail(funs)
    }
    func showdetail(funs:fun){
        let detailvc = fundetailViewController()
        detailvc.funs = funs
        navigationController?.pushViewController(detailvc, animated: true)
        
    }
    
    
}