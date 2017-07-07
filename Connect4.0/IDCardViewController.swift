//
//  IDCardViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/6/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus

class IDCardViewController: BaseViewController {

    //Make: outlet
    @IBOutlet var userIMG: UIImageView!
    @IBOutlet var qrcodeIMG: UIImageView!
    @IBOutlet var switchIMG: UIButton!
    @IBOutlet var fullNameTH: UILabel!
    @IBOutlet var userInformationTableView: UITableView!
    @IBOutlet var fullNameEn: UILabel!
    @IBOutlet var cameraChangeIMG: UIButton!
    @IBOutlet var layoutProfile: UIView!
    @IBOutlet var layoutName: UIStackView!
    @IBOutlet var layoutProfileIMG: UIView!
    
    
    //Make: properties
    var statusSwitch = 0
    var image:CIImage!
    var newImage:UIImage?
    var token: String?
    var profiles: [ProfileData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        onBindView()
        
        showLoading()
        ClientHttp.getInstace().requestProfile(token!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ProfileResponse") { (result) in
            let response = result.object as? ProfileResult

            if response?.success == "OK" {
                self.profiles = response?.profileData
                self.setProfileData()
            }
            
            self.hideLoading()
        }
    }
}

extension IDCardViewController {
    func onBindView(){
        let screenSize:Int = Int(UIScreen.main.bounds.width / 1.6)
        print(screenSize)
        
        if screenSize < 225 {
            let font = UIFont(name: baseFont, size: 18)
            let fontHeight = NSLayoutConstraint(item: fullNameEn, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            fullNameEn.font = font
            fullNameEn.addConstraint(fontHeight)
            
            let fontHeightTH = NSLayoutConstraint(item: fullNameTH, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
            fullNameTH.font = font
            fullNameTH.addConstraint(fontHeightTH)
        }
        
        userInformationTableView.setBaseTableStyle()

        setLayoutIMG(screenSize)
        setProfileIMG(screenSize)
        setIconQRCode(screenSize)
        setIconCamera(screenSize)
    }
    
    func setLayoutIMG(_ screenSize: Int) {
        let heightConstriant = NSLayoutConstraint(item: layoutProfileIMG, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(screenSize))
        let widthConstraint = NSLayoutConstraint(item: layoutProfileIMG, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(screenSize))
        
        var constantSize:CGFloat = 24
        
        if screenSize < 250 {
            constantSize = 16
        }
        
        let topConstriant = NSLayoutConstraint(item: layoutProfileIMG, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: layoutProfile, attribute: NSLayoutAttribute.top, multiplier: 1, constant: constantSize)
        let bottomConstriant = NSLayoutConstraint(item: layoutProfileIMG, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: layoutName, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -constantSize)
        
        layoutProfile.addConstraints([widthConstraint, heightConstriant,topConstriant, bottomConstriant])

        layoutProfileIMG.layer.cornerRadius = CGFloat(screenSize / 2)
        layoutProfileIMG.layer.borderColor = UIColor.lightGray.cgColor
        layoutProfileIMG.layer.borderWidth = 1
        layoutProfileIMG.backgroundColor = UIColor.white

    }
    
    func setProfileIMG(_ screenSize: Int) {
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
        switchIMG.clipsToBounds = true
        switchIMG.setImage(UIImage(named:"icon_qrcode"), for: .normal)
        switchIMG.addTarget(self, action: #selector(self.tapQrcode), for: .touchUpInside)
        
    }
    
    @objc func tapQrcode(sender: UIGestureRecognizer) {
        print("tap qrcode")
        let imgPerson = UIImage(named: "icon_person")
        let imgQrcode = UIImage(named: "icon_qrcode")
        
        switch statusSwitch {
        case 0:
            switchIMG.setImage(imgPerson, for: .normal)
            statusSwitch = 1
            
            qrcodeIMG.image = newImage
            userIMG.isHidden = true
            break
        default:
            userIMG.isHidden = false
            switchIMG.setImage(imgQrcode, for: .normal)
            statusSwitch = 0
            
            guard let url = URL(string: (profiles?[0].imgPath)!) else {
                userIMG?.image = UIImage(named: "people")
                return
            }
            
            userIMG?.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
            
            break
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            image = filter.outputImage
            
            let scaleX = userIMG.frame.size.width
            let scallY = userIMG.frame.size.height
            
            let transform = CGAffineTransform(scaleX: CGFloat(scaleX), y: CGFloat(scallY))
            
            if let output = image?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
        cameraChangeIMG.clipsToBounds = true
        cameraChangeIMG.setImage(UIImage(named:"icon_camera"), for: .normal)
        cameraChangeIMG.addTarget(self, action: #selector(self.tapCamera), for: .touchUpInside)
    }
    
    @objc func tapCamera(sender: UIGestureRecognizer){
        print("tap camera")
        actionGallary()
    }
    
    func actionGallary(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil)
        
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            
        }
        
        let takePhoto = UIAlertAction(title: "ถ่ายรูป", style: .default, handler: callActionHandler)
        
        let callGallary = {(action: UIAlertAction!) -> Void in
            self.callPhotoLibrary()
        }
        let gallary = UIAlertAction(title: "เลือกรูปจากอัลบั้ม", style: .default, handler: callGallary)
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(gallary)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func callPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension IDCardViewController {
    func setProfileData() {
        //set name user
        let firstName:String = (profiles?[0].firstNameTH)!
        let lastName:String = (profiles?[0].lastNameTH)!
        fullNameTH.text = ("\(firstName) \(lastName)")
        
        let firstNameEN:String = (profiles?[0].firstNameEN)!
        let lastNameEN:String = (profiles?[0].lastNameEN)!
        fullNameEn.text = ("\(firstNameEN) \(lastNameEN)")
        
        guard let url = URL(string: (profiles?[0].imgPath)!) else {
            userIMG?.image = UIImage(named: "people")
            return
        }
        
        //set image profile
        newImage = generateQRCode(from: (profiles?[0].personCard)!)
        userIMG?.af_setImage(withURL: url, placeholderImage: UIImage(named: "people") , filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5) , runImageTransitionIfCached: true, completion: nil)
        
        // set table view
        if screenWidth < screenHeight {
            userInformationTableView.rowHeight = 24
        }else{
            userInformationTableView.rowHeight = 36
        }

        userInformationTableView.dataSource = self
        userInformationTableView.reloadData()
    }
}

extension IDCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userIMG.image = selectImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension IDCardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell") as! IDCardTableViewCell
        
        if screenWidth < screenHeight {
            cell.userDetailLabel.font = UIFont(name: baseFont, size: 14)
        }
        
        switch indexPath.row {
        case 0:
            cell.userDetailLabel.text = "เลขประจำตัว  : " + (profiles?[0].personCard)!
            break
        case 1:
            cell.userDetailLabel.text = "มหาวิทยาลัย  : " + (profiles?[0].organization)!
            break
        case 2:
            cell.userDetailLabel.text = "คณะ  : " + (profiles?[0].department)!
            break
        case 3:
            cell.userDetailLabel.text = "สาขา  : " + (profiles?[0].section)!
            break
        case 4:
            cell.userDetailLabel.text = "อีเมล  : " + (profiles?[0].email)!
            break
        case 5:
            cell.userDetailLabel.text = "เบอร์ : " + (profiles?[0].mobileNo)!
            break
        default:
            break
        }
        
        return cell
    }
}
