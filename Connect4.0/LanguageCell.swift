//
//  LanguageCell.swift
//  Connect4.0
//
//  Created by Pakgon on 11/9/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    // Make: outlet
    @IBOutlet var titleLanguage: UILabel!
    
    var item: LanguageSlideMenu? {
        didSet {
            
            if let language = item?.languageTH {
                //set title language
                titleLanguage.text = language
            }
        }
    }
    

    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.black
        titleLanguage.textColor = UIColor.white
        titleLanguage.resizeFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
}
