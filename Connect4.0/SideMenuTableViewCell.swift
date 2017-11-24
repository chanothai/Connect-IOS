//
//  SideMenuTableViewCell.swift
//  Connect4.0
//
//  Created by Pakgon on 5/23/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet var sectionImg: UIImageView!
    @IBOutlet var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
