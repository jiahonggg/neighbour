//
//  supermarketController.swift
//  区帮
//
//  Created by apple on 2016/10/5.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit
import Firebase


class supermarketController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var markets = [market]()
    lazy var buyButton: UIButton = {
        let carButton = UIButton(type: UIButtonType.Custom)
        carButton.setImage(UIImage(named: "button_cart"), forState: UIControlState.Normal)
        carButton.addTarget(self, action: #selector(buy), forControlEvents: UIControlEvents.TouchUpInside)
        carButton.sizeToFit()
        return carButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buyButton)
        navigationItem.title = "便利商店"
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(goodscell.self, forCellWithReuseIdentifier: "cellId")
        fetchgoods()
    }
    func fetchgoods(){
        FIRDatabase.database().reference().child("supermarket").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let markets = market()
            if let dictionary = snapshot.value as? [String:AnyObject]{
                markets.setValuesForKeysWithDictionary(dictionary)
                self.markets.insert(markets, atIndex: 0)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView!.reloadData()
                })
            }
            }, withCancelBlock: nil)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return markets.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! goodscell
        let market = markets[indexPath.row]
        cell.namelabel.text = market.name
        cell.pricelabel.text = market.price
        let imageurl = market.imageurl
        cell.bgimageview.loadimageusingcachewithurlstring(imageurl)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 200)
    }
    func buy(){
        navigationController?.pushViewController(orderViewController(), animated: true)
    }
}




class goodscell: UICollectionViewCell {
    
    let bgimageview : UIImageView = {
        let imgeview = UIImageView()
        return imgeview
    }()
    let namelabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blueColor()
        return label
    }()
    let pricelabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.redColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupviews(){
        addSubview(bgimageview)
        addSubview(namelabel)
        addSubview(pricelabel)
        bgimageview.snp_makeConstraints { (make) in
            make.edges.equalTo(self.snp_edges)
        }
        namelabel.snp_makeConstraints { (make) in
            make.left.equalTo(bgimageview.snp_left).offset(20)
            make.right.equalTo(bgimageview.snp_right).offset(-20)
            make.bottom.equalTo(bgimageview.snp_bottom).offset(-40)
            make.height.equalTo(20)
        }
        pricelabel.snp_makeConstraints { (make) in
            make.left.equalTo(bgimageview.snp_left).offset(20)
            make.right.equalTo(bgimageview.snp_right).offset(-20)
            make.bottom.equalTo(bgimageview.snp_bottom).offset(-16)
            make.height.equalTo(16)
        }
    }
}





