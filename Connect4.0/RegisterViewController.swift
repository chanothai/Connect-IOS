//
//  ViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 5/5/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Alamofire
import UIKit

class RegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MAKE outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet var registerTableView: UITableView!
    
    // MAKE instance properties
    var dateTextField: UITextField!
    var arrCellData:[CellData]!
    var arrTextField:[String]!
    var manageKeyboard: ManageKeyboard? = ManageKeyboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initParamater()
        setTableProperty()
        iniArrayTextField()
    }
    
    func initParamater(){
        arrCellData = [CellData]()
        arrCellData = CellData().createCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func iniArrayTextField(){
        arrTextField = [String]()
        
        for _ in 0 ..< 9 {
            arrTextField.append("")
        }
    }
    
    func setTableProperty() {
        registerTableView.backgroundColor = UIColor.white
        registerTableView.tableFooterView = UIView(frame: CGRect.zero) //remove empty rows of table
        registerTableView.separatorColor = UIColor.clear
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
            }else if arrCellData[indexPath.row].cell == 3 {
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.date
                cell.inputData.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
                
                dateTextField = cell.inputData
                
            }else if arrCellData[indexPath.row].cell == 5 {
                cell.inputData.keyboardType = UIKeyboardType.emailAddress
            }else if arrCellData[indexPath.row].cell == 6 || arrCellData[indexPath.row].cell == 7 {
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
        if getPosition(textField) == 4 {
            if let selectedRange = textField.selectedTextRange {
                // get cursor position of text field
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start);
                let resultString:String = textField.text! + "-"
                
                switch cursorPosition {
                case 3:
                    textField.text = resultString
                    break
                case 8:
                    textField.text = resultString
                    break
                default:
                    break
                }
            }
        }
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        arrTextField[getPosition(textField)] = textField.text!
    }
    
    func getPosition(_ textField: UITextField) -> Int{
        let pointInTable = textField.convert(textField.bounds.origin, to: registerTableView)
        let textFieldIndexPath = registerTableView.indexPathForRow(at: pointInTable)
        
        return (textFieldIndexPath?.row)!
    }
    
    func addDoneOnKeyBoard() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        return toolBar
    }
    
    func doneClicked(){
        view.endEditing(true)
        registerTableView.contentOffset = CGPoint(x: registerTableView.contentOffset.x , y: 0)
    }
    
    func doRegister() {
        let users = User()
        var paramaters = [String : String]()
        paramaters[users.citizenID] = arrTextField[0]
        paramaters[users.firstName] = arrTextField[1]
        paramaters[users.lastName]  = arrTextField[2]
        paramaters[users.screenName] = "\(arrTextField[1]) \(arrTextField[2])"
        paramaters[users.birthDate] = arrTextField[3]
        paramaters[users.phone] = arrTextField[4]
        paramaters[users.username] = arrTextField[5]
        paramaters[users.password] = arrTextField[6]
        paramaters[users.rePassword] = arrTextField[7]
        
        var jsonData = [String : Any]()
        jsonData[RegisterRequest().user] = paramaters
        print(jsonData)
        
        LoadIndicator.getInstance(self).showLoadingDialog()
        ClientHttp.getInstace().requestRequest(jsonData)
        LoadIndicator.getInstance(self).dissmissLoadingDialog()
    }
}

