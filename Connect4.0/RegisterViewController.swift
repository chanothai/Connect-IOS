//
//  ViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/5/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import SwiftEventBus
import UIKit

class RegisterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MAKE outlet
    @IBOutlet var registerTableView: UITableView!
    
    // MAKE instance properties
    var dateTextField: UITextField!
    var arrCellData:[CellData]!
    var arrTextField:[String]!
    var manageKeyboard: ManageKeyboard? = ManageKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initParamater()
        StyleTableView(registerTableView).baseStyle()
        iniArrayTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    private func initParamater(){
        arrCellData = [CellData]()
        arrCellData = CellData().createArrRegisterCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        SwiftEventBus.unregister(self)
    }
    
    private func iniArrayTextField(){
        arrTextField = [String]()
        
        for _ in 0 ..< 9 {
            arrTextField.append("")
        }
    }
    
    func setMoveKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        manageKeyboard?.adjustingHeight(show: true, notification: notification, tableView: registerTableView)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        manageKeyboard?.adjustingHeight(show: true, notification: notification, tableView: registerTableView)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrCellData[indexPath.row].cell == 8 {
            let cell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as! ButtonCell
            cell.confirmBtn.setTitle(arrCellData[indexPath.row].text, for: .normal)
            cell.confirmBtn.addTarget(self, action: #selector(self.doRegister), for: .touchUpInside)
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.inputData.placeholder = arrCellData[indexPath.row].text
            cell.inputData.delegate = self
            cell.inputData.inputAccessoryView = addDoneOnKeyBoard()
            
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
            
            if !arrTextField[indexPath.row].isEmpty {
                cell.inputData.text = arrTextField[indexPath.row]
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        arrTextField[getPosition(textField)] = textField.text! + string
        return true
    }
    
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
    
    
    private func getPosition(_ textField: UITextField) -> Int{
        let pointInTable = textField.convert(textField.bounds.origin, to: registerTableView)
        let textFieldIndexPath = registerTableView.indexPathForRow(at: pointInTable)
        
        return (textFieldIndexPath?.row)!
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
    
    @objc private func doRegister() {
        let users = UserRegister()
        var parameters = [String : String]()
        parameters[users.citizenID] = arrTextField[0]
        parameters[users.firstName] = arrTextField[1]
        parameters[users.lastName]  = arrTextField[2]
        parameters[users.screenName] = "\(arrTextField[1]) \(arrTextField[2])"
        parameters[users.birthDate] = arrTextField[3]
        parameters[users.phone] = arrTextField[4]
        parameters[users.username] = arrTextField[5]
        parameters[users.password] = arrTextField[6]
        parameters[users.rePassword] = arrTextField[7]
        
        var jsonData = [String : Any]()
        jsonData[RegisterRequest().user] = parameters
        print(jsonData)
        
        showLoading()
        ClientHttp.getInstace(self).requestRegister(jsonData)
    }
    
    private func setEventBus(){
        SwiftEventBus.onMainThread(self, name: "ResponseRegister") { result in
            let response:LoginResponse = result.object as! LoginResponse
            
            if response.result.success.isEmpty{
                AlertMessage.getInstance(self).showMessage(title: "Register", message: response.result.error, isAction: false)
            }else{
                AlertMessage.getInstance(self).showMessage(title: "Register", message: response.result.success, isAction: true)
            }
            
            self.hideLoading()
        }
    }
}

