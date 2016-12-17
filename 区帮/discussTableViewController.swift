//
//  discussTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class discussTableViewController: UITableViewController {

    var headview :UIView = {
        let view = UIView()
        return view
    }()
    var imageview :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"no")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = self.headview
        setupui()
        fetchusersend()

    }
    func fetchusersend(){
        _ = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("sales").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            }, withCancelBlock: nil)
    }

    
    func setupui (){
        headview.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.top.equalTo(self.view.snp_top)
            make.height.equalTo(300)
            make.width.equalTo(self.view.snp_width)
        }
        self.headview.addSubview(imageview)
        imageview.snp_makeConstraints { (make) in
            make.center.equalTo(headview.snp_center)
            make.edges.equalTo(headview.snp_edges)
        }
    }
    

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
