//
//  ContactViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/16/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {

    @IBOutlet var contactList: UITableView!
    @IBOutlet var titleContact: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideBar()
        contactList.setBaseTableStyle()
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

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellContact") as! ContactTableViewCell
        
        cell.imgProfile.image = UIImage(named: "people")
        cell.nameUser.text = "ชโนทัย ดวงระหว้า"
        cell.subjectUser.text = "คณะ วิศวะกรรมศาสตร์"
        cell.btnPhone.addTarget(self, action: #selector(self.selectPhone), for: .touchUpInside)
        
        return cell
    }
    
    @objc func selectPhone(){
        let phone = "tel://\("0856607354")"
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
