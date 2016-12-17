//
//  addViewController+touchimage.swift
//  区帮
//
//  Created by apple on 2016/8/26.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase

extension addViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func jump(){
        let Name = nametext.text
        let price = jiagetext.text
        let Discribe = discribetext.text
        let Tel = teltext.text
        let Address = addresstext.text
        let imagenName = NSUUID().UUIDString
        let storageref = FIRStorage.storage().reference().child("sales").child("\(imagenName).png")
        if let uploadData = UIImagePNGRepresentation(self.addimageview.image!){
            storageref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                if let salesimageurl = metadata?.downloadURL()?.absoluteString{
                    let ref = FIRDatabase.database().reference().child("sales").childByAutoId()
                    let fromid = FIRAuth.auth()?.currentUser?.uid
                    let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
                    let sales :[String: AnyObject] = ["Name":Name!,
                        "price":price!,
                        "Discribe":Discribe!,
                        "Tel":Tel!,
                        "Address":Address!,
                        "fromid":fromid!,
                        "timestamp":timestamp,
                        "salesimageurl":salesimageurl
                        ]
                    ref.setValue(sales)
                    let usersaleref = FIRDatabase.database().reference().child("user-sales").child(fromid!)
                    let saleId = ref.key
                    usersaleref.updateChildValues([saleId:1])
            }
           })
        }
        addimageview.image = UIImage(named: "addimage")
        nametext.text = ""
        discribetext.text = ""
        teltext.text = ""
        addresstext.text = ""
        
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
        
     }
    func touchimage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedimagefromepicker : UIImage?
        if let editedimage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedimagefromepicker = editedimage
            
        }else if let orignalimage = info["UIImagePickerControllerOriginalImage"] as?UIImage{
            selectedimagefromepicker = orignalimage
        }
        if let selectedimage = selectedimagefromepicker{
            addimageview.image = selectedimage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel picker")
        dismissViewControllerAnimated(true, completion: nil)
    }

}
