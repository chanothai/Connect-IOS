//
//  LogoutCell.swift
//  Connect4.0
//
//  Created by Pakgon on 11/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {

    //Make: outlet
    
    @IBOutlet var titleMenu: UILabel!
    @IBOutlet var imgTitle: UIImageView!
    
    var item: MenusSlide? {
        didSet {
            titleMenu.text = item?.label
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgTitle.image = UIImage(named: "exit")
        titleMenu.textColor = UIColor.white
        titleMenu.resizeFont()
        self.backgroundColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
