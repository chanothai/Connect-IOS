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
    @IBOutlet var qrcodeIMG: UIImageView!
    @IBOutlet var switchIMG: UIButton!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var userInformationTableView: UITableView!
    @IBOutlet var fullNameEn: UILabel!
    @IBOutlet var cameraChangeIMG: UIButton!
    @IBOutlet var layoutProfile: UIView!
    @IBOutlet var layoutName: UIStackView!
    @IBOutlet var layoutProfileIMG: UIView!
    
    
    //Make: properties
    var userInfomation: UserInfoResponse?
    var statusSwitch = 0
    var image:CIImage!
    var newImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        setView()
        newImage = generateQRCode(from: "1719900291478")!
        
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
            
            userIMG.image = UIImage(named: "people")
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell") as! IDCardTableViewCell
        cell.userDetailLabel.text = "Test"
        
        return cell
    }
}
