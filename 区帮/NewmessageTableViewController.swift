//
//  MessageTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/24.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

class NewmessageTableViewController: UITableViewController {

    var user = [User]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.navigationItem.title = "住户列表"
        self.tableView.dataSource = self
        tableView.registerClass(Usercell.self, forCellReuseIdentifier: cellId)
        fetchusrs()
        
    }
    func fetchusrs(){
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let dictionary = snapshot.value as?[String:AnyObject]{
                let users = User()
                users.id = snapshot.key
                users.setValuesForKeysWithDictionary(dictionary)
                self.user.insert(users, atIndex: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }

            }, withCancelBlock:nil)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let users = user[indexPath.row]
        showchatlog(users)
    }
    func showchatlog(users: User){
        let chatcontroller = chatlogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatcontroller.user = users
        navigationController?.pushViewController(chatcontroller, animated: true)
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId,forIndexPath: indexPath) as! Usercell
        let users = user[indexPath.row]
        if let imageviewurl = users.profileimageurl{
            cell.profileimageview.loadimageusingcachewithurlstring(imageviewurl)
        }
        cell.detailTextLabel?.text = users.email
        cell.textLabel?.text = users.name
        
        return cell
    }
}









