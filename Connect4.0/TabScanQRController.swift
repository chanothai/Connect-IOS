//
//  TabScanQRController.swift
//  Connect4.0
//
//  Created by Pakgon on 11/15/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftEventBus

class TabScanQRController: BaseViewController {

    //Make: outlet
    @IBOutlet var screenScan: UIImageView!
    
    
    //Make: Properties
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var token: String?
    var photo = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createVideoCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photo = 0
        setSwiftEventBus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
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

extension TabScanQRController {
    func setSwiftEventBus(){
        SwiftEventBus.onMainThread(self, name: "ResponseScanQR") { (result) in
            let response = result.object as? ResponseScanQR
            if response?.status == "Success" {
                if !(response?.result?.data?.url?.isEmpty)! {
                    print("Url : \((response?.result?.data?.url)!)")
                    
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let blocContent = storyBoard.instantiateViewController(withIdentifier: "ShowBlocDetail") as! BlocContentViewController
                    blocContent.urlBloc = "http://\((response?.result?.data?.url)!)"
                    blocContent.titleName = ""
                    let nav = UINavigationController(rootViewController: blocContent)
                    self.tabBarController?.show(nav, sender: self)
                    
                }else{
                    print("Message: \((response?.result?.data?.message)!)")
                    AlertMessage(self).showMessageScan(title: "Add Success", message:(response?.result?.data?.message)!, isAction: true)
                }
                
                self.hideLoading()
            }else{
                print(response?.status! ?? "")
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "SubmissComplete") { (result) in
            let actionOK = result.object as? Bool
            if actionOK! {
                self.photo = 0
            }
        }
    }
    
    func createVideoCapture() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutPut = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutPut)
            
            captureMetadataOutPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutPut.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            // set layout show font of camera
            view.bringSubview(toFront: screenScan)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
    }
}

extension TabScanQRController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            photo += 1
            
            if metadataObj.stringValue != nil {
                if photo == 1 {
                    print(metadataObj.stringValue)
                    
                    let value = metadataObj.stringValue.components(separatedBy: "|")
                    if value.count > 1 {
                        var parameters = [String: String]()
                        parameters["code"] = metadataObj.stringValue
                        
                        showLoading()
                        RequestScanQR().request(parameter: parameters)
                    }else{
                        let alertController = UIAlertController(title: "Message", message: "QRCode was incorrect.", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.photo = 0
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
