//
//  MenuViewController.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SWRevealViewController
import AlamofireImage

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Make: outlet
    @IBOutlet var sidebarMenuTableView: UITableView!
    @IBOutlet var profileIMG: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    //Make: property
    var arrMenu:[String]!
    var arrImage:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarMenuTableView.baseTableStyle()
        arrImage = SidebarMenuModel.setImageMenu()
        
        profileIMG.layer.borderColor = UIColor.white.cgColor
        profileIMG.layer.borderWidth = CGFloat(2.0)
        nameLabel.text = ModelCart.getInstance().getUserInfo.screenName
        
        let url = URL(string: ModelCart.getInstance().getUserInfo.profile_image_path)!
        profileIMG.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrMenu = SidebarMenuModel.setMenu()
        if (arrMenu?.count)! > 0 {
            return (arrMenu?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenuSideBar", for: indexPath) as! SideMenuTableViewCell
        
        cell.sectionImg.image = UIImage(named: arrImage[indexPath.row])
        cell.sectionImg.image = cell.sectionImg.image!.withRenderingMode(.alwaysTemplate)
        cell.sectionImg.tintColor = UIColor.lightGray
        cell.sectionLabel.text = arrMenu[indexPath.row]
        cell.sectionLabel.textColor = UIColor.lightGray
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}



extension BaseViewController {
    func setSideBar() {
        if (self.revealViewController() != nil) {
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationItem.leftBarButtonItem?.target = revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
}
