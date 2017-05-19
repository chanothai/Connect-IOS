//
//  StyleTableView.swift
//  Connect4.0
//
//  Created by Pakgon on 5/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class StyleTableView {
    
    private var tableView: UITableView?
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
    }
    
    func baseStyle() {
        tableView?.backgroundColor = UIColor.white
        tableView?.tableFooterView = UIView(frame: CGRect.zero) //remove empty rows of table
        tableView?.separatorColor = UIColor.clear
    }
}
