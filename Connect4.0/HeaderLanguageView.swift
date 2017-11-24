//
//  HeaderLanguageCell.swift
//  Connect4.0
//
//  Created by Pakgon on 11/13/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderLanguageView, section: Int)
}

class HeaderLanguageView: UITableViewHeaderFooterView {

    var item: MenuSlideViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            titleHeader.text = item.sectionTitle
            setCollapsed(collapsed: item.isCollapsed)
        }
    }
    
    //Make: outlet
    @IBOutlet var titleHeader: UILabel!
    @IBOutlet var imgHeader: UIImageView!
    @IBOutlet var arrowDown: UIImageView!
    
    var section: Int = 0
    var delegate: HeaderViewDelegate?
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.black
        titleHeader.textColor = UIColor.white
        imgHeader.image = UIImage(named: "language_change")
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc func didTapHeader(){
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
        if !collapsed {
            arrowDown.image = UIImage(named: "menu_arrow_down")
        }else{
            arrowDown.image = UIImage(named: "menu_arrow_back")
        }
    }
}
