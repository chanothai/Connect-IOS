//
//  DownloadFile.swift
//  Connect4.0
//
//  Created by Pakgon on 10/9/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

class DownloadFile {
    var controller: UIViewController?
    var fileURL:URL?
    
    init(_ controller: UIViewController) {
        self.controller = controller
    }
    
    func pdf(_ url: String) {
        let hud = MBProgressHUD.showAdded(to: (controller?.view)!, animated: true)
        hud.mode = MBProgressHUDMode.annularDeterminate
        hud.label.text = "Loading..."
        
        let fileName = url.components(separatedBy: "/")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentURL: NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            print("****DocumentUrl: ", documentURL)
            self.fileURL = documentURL.appendingPathComponent("\((fileName.last)!)")
            print("***FileURL: ", self.fileURL?.absoluteString ?? "")
            return (self.fileURL!, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).downloadProgress { (prog) in
            hud.progress = Float(prog.fractionCompleted)
        }.response { (response) in
            hud.hide(animated: true)
            if response.error == nil , let filePath = response.destinationURL?.path {
                print("Address: ", filePath)
                self.shareFile()
            }
        }
    }
    
    func shareFile() {
        if let fileURL = self.fileURL {
            let objectsToShare = [fileURL]
            let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            let excludedActivities = [UIActivityType.postToFlickr, UIActivityType.postToWeibo, UIActivityType.message, UIActivityType.mail, UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.saveToCameraRoll, UIActivityType.addToReadingList, UIActivityType.postToFlickr, UIActivityType.postToVimeo, UIActivityType.postToTencentWeibo]
            
            activityController.excludedActivityTypes = excludedActivities
            
            controller?.present(activityController, animated: true, completion: nil)
        }
    }
}
