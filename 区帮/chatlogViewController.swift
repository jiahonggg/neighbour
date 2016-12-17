import UIKit
import Firebase
import SnapKit

class chatlogViewController: UICollectionViewController, UITextFieldDelegate , UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var user : User?{
        didSet{
            navigationItem.title = user?.name
            observemessage()
        }
    }
    var messages = [Message]()
    func observemessage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-message").child(uid)
        userMessagesRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("message").child(messageId)
            messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                guard let dictionary = snapshot.value as? [String:AnyObject] else{
                    return
                }
                let message = Message(dictionary:dictionary)
                if message.chatpartnerId() == self.user?.id {
                    self.messages.append(Message(dictionary:dictionary))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.collectionView?.reloadData()
                    })
                }
                }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
        lazy var inputtextfield : UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Enter message..."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    lazy var imageview:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named:"addimage")
        imageview.layer.cornerRadius = 20
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(touchimage)))
        imageview.userInteractionEnabled = true
        return imageview
    }()
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

            uploadimage(selectedimage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    private func uploadimage(image:UIImage){
        let imagenName = NSUUID().UUIDString
        let ref = FIRStorage.storage().reference().child("message-images").child("\(imagenName).png")
        if let uploaddata = UIImageJPEGRepresentation(image, 0.2){
        ref.putData(uploaddata, metadata: nil, completion: { (metadata, error) in

            if error != nil {
                print(error)
                return
            }
            if let imageurl = metadata?.downloadURL()?.absoluteString {
                self.sendimage(imageurl,image: image)
            }
        })
        }
        
    }
    private func sendimage (imageurl:String,image:UIImage){
        let childref = FIRDatabase.database().reference().child("message").childByAutoId()
        let toid = user!.id
        let fromid = FIRAuth.auth()?.currentUser?.uid
        let timestamp: NSNumber = NSDate().timeIntervalSince1970
        let values = ["toid":toid!,"fromid":fromid!,"timestamp":timestamp,"imageurl": imageurl,"imagewidth":image.size.width,"imageheight":image.size.height]
        childref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            self.inputtextfield.text = nil
            let usermessageref = FIRDatabase.database().reference().child("user-message").child(fromid!)
            let messageId = childref.key
            usermessageref.updateChildValues([messageId:1])
            
            let recipientusermessages = FIRDatabase.database().reference().child("user-message").child(toid!)
            recipientusermessages.updateChildValues([messageId:1])
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.registerClass(chatmessagecell.self, forCellWithReuseIdentifier: cellId)
        setupinputview()
        setupkeyboard()
        
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! chatmessagecell
        cell.chatlogcontroll = self
        let message = messages[indexPath.row]
        cell.textview.text = message.text
        if let messageurl = message.imageurl {
            cell.messageimage.loadimageusingcachewithurlstring(messageurl)
            cell.messageimage.hidden = false
            cell.bubbleview.hidden = true
        }else{
            cell.messageimage.hidden = true
            cell.bubbleview.hidden = false
        }
        if let text = message.text{
            cell.bubblewidth?.constant = estimateframefortext(text).width + 32
        }else if message.imageurl != nil{
            cell.bubblewidth?.constant = 200
        }
        
        setupcell(cell, message: message)
        return cell
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    private func setupcell(cell: chatmessagecell,message: Message){
        if let profileimageurl = self.user?.profileimageurl{
            cell.profileimageview.loadimageusingcachewithurlstring(profileimageurl)
        }
        if message.fromid == FIRAuth.auth()?.currentUser?.uid{
            cell.bubbleview.backgroundColor = chatmessagecell.bluecolor
            cell.textview.textColor = UIColor.whiteColor()
            cell.bubbleviewrightanchor?.active = true
            cell.bubbleviewleftanchor?.active = false
            cell.profileimageview.hidden = true
        }else{
            cell.bubbleview.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textview.textColor = UIColor.blackColor()
            cell.bubbleviewrightanchor?.active = false
            cell.bubbleviewleftanchor?.active = true
            cell.profileimageview.hidden = false
        }
    }
    func setupkeyboard(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handlekeyboardwillshow), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handlekeyboardwillhide), name: UIKeyboardWillHideNotification, object: nil)
    }
    func handlekeyboardwillshow(notification:NSNotification){
        let keyboardframe = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        containerviewbottom?.constant = -(keyboardframe?.height)!
    }
    func handlekeyboardwillhide(notification:NSNotification){
        containerviewbottom?.constant = -(44)
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height : CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateframefortext(text).height + 20
        }else if let imagewidth = message.imagewidth?.floatValue,imageheight = message.imageheight?.floatValue{
            height = CGFloat(imageheight / imagewidth * 200)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateframefortext(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
        
    }
    var containerviewbottom : NSLayoutConstraint?
    func setupinputview(){
        
        
        
        let containview = UIView()
        containview.backgroundColor = UIColor.whiteColor()
        view.addSubview(containview)
        
        let sendbutton = UIButton(type: .System)
        sendbutton.setTitle("Send", forState: .Normal)
        sendbutton.translatesAutoresizingMaskIntoConstraints = false
        containview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendbutton)
        view.addSubview(imageview)
        sendbutton.addTarget(self, action: #selector(handlesend), forControlEvents: .TouchUpInside)
            sendbutton.snp_makeConstraints { (make) in
            make.right.equalTo(containview.snp_right)
            make.centerY.equalTo(containview.snp_centerY)
            make.width.equalTo(80)
            make.height.equalTo(containview.snp_height)
        }
        containview.snp_makeConstraints { (make) in
            
            make.left.equalTo(self.view.snp_left)
            make.height.equalTo(50)
            make.width.equalTo(self.view.snp_width)
        }
        containerviewbottom = containview.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor,constant: -44)
        containerviewbottom?.active = true
        containview.addSubview(inputtextfield)
        inputtextfield.snp_makeConstraints { (make) in
            make.left.equalTo(imageview.snp_right).offset(8)
            make.centerY.equalTo(containview.snp_centerY)
            make.right.equalTo(sendbutton.snp_left)
            make.height.equalTo(containview.snp_height)
        }
        let separatorlineview = UIView()
        separatorlineview.backgroundColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        separatorlineview.translatesAutoresizingMaskIntoConstraints = false
        containview.addSubview(separatorlineview)
        separatorlineview.snp_makeConstraints { (make) in
            make.top.equalTo(containview.snp_top)
            make.left.equalTo(containview.snp_left)
            make.width.equalTo(containview.snp_width)
            make.height.equalTo(1)
        }
        imageview.snp_makeConstraints { (make) in
            make.left.equalTo(containview.snp_left)
            make.top.equalTo(containview.snp_top).offset(2)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
    }
    func handlesend(){

        
        let childref = FIRDatabase.database().reference().child("message").childByAutoId()
        let toid = user!.id
        let fromid = FIRAuth.auth()?.currentUser?.uid
        let timestamp: NSNumber = NSDate().timeIntervalSince1970
        let values = ["text":inputtextfield.text!,"toid":toid!,"fromid":fromid!,"timestamp":timestamp]
        childref.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            self.inputtextfield.text = nil
            let usermessageref = FIRDatabase.database().reference().child("user-message").child(fromid!)
            let messageId = childref.key
            usermessageref.updateChildValues([messageId:1])
            
            let recipientusermessages = FIRDatabase.database().reference().child("user-message").child(toid!)
            recipientusermessages.updateChildValues([messageId:1])
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handlesend()
        return true
    }
    var staringframe:CGRect?
    var blackview : UIView?
    func performzoom(imageview:UIImageView){
        staringframe = imageview.superview?.convertRect(imageview.frame, toView: nil)
        let zoomingimageview = UIImageView(frame: staringframe!)
        zoomingimageview.backgroundColor = UIColor.redColor()
        zoomingimageview.image = imageview.image
        zoomingimageview.userInteractionEnabled = true
        zoomingimageview.addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(handlezoomout)))
        if let keywindow = UIApplication.sharedApplication().keyWindow{
            blackview = UIView(frame: keywindow.frame)
            blackview?.backgroundColor = UIColor.blackColor()
            blackview?.alpha = 0
            keywindow.addSubview(blackview!)
            keywindow.addSubview(zoomingimageview)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self.blackview!.alpha = 1
                let height = self.staringframe!.height / self.staringframe!.width * keywindow.frame.width
                zoomingimageview.frame = CGRect(x: 1,y: 0,width: keywindow.frame.width,height: height)
                zoomingimageview.center = keywindow.center                }, completion: { (compled) in
            })
        }
        
    }
    func handlezoomout(tapgesture: UITapGestureRecognizer){
        if let zoomoutimageview = tapgesture.view{
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { 
                zoomoutimageview.frame = self.staringframe!
                self.blackview?.alpha = 0
                }, completion: { (compled) in
                     zoomoutimageview.removeFromSuperview()
            })
            
        }
    }
}




















