//
//  IDCardViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/6/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class IDCardViewController: BaseViewController {

    //Make: outlet
    @IBOutlet var userIMG: UIImageView!
    @IBOutlet var switchIMG: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var userInformationTableView: UITableView!
    @IBOutlet var fullNameEn: UILabel!
    @IBOutlet var cameraChangeIMG: UIImageView!
    @IBOutlet var layoutProfile: UIView!
    @IBOutlet var layoutName: UIStackView!
    
    //Make: properties
    var userInfomation: UserInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        setView()
        
        userInformationTableView.setBaseTableStyle()
        fullNameLabel.text = "Chanothai Duangrahva"
        fullNameEn.text = "ชโนทัย ดวงระหว้า"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension IDCardViewController {
    func setView(){
        let screenSize:Int = Int(UIScreen.main.bounds.width / 1.6)
        print(screenSize)
        
        if screenSize < 250 {
            let font = UIFont(name: "supermarket", size: 18.0)
            fullNameEn.font = font
            fullNameLabel.font = font
        }
        
        setProfileIMG(screenSize)
        setIconQRCode(screenSize)
        setIconCamera(screenSize)
    }
    
    func setProfileIMG(_ screenSize: Int) {
        let heightConstriant = NSLayoutConstraint(item: userIMG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(screenSize))
        let widthConstraint = NSLayoutConstraint(item: userIMG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(screenSize))
        
        var constantSize:CGFloat = 24
        
        if screenSize < 250 {
            constantSize = 16
        }
        
        let topConstriant = NSLayoutConstraint(item: userIMG, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: layoutProfile, attribute: NSLayoutAttribute.top, multiplier: 1, constant: constantSize)
        let bottomConstriant = NSLayoutConstraint(item: userIMG, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: layoutName, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -constantSize)
        
        layoutProfile.addConstraints([widthConstraint, heightConstriant,topConstriant, bottomConstriant])

        
        userIMG.layer.cornerRadius = CGFloat(screenSize / 2)
        userIMG.layer.borderColor = UIColor.lightGray.cgColor
        userIMG.layer.borderWidth = 1
        userIMG.backgroundColor = UIColor.white

    }
    
    func setIconQRCode(_ screenSize: Int) {
        if screenSize < 250 {
            let heightSwitch = NSLayoutConstraint(item: switchIMG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let widthSwitch = NSLayoutConstraint(item: switchIMG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            layoutProfile.addConstraints([widthSwitch, heightSwitch])
            switchIMG.layer.cornerRadius = 25
        }else{
            switchIMG.layer.cornerRadius = CGFloat(switchIMG.frame.width / 2)
        }
        
        switchIMG.layer.borderWidth = 1
        switchIMG.layer.borderColor = UIColor.lightGray.cgColor
        switchIMG.backgroundColor = UIColor.white
        switchIMG.image = UIImage(named: "people")
        switchIMG.clipsToBounds = true
    }
    
    func setIconCamera(_ screenSize: Int) {
        if screenSize < 250 {
            let heightSwitch = NSLayoutConstraint(item: cameraChangeIMG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            let widthSwitch = NSLayoutConstraint(item: cameraChangeIMG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
            layoutProfile.addConstraints([widthSwitch, heightSwitch])
            cameraChangeIMG.layer.cornerRadius = 25
        }else{
            cameraChangeIMG.layer.cornerRadius = CGFloat(switchIMG.frame.width / 2)
        }
        
        cameraChangeIMG.layer.borderWidth = 1
        cameraChangeIMG.layer.borderColor = UIColor.lightGray.cgColor
        cameraChangeIMG.backgroundColor = UIColor.white
        cameraChangeIMG.image = UIImage(named: "people")
        cameraChangeIMG.clipsToBounds = true
    }
}

extension IDCardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell") as! IDCardTableViewCell
        cell.userDetailLabel.text = userInfomation?.citizenID
        return cell
    }
}
