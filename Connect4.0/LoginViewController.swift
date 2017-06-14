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

class LoginViewController: BaseViewController {

    // MAKE: outlet variable
    @IBOutlet var loginTableView: UITableView!
    @IBOutlet var createAccountLabel: UILabel!
    
    // MAKE: properties
    var arrCellData:[CellData]!
    var arrDataRequest:[String]!
    var key:[UInt8]?
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var manageKeyboard: ManageKeyboard? = ManageKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniProperties()
        loginTableView.setBaseTableStyle()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    private func iniProperties(){
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
                AuthenLogin().storeLogin(self.arrDataRequest[0], response.result.token, response.result.dynamicKey)
                self.intentToBloc()
            }
            
            self.hideLoading()
        }
        
        SwiftEventBus.onMainThread(self, name: "LoginSuccess") { result in
            let response:Bool = result.object as! Bool
            print(response)
            if response {
                self.intentToBloc()
            }
        }
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
        let navRegisterController = storyBoard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterViewController
        self.present(navRegisterController, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func intentToBloc() {
        performSegue(withIdentifier: "showMainController", sender: nil)
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            
            if screenSize < baseScreen {
                cell.confirmBtn.titleLabel?.font = UIFont(name: baseFont, size: 20)
            }
            
            return cell
        }
        else if arrCellData[indexPath.row].cell == 3 {
            let cell = Bundle.main.loadNibNamed("ForgotCell", owner: self, options: nil)?.first as! ForgotPasswordTableViewCell
            cell.forgotpasswordLabel.text = arrCellData[indexPath.row].text
            cell.forgotpasswordLabel.isUserInteractionEnabled = true
            cell.forgotpasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapForgotPassword)))
            
            return cell
        }
            
        else{
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.inputData.placeholder = arrCellData[indexPath.row].text
            cell.inputData.delegate = self
            cell.inputData.addTarget(self, action: #selector(self.textFieldChange), for: UIControlEvents.editingChanged)
            
            if screenSize < baseScreen {
                cell.inputData.font = UIFont(name: baseFont, size: 20)
            }
            
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
            
            cell.inputData.text = arrDataRequest[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            if screenSize < baseScreen {
                return 72
            }
            return 88
        }else if indexPath.row == 3 {
            return 36
        }
        
        if screenSize <= baseScreen {
            return 56
        }
        
        return 72
    }
    
    @objc private func doLogin(){
        var parameters = [String: String]()
        parameters[UserLogin.username] = arrDataRequest[0]
        parameters[UserLogin.password] = arrDataRequest[1]
        
        //        showLoading()
        //        ClientHttp.getInstace().requestLogin(FormatterRequest(key!).login(parameters))
        intentToBloc()
    }
    
    @objc func tapForgotPassword(sender: UITapGestureRecognizer) {
        let forgotController = storyboard?.instantiateViewController(withIdentifier: "NavForgotPassword") as! NavForgotPasswordNavigationController
        self.show(forgotController, sender: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to: loginTableView)
        var contentOffset:CGPoint = loginTableView.contentOffset
        contentOffset.y = pointInTable.y
        
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        
        loginTableView.contentOffset = contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        loginTableView.contentOffset = CGPoint(x: loginTableView.contentOffset.x, y: 0)
        return false
    }
}
