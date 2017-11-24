//
//  MenuSlideViewModelItemType.swift
//  Connect4.0
//
//  Created by Pakgon on 11/9/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import UIKit

enum MenuSlideViewModelItemType {
    case language
    case logout
}

protocol MenuSlideViewModelItem {
    var type: MenuSlideViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

protocol MenuSlideClickDelegat  {
    func menuClicked(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension MenuSlideViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class MenuSlideViewModel: NSObject {
    var items = [MenuSlideViewModelItem]()
    var reloadSection: ((_ section: Int) -> Void)?
    
    var clickDelegate: MenuSlideClickDelegat?
    
    override init() {
        super.init()
        
        guard let language = ModelCart.getInstance().getModelSlideMenu().result.data?.languages else {
            return
        }
        if !language.isEmpty {
            let languageItem = MenuSlideLanguageItem(languages: language)
            items.append(languageItem)
        }
        
        guard let signout = ModelCart.getInstance().getModelSlideMenu().result.data?.menus else {
            return
        }
        
        if !signout.isEmpty {
            let logoutItem = MenuSlideLogoutItem(menus: signout)
            items.append(logoutItem)
        }
    }
    
}

extension MenuSlideViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        guard item.isCollapsible else {
            return item.rowCount
        }
        
        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .language:
            if let item = item as? MenuSlideLanguageItem, let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell {
                cell.item = item.languages[indexPath.row] // add data item to model item for display data
                return cell
            }
        case .logout:
            if let item = item as? MenuSlideLogoutItem, let cell = tableView.dequeueReusableCell(withIdentifier: LogoutCell.identifier, for: indexPath) as? LogoutCell {
                cell.item = item.menus[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension MenuSlideViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderLanguageView.identifier) as? HeaderLanguageView {
                let item = items[section]
                headerView.item = item
                headerView.section = section
                headerView.delegate = self
                return headerView
            }
        }
    
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = UIScreen.main.bounds.height
        if section == 0 {
            switch height {
            case 568.0: //iphone 5, 5s => 4 inch
                return 60
            case 667.0: //iphone 6, 6s => 4.7 inch
                return 80
            case 736.0: //iphone 6s+ 6+ => 5.5 inch
                return 80
            default:
                print("not an iPhone")
                break
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickDelegate?.menuClicked(tableView, didSelectRowAt: indexPath)
    }
}

extension MenuSlideViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderLanguageView, section: Int) {
        var item = items[section]
        if item.isCollapsible {
            //Toggle collapsed
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            reloadSection?(section)
        }
    }
}

class MenuSlideLanguageItem: MenuSlideViewModelItem {
    var type: MenuSlideViewModelItemType {
        return .language
    }
    
    var sectionTitle: String {
        return "Language"
    }
    
    var isCollapsible: Bool {
        return true
    }
    
    var isCollapsed = true
    
    var rowCount: Int {
        return languages.count
    }
    
    var languages: [LanguageSlideMenu]
    
    init(languages: [LanguageSlideMenu]) {
        self.languages = languages
    }
}

class MenuSlideLogoutItem: MenuSlideViewModelItem {
    var rowCount: Int {
        return 1
    }

    var type: MenuSlideViewModelItemType {
        return .logout
    }
    
    var sectionTitle: String {
        return "Sign out"
    }
    
    var isCollapsible: Bool {
        return false
    }
    
    var isCollapsed = false
    
    
    var menus: [MenusSlide]
    
    init(menus: [MenusSlide]) {
        self.menus = menus
    }
}
