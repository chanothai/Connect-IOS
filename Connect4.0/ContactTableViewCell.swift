//
//  ContactTableViewCell.swift
//  Connect4.0
//
//  Created by Pakgon on 6/16/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var subjectUser: UILabel!
    @IBOutlet var btnPhone: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
