//
//  Extension.swift
//  区帮
//
//  Created by apple on 2016/9/25.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

let imagecache = NSCache()
extension UIImageView {
    func loadimageusingcachewithurlstring(urlString: String){
        if let cacheimage = imagecache .objectForKey(urlString) as? UIImage{
            self.image = cacheimage
            return
        }
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                let downloadimage = UIImage(data: data!)
                imagecache.setObject(downloadimage!, forKey: urlString)
                
                self.image = downloadimage
            })
        }).resume()
    }
}