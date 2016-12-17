//
//  MessageTableViewController.swift
//  区帮
//
//  Created by apple on 2016/9/25.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase


class MessageTableViewController: UITableViewController, UINavigationControllerDelegate{
    
    
    
    var cellId = "cellId"
    
    
    
    
    override func viewDidLoad() {
        
        tableView.registerClass(Usercell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册／登录",style: .Plain,target: self,action: #selector(login))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Write", style: .Plain, target: self, action: #selector(handleWrite))
        fetchuserandnavigationtitle()
        observeusermessage()
        checkuser()
        super.viewDidLoad()
    }
    func checkuser(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(#selector(login), withObject: nil, afterDelay: 0)
        }else{
            fetchuserandnavigationtitle()
        }
    }
    func login(){
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let logincontroller = loginViewController()
        logincontroller.messageTableViewControll = self
        presentViewController(logincontroller, animated: true, completion: nil)
    }

    func fetchuserandnavigationtitle(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeysWithDictionary(dictionary)
                self.navigationItem.title = dictionary["name"] as? String
                self.setupnavigationbarwithuser(user)
                self.observeusermessage()
            }
            }, withCancelBlock: nil)
        
    }


    
    var messages = [Message]()
    var messagedictionary = [String: Message]()
    
    
    func observeusermessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let ref = FIRDatabase.database().reference().child("user-message").child(uid)
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) in

            let messageId = snapshot.key
            let messagereference = FIRDatabase.database().reference().child("message").child(messageId)
            messagereference.observeSingleEventOfType(.Value, withBlock: { (snapshot) in

                if let dictionary = snapshot.value as? [String:AnyObject]{
                    let message = Message(dictionary:dictionary)
                    if let toid = message.toid{
                        self.messagedictionary[toid] = message
                        self.messages = Array(self.messagedictionary.values)
                        self.messages.sortInPlace({ (message1, message2) -> Bool in
                            return message1.timestamp?.intValue > message2.timestamp?.intValue
                        })
                    }
                    self.timer?.invalidate()
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.handlereloaddata), userInfo: nil, repeats: false)
                    }
                }, withCancelBlock: nil)
            }, withCancelBlock: nil)
    }
    var timer:NSTimer?
    func handlereloaddata (){
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })

    }
    func handleWrite(){
        self.navigationController?.pushViewController(NewmessageTableViewController(), animated: true)
    }
    func setupnavigationbarwithuser(user:User){
        messages.removeAll()
        messagedictionary.removeAll()
        tableView.reloadData()
        observeusermessage()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let message = messages[indexPath.row]

        guard let chatparnerId = message.chatpartnerId() else {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(chatparnerId)
        ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print(snapshot)
            guard let dictionary = snapshot.value as? [String:AnyObject] else{
                return
            }
            let user = User()
            user.id = chatparnerId
            user.setValuesForKeysWithDictionary(dictionary)
            self.showchatlog(user)
            }, withCancelBlock: nil)
    }
    func showchatlog(users: User){
        let chatcontroller = chatlogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatcontroller.user = users
        navigationController?.pushViewController(chatcontroller, animated: true)
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! Usercell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let uid  = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        let message = self.messages[indexPath.row]
        if let chatparnerID = message.chatpartnerId(){
            FIRDatabase.database().reference().child("user-message").child(uid).child(chatparnerID).removeValueWithCompletionBlock({ (error, ref) in
                if error != nil{
                    print(error)
                    return
                }
                self.messages.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
            })
        }
        
    }

}















