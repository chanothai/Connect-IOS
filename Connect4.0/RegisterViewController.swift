//
//  ViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/5/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import SwiftEventBus
import UIKit

class RegisterViewController: BaseViewController {

    // MAKE outlet
    @IBOutlet var registerTableView: UITableView!
    @IBOutlet var signInLabel: UILabel!
    @IBOutlet var titleTable: UILabel!
    
    // MAKE instance properties
    var dateTextField: UITextField!
    var arrCellData:[CellData]!
    var arrTextField:[String]!
    private var key:[UInt8]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initParamater()
        registerTableView.setBaseTableStyle()
        iniArrayTextField()
        
        key = [UInt8](Data(base64Encoded: KeyName.staticKey)!)
        RequireKey.key = key!
        
        signInLabel.isUserInteractionEnabled = true
        signInLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSignIn)))
        
        resizeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        SwiftEventBus.unregister(self)
    }
    
    func tapSignIn(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        arrTextField[getPosition(dateTextField)] = dateTextField.text!
    }
    
    @objc func textFieldChange(textField: UITextField){
        arrTextField[getPosition(textField)] = textField.text!
    }
    
    private func getPosition(_ textField: UITextField) -> Int{
        let pointInTable = textField.convert(textField.bounds.origin, to: registerTableView)
        let textFieldIndexPath = registerTableView.indexPathForRow(at: pointInTable)
        
        return (textFieldIndexPath?.row)!
    }
    
    private func setEventBus(){
        SwiftEventBus.onMainThread(self, name: "ResponseRegister") { result in
//            let response:LoginResponse = result.object as! LoginResponse
            
//           if response.result.success.isEmpty{
//                AlertMessage.getInstance(self).showMessageAuthen(title: "Register", message: response.result.error, isAction: false)
//            }else{
//                AlertMessage.getInstance(self).showMessageAuthen(title: "Register", message: response.result.success, isAction: true)
//            }
            self.hideLoading()
        }
    }
}

extension RegisterViewController {
    func initParamater(){
        arrCellData = [CellData]()
        arrCellData = CellData().createArrRegisterCell()
    }
    
    func iniArrayTextField(){
        arrTextField = [String]()
        
        for _ in 0 ..< 9 {
            arrTextField.append("")
        }
    }
    
    func resizeView() {
        titleTable.text = "ลงทะเบียน"
        if screenSize < baseScreen {
            titleTable.font = UIFont(name: baseFont, size: 36)
        }
    }
}

extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to: registerTableView)
        var contentOffset:CGPoint = registerTableView.contentOffset
        contentOffset.y = pointInTable.y
        
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        
        registerTableView.contentOffset = contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

extension RegisterViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrCellData[indexPath.row].cell == 8 {
            let cell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as! ButtonCell
            cell.confirmBtn.setTitle(arrCellData[indexPath.row].text, for: .normal)
            cell.confirmBtn.addTarget(self, action: #selector(self.doRegister), for: .touchUpInside)
            
            if screenSize < baseScreen {
                cell.confirmBtn.titleLabel?.font = UIFont(name: baseFont, size: 20)
            }
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.inputData.placeholder = arrCellData[indexPath.row].text
            cell.inputData.delegate = self
            cell.inputData.inputAccessoryView = addDoneOnKeyBoard()
            cell.inputData.addTarget(self, action: #selector(self.textFieldChange), for: UIControlEvents.editingChanged)
            
            if screenSize < baseScreen {
                cell.inputData.font = UIFont(name: baseFont, size: 20)
            }
            
            if arrCellData[indexPath.row].cell == 0 || arrCellData[indexPath.row].cell == 4 {
                cell.inputData.keyboardType = UIKeyboardType.numberPad
            }
            else if arrCellData[indexPath.row].cell == 3 {
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.date
                cell.inputData.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
                
                dateTextField = cell.inputData
                
            }
            else if arrCellData[indexPath.row].cell == 5 {
                cell.inputData.keyboardType = UIKeyboardType.emailAddress
            }
            else if arrCellData[indexPath.row].cell == 6 || arrCellData[indexPath.row].cell == 7 {
                cell.inputData.isSecureTextEntry = true
            }
            
            cell.inputData.text = arrTextField[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 8 {
            if screenSize < baseScreen {
                return 72
            }
            
            return 88
        }
        
        if screenSize <= baseScreen {
            return 56
        }
        
        return 72
    }
    
    @objc private func doRegister() {
        var parameters = [String : String]()
        parameters[UserRegister.citizenID] = arrTextField[0]
        parameters[UserRegister.firstName] = arrTextField[1]
        parameters[UserRegister.lastName]  = arrTextField[2]
        parameters[UserRegister.screenName] = "\(arrTextField[1]) \(arrTextField[2])"
        parameters[UserRegister.birthDate] = arrTextField[3]
        parameters[UserRegister.phone] = arrTextField[4]
        parameters[UserRegister.username] = arrTextField[5]
        parameters[UserRegister.password] = arrTextField[6]
        parameters[UserRegister.rePassword] = arrTextField[7]
        
        showLoading()
        ClientHttp.getInstace().requestRegister(FormatterRequest(RequireKey.key).register(parameters))
    }
    
    private func addDoneOnKeyBoard() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        return toolBar
    }
    
    @objc private func doneClicked(){
        view.endEditing(true)
        registerTableView.contentOffset = CGPoint(x: registerTableView.contentOffset.x , y: 0)
    }

}

