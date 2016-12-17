//
//  personViewController.swift
//  区帮
//
//  Created by apple on 2016/8/22.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import GoogleSignIn
class loginViewController: UIViewController, UINavigationControllerDelegate, GIDSignInDelegate,GIDSignInUIDelegate{
    
    var personalTableViewControll: personalTableViewController?
    var messageTableViewControll: MessageTableViewController?
    let inputview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    lazy var loginregisterbutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        button.addTarget(self, action: #selector(handleloginregidter), forControlEvents: .TouchUpInside )
       return button
    }()
    func handleloginregidter(){
        if loginregistsegmentedcontrol.selectedSegmentIndex == 0{
            handlogin()
        }else{
            handleregister()
        }
    }
    func handlogin(){
        guard let email = emailtextfield.text,password = passwordtextfield.text else{
           
            return
        }

        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil{
               print(error)
                return
            }
            self.messageTableViewControll?.fetchuserandnavigationtitle()
            self.personalTableViewControll?.fetchuserandsetnavigationtitle()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }

        let nametextfield :UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailtextfield :UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordtextfield :UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        return tf
    }()
    let passwordseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileimageview :UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"profileimage")
        imageview.layer.cornerRadius = 75
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .ScaleAspectFill
        imageview.userInteractionEnabled = true
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectprofileimage)))
        
        return imageview
    }()
    lazy var loginregistsegmentedcontrol: UISegmentedControl = {
        let sc = UISegmentedControl(items:["登陆","注册"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.tintColor = UIColor.lightGrayColor()
        sc.addTarget(self, action:#selector(handleloginregistchange), forControlEvents: .ValueChanged)
       return sc
    }()
    func handleloginregistchange(){
        let title = loginregistsegmentedcontrol.titleForSegmentAtIndex(loginregistsegmentedcontrol.selectedSegmentIndex)
        loginregisterbutton.setTitle(title, forState: .Normal)
        inputscontainerviewheightanchor?.constant = loginregistsegmentedcontrol.selectedSegmentIndex == 0 ? 100 :150
        
        
        nametextfieldheightanchor?.active = false
        nametextfieldheightanchor = nametextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor, multiplier: loginregistsegmentedcontrol.selectedSegmentIndex == 0 ? 0 : 1/3)
        nametextfieldheightanchor?.active = true
        
        
        emailtextfieldheightanchor?.active = false
        emailtextfieldheightanchor = emailtextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor, multiplier: loginregistsegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailtextfieldheightanchor?.active = true

        
        passwordtextfieldheightanchor?.active = false
        passwordtextfieldheightanchor = passwordtextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor, multiplier: loginregistsegmentedcontrol.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordtextfieldheightanchor?.active = true

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 255/255, alpha: 1)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        let googlebutton = GIDSignInButton()
        view.addSubview(googlebutton)
        view.addSubview(inputview)
        view.addSubview(loginregisterbutton)
        view.addSubview(profileimageview)
        view.addSubview(loginregistsegmentedcontrol)
        googlebutton.snp_makeConstraints { (make) in
            make.top.equalTo(loginregisterbutton.snp_bottom)
            make.left.equalTo(loginregisterbutton.snp_left)
            make.size.equalTo(loginregisterbutton.snp_size)
        }
        setupinputview()
        setuploginregisterbutton()
        setuprofileimageview()
        setupsegmentcontrol()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupsegmentcontrol(){
        loginregistsegmentedcontrol.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginregistsegmentedcontrol.bottomAnchor.constraintEqualToAnchor(inputview.topAnchor, constant: -12).active = true
        loginregistsegmentedcontrol.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor,multiplier: 1).active = true
        loginregistsegmentedcontrol.heightAnchor.constraintEqualToConstant(36).active = true
        
        }
    func setuploginregisterbutton(){
        loginregisterbutton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginregisterbutton.topAnchor.constraintEqualToAnchor(inputview.bottomAnchor,constant: 12).active = true
        loginregisterbutton.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        loginregisterbutton.heightAnchor.constraintEqualToConstant(36).active = true
    }
    var inputscontainerviewheightanchor: NSLayoutConstraint?
    var nametextfieldheightanchor: NSLayoutConstraint?
    var emailtextfieldheightanchor: NSLayoutConstraint?
    var passwordtextfieldheightanchor: NSLayoutConstraint?
    
    func setupinputview(){
        
        inputview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputview.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputview.widthAnchor.constraintEqualToAnchor(view.widthAnchor,constant: -24).active = true
        inputscontainerviewheightanchor = inputview.heightAnchor.constraintEqualToConstant(150)
        inputscontainerviewheightanchor?.active = true
        
        
        
        inputview.addSubview(nametextfield)
        inputview.addSubview(nameseparatorview)
        inputview.addSubview(emailtextfield)
        inputview.addSubview(emailseparatorview)
        inputview.addSubview(passwordtextfield)
        
        
        nametextfield.leftAnchor.constraintEqualToAnchor(inputview.leftAnchor,constant: 12).active = true
        nametextfield.topAnchor.constraintEqualToAnchor(inputview.topAnchor).active = true
        nametextfield.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        nametextfieldheightanchor = nametextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor,multiplier: 1/3)
        nametextfieldheightanchor?.active = true
        
        
        nameseparatorview.leftAnchor.constraintEqualToAnchor(inputview.leftAnchor).active = true
        nameseparatorview.topAnchor.constraintEqualToAnchor(nametextfield.bottomAnchor).active = true
        nameseparatorview.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        nameseparatorview.heightAnchor.constraintEqualToConstant(1).active = true
        
        
        emailtextfield.leftAnchor.constraintEqualToAnchor(inputview.leftAnchor,constant: 12).active = true
        emailtextfield.topAnchor.constraintEqualToAnchor(nameseparatorview.bottomAnchor).active = true
        emailtextfield.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        emailtextfieldheightanchor = emailtextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor,multiplier: 1/3)
        emailtextfieldheightanchor?.active = true
        
        
        emailseparatorview.leftAnchor.constraintEqualToAnchor(inputview.leftAnchor).active = true
        emailseparatorview.topAnchor.constraintEqualToAnchor(emailtextfield.bottomAnchor).active = true
        emailseparatorview.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        emailseparatorview.heightAnchor.constraintEqualToConstant(1).active = true
        
        
        
        passwordtextfield.leftAnchor.constraintEqualToAnchor(inputview.leftAnchor,constant: 12).active = true
        passwordtextfield.topAnchor.constraintEqualToAnchor(emailseparatorview.bottomAnchor).active = true
        passwordtextfield.widthAnchor.constraintEqualToAnchor(inputview.widthAnchor).active = true
        passwordtextfieldheightanchor = passwordtextfield.heightAnchor.constraintEqualToAnchor(inputview.heightAnchor,multiplier: 1/3)
        passwordtextfieldheightanchor?.active = true
        
        
        
    }
    func setuprofileimageview(){
        profileimageview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileimageview.bottomAnchor.constraintEqualToAnchor(loginregistsegmentedcontrol.topAnchor,constant: -12).active = true
        profileimageview.widthAnchor.constraintEqualToConstant(150).active = true
        profileimageview.heightAnchor.constraintEqualToConstant(150).active = true
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error{
            print(error.localizedDescription)
            return
        }
        print(user.profile.email)
    }
   
}
