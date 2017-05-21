//
//  LoginViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/18/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import CryptoSwift
import SwiftEventBus
import UIKit
import SWRevealViewController

class LoginViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MAKE: outlet variable
    @IBOutlet var loginTableView: UITableView!
    @IBOutlet var createAccountLabel: UILabel!
    
    // MAKE: properties
    private var arrCellData:[CellData]!
    private var arrDataRequest:[String]!
    private var key:[UInt8]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniProperties()
        StyleTableView(loginTableView).baseStyle()
        setLabelAction()
    
        key = [UInt8](Data(base64Encoded: KeyName.staticKey)!)
        RequireKey.key = key!
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    private func iniProperties(){
        arrCellData = [CellData]()
        arrCellData = CellData().createArrLoginCell()
        arrDataRequest = [String]()
        
        for _ in 0 ..< 2 {
            self.arrDataRequest.append("")
        }
    }
    
    private func setEventBus(){
        SwiftEventBus.onMainThread(self, name: "ResponseLogin") { result in
            let response:LoginResponse = result.object as! LoginResponse
            if response.result.success.isEmpty{
                AlertMessage.getInstance(self).showMessageAuthen(title: "Login", message: response.result.error, isAction: false)
            }else{
                AuthenLogin().storeLogin(self.arrDataRequest[0], self.arrDataRequest[1], KeyName.staticKey)
                AlertMessage.getInstance(self).showMessageAuthen(title: "Login", message: response.result.success, isAction: true)
            }
            
            self.hideLoading()
        }
        
        SwiftEventBus.onMainThread(self, name: "LoginSuccess") { result in
            let response:Bool = result.object as! Bool
            if response {
                self.intentToBloc()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCellData.count > 0 {
            return arrCellData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrCellData[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as! ButtonCell
            cell.confirmBtn.setTitle(arrCellData[indexPath.row].text, for: .normal)
            cell.confirmBtn.addTarget(self, action: #selector(self.doLogin), for: .touchUpInside)
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.inputData.placeholder = arrCellData[indexPath.row].text
            cell.inputData.delegate = self
            cell.inputData.addTarget(self, action: #selector(self.textFieldChange), for: UIControlEvents.editingChanged)
            
            switch arrCellData[indexPath.row].cell {
            case 0:
                cell.inputData.keyboardType = UIKeyboardType.emailAddress
                break
            case 1:
                cell.inputData.isSecureTextEntry = true
                break
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    @objc private func doLogin(){
        var parameters = [String: String]()
        parameters[UserLogin.username] = arrDataRequest[0]
        parameters[UserLogin.password] = arrDataRequest[1]
        
        showLoading()
        ClientHttp.getInstace(self).requestLogin(FormatterRequest(key!).login(parameters))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @objc func textFieldChange(textField:UITextField) {
        arrDataRequest[getPosition(textField)] = textField.text!
    }
    
    private func getPosition(_ textField:UITextField) -> Int {
        let pointInTable = textField.convert(textField.bounds.origin, to: loginTableView)
        let textFieldIndexPath = loginTableView.indexPathForRow(at: pointInTable)
        
        return (textFieldIndexPath?.row)!
    }

    private func setLabelAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionToCreateAccount))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tap)
    }
    
    @objc private func actionToCreateAccount(sender: UIGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navRegisterController = storyBoard.instantiateViewController(withIdentifier: "NavRegisterController") as! NavRegisterController
        self.present(navRegisterController, animated: true, completion: nil)
    }
}

extension UIViewController {
    func intentToBloc() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navRegisterController = storyBoard.instantiateViewController(withIdentifier: "RevealController") as! SWRevealViewController
        self.present(navRegisterController, animated: true, completion: nil)
    }
}
