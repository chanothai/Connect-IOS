//
//  IDCardViewController.swift
//  Connect4.0
//
//  Created by Pakgon on 6/6/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class IDCardViewController: BaseViewController {

    //Make: outlet
    @IBOutlet var userIMG: UIImageView!
    @IBOutlet var switchIMG: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var userInformationTableView: UITableView!
    
    //Make: properties
    var userInfomation: UserInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideBar()
        // Do any additional setup after loading the view.
        fullNameLabel.text = userInfomation?.screenName
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
