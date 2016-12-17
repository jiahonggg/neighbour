//
//  login+selectprofileimage.swift
//  区帮
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
extension loginViewController : UIImagePickerControllerDelegate{

    func handleregister(){
        guard let email = emailtextfield.text,password = passwordtextfield.text,name = nametextfield.text else{
            print("form is not valid")
            return
           }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            let imagename = NSUUID().UUIDString
            let storageref = FIRStorage.storage().reference().child("profileimage").child("\(imagename).png")
            if let uploaddata = UIImageJPEGRepresentation(self.profileimageview.image!, 0.1){
                storageref.putData(uploaddata, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let profileimageurl = metadata?.downloadURL()?.absoluteString{
                        let values = ["name":name,"email":email,"profileimageurl":profileimageurl]
                        self.registeruserintodatabasewithuid(uid, values: values)
                        self.messageTableViewControll?.fetchuserandnavigationtitle()
                    }
                })
            }
        })
    }
    private func registeruserintodatabasewithuid(uid:String,values:[String:AnyObject]){
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            }
//            self.messageTableViewControll?.fetchuserandsetnavigationtitle()
            self.messageTableViewControll?.navigationItem.title = values["name"] as? String
            self.personalTableViewControll?.fetchuserandsetnavigationtitle()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }

    
    func selectprofileimage(){
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
                profileimageview.image = selectedimage
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }


    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
}
