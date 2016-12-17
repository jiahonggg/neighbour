//
//  salecell.swift
//  区帮
//
//  Created by apple on 2016/8/25.
//  Copyright © 2016年 zoujiahong. All rights reserved.
//

import UIKit

class salecell: UITableViewCell {

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    override func awakeFromNib() {
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
