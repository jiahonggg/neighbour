import UIKit
import Firebase

class addfunsViewController: UIViewController , UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let titletextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "去哪旅游？"
        return textfield
    }()
    let numbertextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "旅行人数"
        textfield.backgroundColor = UIColor.whiteColor()
        return textfield
    }()
    let timetextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "出发时间"
        textfield.backgroundColor = UIColor.whiteColor()
        return textfield
    }()
    let addresstextfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "出发地址"
        textfield.backgroundColor = UIColor.whiteColor()
        return textfield
    }()
    
    
    let discribetextview : UITextView = {
        let textview = UITextView()
        textview.text = "旅行描述"
        textview.textColor = UIColor.lightGrayColor()
        return textview
    }()
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "旅行描述"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    let titleseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let bottomseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftshortseparatorview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let inputcontentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    lazy var addimageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "addimage")
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(touchimage)))
        imageview.userInteractionEnabled = true
        return imageview
    }()
    lazy var sendbutton:UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("发布", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 60
        button.layer.masksToBounds = true
        button.addTarget(self, action:#selector(sendthings), forControlEvents: .TouchUpInside)
        return button
    }()
    func sendthings(){
        let imagenName = NSUUID().UUIDString
        let storageref = FIRStorage.storage().reference().child("travels").child("\(imagenName).png")
        if let uploadData = UIImagePNGRepresentation(self.addimageview.image!){
            storageref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error)
                    return
                }
                if let salesimageurl = metadata?.downloadURL()?.absoluteString{
                    let title = self.titletextfield.text
                    let detaildiscribe = self.discribetextview.text
                    let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970)
                    let fromid = FIRAuth.auth()?.currentUser?.uid
                    let time = self.timetextfield.text
                    let number = self.numbertextfield.text
                    let address = self.addresstextfield.text
                    let ref = FIRDatabase.database().reference().child("travels").childByAutoId()
                    let things :[String: AnyObject] = ["title":title!,
                        "detaildiscribe":detaildiscribe,
                        "fromid":fromid!,
                        "time":time!,
                        "number":number!,
                        "address":address!,
                        "salesimageurl":salesimageurl,
                        "timestamp":timestamp]
                    ref.setValue(things)
                    let usersaleref = FIRDatabase.database().reference().child("user-travels").child(fromid!)
                    let saleId = ref.key
                    usersaleref.updateChildValues([saleId:1])
                    
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
        
    }
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(titletextfield)
        self.view.addSubview(titleseparatorview)
        self.view.addSubview(discribetextview)
        self.view.addSubview(leftseparatorview)
        self.view.addSubview(rightseparatorview)
        self.view.addSubview(bottomseparatorview)
        self.view.addSubview(leftshortseparatorview)
        self.view.addSubview(sendbutton)
        self.view.addSubview(inputcontentView)
        discribetextview.delegate = self
        self.navigationItem.title = "旅游出行"
        setupui()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    func setupui(){
        titletextfield.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.top.equalTo(self.view.snp_top).offset(64)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(40)
        }
        titleseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titletextfield.snp_bottom)
            make.left.equalTo(titletextfield.snp_left)
            make.width.equalTo(titletextfield.snp_width)
            make.height.equalTo(2)
        }
        discribetextview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(titleseparatorview.snp_width)
            make.height.equalTo(300)
        }
        leftseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(2)
            make.height.equalTo(200)
        }
        rightseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(titleseparatorview.snp_bottom)
            make.right.equalTo(titleseparatorview.snp_right)
            make.width.equalTo(2)
            make.height.equalTo(200)
        }
        bottomseparatorview.snp_makeConstraints { (make) in
            make.top.equalTo(leftseparatorview.snp_bottom)
            make.left.equalTo(titleseparatorview.snp_left)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(2)
        }
        leftshortseparatorview.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.top.equalTo(self.view.snp_top)
            make.width.equalTo(2)
            make.height.equalTo(40)
        }
        sendbutton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp_centerX)
            make.bottom.equalTo(self.view.snp_bottom).offset(-80)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        inputcontentView.snp_makeConstraints { (make) in
            make.top.equalTo(bottomseparatorview.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.bottom.equalTo(sendbutton.snp_top).offset(-8)
        }
        self.inputcontentView.addSubview(numbertextfield)
        self.inputcontentView.addSubview(timetextfield)
        self.inputcontentView.addSubview(addresstextfield)
        self.inputcontentView.addSubview(addimageview)
        numbertextfield.snp_makeConstraints { (make) in
            make.top.equalTo(inputcontentView.snp_top).offset(8)
            make.left.equalTo(inputcontentView.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(100, 20))
        }
        timetextfield.snp_makeConstraints { (make) in
            make.top.equalTo(inputcontentView.snp_top).offset(8)
            make.left.equalTo(numbertextfield.snp_right).offset(20)
            make.size.equalTo(CGSizeMake(100, 20))
        }
        addresstextfield.snp_makeConstraints { (make) in
            make.top.equalTo(numbertextfield.snp_bottom).offset(8)
            make.left.equalTo(inputcontentView.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(200, 20))
        }
        addimageview.snp_makeConstraints { (make) in
            make.bottom.equalTo(inputcontentView.snp_bottom)
            make.left.equalTo(inputcontentView.snp_left).offset(20)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        
        
        
        
    }
    
}

