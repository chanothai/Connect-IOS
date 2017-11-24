//
//  ManageKeyboard.swift
//  Connect4.0
//
//  Created by Pakgon on 5/18/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import UIKit

class ManageKeyboard {
    func adjustingHeight(show:Bool, notification:NSNotification, tableView: UITableView) {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let chageInHeight = (keyboardFrame.height) * (show ? -1 : 1)
        
        UIView.animate(withDuration: animationDuration, animations: {() -> Void in
            tableView.frame.origin.y += chageInHeight
        })
    }
}
