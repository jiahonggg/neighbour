//
//  Message.swift
//  区帮
//
//  Created by apple on 2016/9/24.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase


class Message: NSObject {
    var fromid: String?
    var text: String?
    var timestamp: NSNumber?
    var toid: String?
    var imageurl:String?
    var imagewidth:NSNumber?
    var imageheight:NSNumber?
    
    
    
    func chatpartnerId() -> String?{
        return fromid == FIRAuth.auth()?.currentUser?.uid ? toid : fromid
        
    }
    
    init(dictionary:[String:AnyObject]) {
        super.init()
        fromid = dictionary["fromid"] as? String
        text = dictionary["text"] as? String
        toid = dictionary["toid"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        imageurl = dictionary["imageurl"] as? String
        imagewidth = dictionary["imagewidth"] as? NSNumber
        imageheight = dictionary["imageheight"] as? NSNumber
    }
    
    
    
    
    
    
    
}
