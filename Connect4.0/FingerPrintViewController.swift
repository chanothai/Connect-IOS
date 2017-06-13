//
//  FingerPrintViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/9/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import LocalAuthentication

class FingerPrintViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateWithTouchID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticateWithTouchID() {
        //Get the local authentication context.
        let localAuthContext = LAContext()
        let reasonText = "เช้าใช้งานด้วย Touch ID หรือกดปุ่ม \("ยกเลิก") เพื่อระบุรหัสผ่าน"
        var authError: NSError?
        
        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
            if let error = authError {
                print(error.localizedDescription)
            }
            
            //Display login dialog when touch id is not available
            
            return
        }
        
        //Perform the touch id authentication
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText) { (success: Bool, error: Error?) in
            //Failure workflow
            if !success {
                if let error = error {
                    switch error {
                    case LAError.authenticationFailed:
                        print("Authentication Failed")
                    case LAError.passcodeNotSet:
                        print("Passcode not set")
                    case LAError.systemCancel:
                        print("Authentication was canceled by system")
                        // Fallback to password Authentication
                        
                    case LAError.userCancel:
                        print("Authentication was canceled by user")
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "showPinPassword", sender: nil)
                        }
                        
                    case LAError.touchIDNotEnrolled:
                        print("Authentication cloud not start because Touch ID has no enrolled your fingers.")
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "showPinPassword", sender: nil)
                        }
                        
                    case LAError.touchIDNotAvailable:
                        print("Authentication cloud not start because Touch ID is not available")
                    case LAError.userFallback:
                        print("User tapped the fallback button (Enter password).")
                    default:
                        print(error.localizedDescription)
                    }
                }
            }else{
                //Success work flow
                
                print("Successfully authentication")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "showHomeScreen", sender: nil)
                }
            }
        }
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
