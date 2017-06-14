//
//  ForgotPasswordViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/14/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    //MAKE: Outlet
    @IBOutlet var titleTable: UILabel!
    @IBOutlet var forgotPassTable: UITableView!
    
    //MAKE: Properties
    var arrCellData:[CellData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrCellData = CellData().createListForgot()
        forgotPassTable.setBaseTableStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLoginScreen(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ForgotPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (arrCellData?.count)! > 0 {
            return (arrCellData?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)?.first as! ButtonCell
            cell.confirmBtn.setTitle(arrCellData![indexPath.row].text, for: .normal)
            print(arrCellData![indexPath.row].text)
            
            if screenSize < baseScreen {
                cell.confirmBtn.titleLabel?.font = UIFont(name: baseFont, size: 20)
            }
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("TextFieldCell", owner: self, options: nil)?.first as! TextFieldCell
            cell.inputData.placeholder = arrCellData![indexPath.row].text
            
            if screenSize < baseScreen {
                cell.inputData.font = UIFont(name: baseFont, size: 20)
            }
            
            if indexPath.row == 0 {
                cell.inputData.keyboardType = UIKeyboardType.numberPad
            }else{
                cell.inputData.keyboardType = UIKeyboardType.emailAddress
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            if screenSize < baseScreen {
                return 72
            }
            return 88
        }
        
        if screenSize < baseScreen {
            return 56
        }
        
        return 72
    }
}
