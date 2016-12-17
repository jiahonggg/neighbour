//
//  sportsCell.swift
//  区帮
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

class sportsCell: UITableViewCell {
    @IBOutlet weak var sportsimage: UIImageView!

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var addressimage: UIImageView!
    @IBOutlet weak var dateimage: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var numberlabel: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
