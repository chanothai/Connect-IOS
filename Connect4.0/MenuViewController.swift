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

class MenuViewController: BaseViewController {
    
    //Make: outlet
    @IBOutlet var sidebarMenuTableView: UITableView!
    @IBOutlet var profileIMG: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    
    //Make: property
    var arrMenu:[String]!
    var arrImage:[String]!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var blurEffectView:UIVisualEffectView?
    var destinationController:UIViewController?
    
    lazy var viewModel: UserInfoViewModelProtocol = UserInfoViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        sidebarMenuTableView.setBaseTableStyle()
        arrImage = SidebarMenuModel.setImageMenu()
        
        profileIMG.layer.borderColor = UIColor.white.cgColor
        profileIMG.layer.borderWidth = CGFloat(2.0)
        
        nameLabel?.text = viewModel.userInfomation.screenName
        
    
        guard let url = URL(string: (viewModel.userInfomation.profile_image_path)) else {
            return
        }
        
        profileIMG?.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension MenuViewController {
    func actionSignOut(){
        let optionMenu = UIAlertController(title: nil, message: "if you sign out of your account, all your information will be removed from this app", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            self.intentToLogin()
        }
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default, handler: callActionHandler)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(signOutAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func intentToLogin(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
        
        self.present(loginController, animated: true) {
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
        }
    }
    
    func setBackground() {
        let color1 = UIColor(colorLiteralRed: 57/255, green: 65/255, blue: 75/255, alpha: 1)
        let color2 = UIColor(colorLiteralRed: 114/255, green: 124/255, blue: 137/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor , color2.cgColor]
        gradientLayer.frame = view.frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.backgroundColor = UIColor.clear
        cell.sectionLabel.text = arrMenu[indexPath.row]
        cell.sectionLabel.textColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sidebarMenuTableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0:
            print("Feed")
            let mainBloc = storyBoard.instantiateViewController(withIdentifier: "NavBlocController") as! NavBlocController
            self.revealViewController().pushFrontViewController(mainBloc, animated: true)
            break
        case 1:
            print("ข้อมูลส่วนตัว")
            break
        case 2:
            let destinationController = self.storyBoard.instantiateViewController(withIdentifier: "IDCardController") as! IDCardViewController
            destinationController.userInfomation = ModelCart.getInstance().getUserInfo
            let nav = UINavigationController(rootViewController: destinationController)
            destinationController.navigationItem.leftBarButtonItem = self.createBarButtonItemBase()
            destinationController.navigationItem.titleView = self.createTitleBarImage()
            self.revealViewController().pushFrontViewController(nav, animated: true)
            
            break
        case 3:
            destinationController = self.storyBoard.instantiateViewController(withIdentifier: "ContactController") as! ContactViewController
            let nav = UINavigationController(rootViewController: destinationController!)
            destinationController?.navigationItem.leftBarButtonItem = self.createBarButtonItemBase()
            destinationController?.navigationItem.titleView = self.createTitleBarImage()
            destinationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add-contact") , style: .plain, target: self, action: #selector(selectAddContact))
            self.revealViewController().pushFrontViewController(nav, animated: true)
            
            
            break
        default:
            print("ออกจากระบบ")
            self.actionSignOut()
            break
        }
    }
    
    @objc func selectAddContact() {
        print("Add Contact")
        let navAddContactController = self.storyBoard.instantiateViewController(withIdentifier: "NavAddContact") as! NavContactController
        self.destinationController?.show(navAddContactController, sender: nil)
    }
}
