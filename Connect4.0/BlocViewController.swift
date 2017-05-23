//
//  BlocViewController.swift
//  Connect4.0
//
//  Created by Chanothai Duangrahva on 5/21/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import IGListKit
import SWRevealViewController
import SwiftEventBus

class BlocViewController: BaseViewController {
    
    private var restoreInformation:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        setEventBus()
        initParameter()
    }
    
    private func initParameter(){
        restoreInformation = AuthenLogin().restoreLogin() //0 user, 1 token, 2 dynamickey
        let key = [UInt8](Data(base64Encoded: (restoreInformation?[2])!)!)
        RequireKey.key = key
        
        self.setModelUser(restoreInformation!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    private func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ResponseApplication"){
            (result) in
            let response:ApplicationResponse = result.object as! ApplicationResponse
            if response.success == "OK" {
                print(response.result.authToken)
                ClientHttp.getInstace().requestUserInfo(response.result.authToken)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "UserInfoResponse") { (result) in
            let response:UserInfoResponse = result.object as! UserInfoResponse
            ModelCart.getInstance().getUserInfo = response            
            self.hideLoading()
        }
    }
}

extension BaseViewController {
    func setModelUser(_ information:[String]){
        var application = [String: String]()
        application[ApplicationKey.clientID] = "abcdef"
        application[ApplicationKey.secret] = "123456"
        
        print(application)
        
        var user = [String:String]()
        user[ApplicationKey.token] = information[1]
        print(user)
        
        var request = [String:Any]()
        request[ApplicationKey.application] = application
        request[ApplicationKey.user] = user
        
        var requestUser = [String:String]()
        requestUser["username"] = information[0]
        
        self.showLoading()
        ClientHttp.getInstace().requestAuthToken(FormatterRequest(RequireKey.key).application(request, requestUser))
    }
}
