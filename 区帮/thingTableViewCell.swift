//
//  thingTableViewCell.swift
//  区帮
//
//  Created by apple on 2016/9/21.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

class thingTableViewCell: UITableViewCell {

    @IBOutlet weak var profleimage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var readlabel: UIView!
    @IBOutlet weak var pinlunlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
