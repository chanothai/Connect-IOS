//
//  ContactViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/16/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus

class ContactViewController: BaseViewController {

    @IBOutlet var contactList: UITableView!
    @IBOutlet var titleContact: UILabel!
    
    // Make: properties
    var token: String?
    var persons: [UserPersonal]?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideBar()
        contactList.setBaseTableStyle()
        
        showLoading()
        ClientHttp.getInstace().requestContactList(token!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    

    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "ContactResponse") { (result) in
            let response: ResultContact = (result.object as? ResultContact)!
            if response.success == "OK" {
                self.persons = response.data
                self.contactList.delegate = self
                self.contactList.dataSource = self
                self.contactList.reloadData()
                self.hideLoading()
            }
        }
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (persons?.count)! > 0 {
            return (persons?.count)!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContact") as! ContactTableViewCell
        
        self.index = indexPath.row
        
        cell.imgProfile.image = UIImage(named: "people")
        cell.nameUser.text = ("\((persons?[indexPath.row].firstNameTH)!) \((persons?[indexPath.row].lastNameTH)!)")
        cell.subjectUser.text = "คณะ วิศวะกรรมศาสตร์"
        cell.btnPhone.addTarget(self, action: #selector(self.selectPhone), for: .touchUpInside)
        
        return cell
    }
    
    @objc func selectPhone(){
        let phone = "tel://\((persons?[index!].phone)!)"
        print(phone)
        guard let number = URL(string: phone) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
    }
}
