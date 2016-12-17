//
//  carTableViewController.swift
//  区帮
//
//  Created by apple on 2016/10/1.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class carTableViewController: UITableViewController {
    
    let cellID = "sportsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "sportsCell",bundle:nil), forCellReuseIdentifier: cellID)
        self.navigationItem.title = "拼车出行"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        fetchthings()
        
        
    }
    
    var cars = [car]()
    func fetchthings(){
        FIRDatabase.database().reference().child("cars").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value  as? [String:AnyObject]{
                let cars = car()
                cars.setValuesForKeysWithDictionary(dictionary)
                self.cars.insert(cars, atIndex: 0)
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
        return cars.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "sportsCell"
        let cell :sportsCell = tableView.dequeueReusableCellWithIdentifier(cellID) as! sportsCell
        let car = cars[indexPath.row]
        if let fromid = car.fromid{
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
        cell.titlelabel.text = car.title
        cell.addresslabel.text = car.address
        cell.numberlabel.text = car.number
        cell.datelabel.text = car.time
        let imageurl = car.salesimageurl as String
        cell.sportsimage.kf_setImageWithURL(NSURL(string: imageurl)!,placeholderImage: nil)
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cars = self.cars[indexPath.row]
        showdetail(cars)
    }
    func showdetail(cars:car){
        let detailvc = cardetailViewController()
        detailvc.cars = cars
        navigationController?.pushViewController(detailvc, animated: true)
        
    }
    
    
}
