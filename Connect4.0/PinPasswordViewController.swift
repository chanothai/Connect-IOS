//
//  PinPasswordViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/12/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SmileLock

class PinPasswordViewController: BaseViewController {

    //Make: outlet
    @IBOutlet var pinPasswordLayout: UIView!
    @IBOutlet var titlePinLabel: UILabel!
    
    //Make: Properties
    let kPasswordDigit = 6
    var hasPin:Bool? = false
    var pinPassword:String?
    var blurEffectView:UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinPassword = checkPinPassword("")
        setBackground()
        createPinPassword()
        
        if screenSize < baseScreen {
            titlePinLabel.font = UIFont(name: "supermarket", size: 24.0)
        }
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

extension PinPasswordViewController: PasswordInputCompleteProtocol {
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            //authentication success
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "showMainBloc", sender: nil)
            }
        }else{
            passwordContainerView.clearInput()
        }
    }

    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        print("input complete -> \(input)")
        //Handler validate wrong || success
        if hasPin! {
            if input == pinPassword {
                AuthenLogin().storePinPassword(input)
                intentToBloc()
            }else{
                titlePinLabel.text = setTitlePin(3)
                passwordContainerView.wrongPassword()
            }
        }else{
            DispatchQueue.main.async {
                self.titlePinLabel.text = self.setTitlePin(1)
            }
            
            hasPin = true
            pinPassword = checkPinPassword(input)
            passwordContainerView.clearInput()
        }
    }
}

extension PinPasswordViewController {
    func createPinPassword() {
        let passwordContainerView = PasswordContainerView.create(withDigit: kPasswordDigit)
        passwordContainerView.frame = CGRect(x: 0, y: 0, width: pinPasswordLayout.frame.width, height: pinPasswordLayout.frame.height)
        passwordContainerView.tintColor = UIColor(colorLiteralRed: 136/255, green: 152/255, blue: 174/255, alpha: 0.2)
        passwordContainerView.highlightedColor = UIColor(colorLiteralRed: 70/255, green: 88/255, blue: 110/255, alpha: 1)
        passwordContainerView.isVibrancyEffect = false
        passwordContainerView.deleteButtonLocalizedTitle = "ลบ"
        passwordContainerView.delegate = self
        passwordContainerView.showTouchDialog()
        pinPasswordLayout.addSubview(passwordContainerView)

    }
    
    func setBackground() {
        let color1 = UIColor(colorLiteralRed: 57/255, green: 65/255, blue: 75/255, alpha: 1)
        let color2 = UIColor(colorLiteralRed: 114/255, green: 124/255, blue: 137/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor , color2.cgColor]
        gradientLayer.frame = view.frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        view.insertSubview(blurEffectView!, at: 1)
    }
    
    func checkPinPassword(_ input: String) -> String {
        let pin = AuthenLogin().restorePinPassword()
        
        if  pin != "" {
            titlePinLabel.text = setTitlePin(1)
            hasPin = true
        }else{
            titlePinLabel.text = setTitlePin(0)
            return input
        }
        
        return pin
    }
    
    func setTitlePin(_ status: Int) -> String {
        var title:String?
        
        switch status {
        case 0:
            title = "สร้างรหัสผ่าน"
            break
        case 1:
            title = "ยืนยันรหัสผ่าน"
            break
        default:
            title = "ลองอีกครั้ง"
            break
        }
        
        return title!
    }
    
    func intentToBloc() {
        performSegue(withIdentifier: "showMainBloc", sender: nil)
    }
}
