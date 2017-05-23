//
//  SlidebarMenuModel.swift
//  Connect4.0
//
//  Created by Pakgon on 5/23/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation

class SidebarMenuModel {

    public static func setMenu() -> [String] {
        let titles = ["ฟีด", "ข้อมูลส่วนตัว", "บัตรประจำตัว", "เปิดใช้งานแอพพลิเคชั่น", "ออกจากระบบ"]
        var menu = [String]()
        for title in titles {
            menu.append(title)
        }
        
        return menu
    }
    
    public static func setImageMenu() ->[String] {
        let names = ["feed", "user", "idcard", "opensign", "exit"]
        var img = [String]()
        for name in names {
            img.append(name)
        }
        
        return img
    }
}
