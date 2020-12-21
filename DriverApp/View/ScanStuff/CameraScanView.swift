//
//  CameraScanView.swift
//  DriverApp
//
//  Created by Indo Office4 on 30/11/20.
//

import UIKit
import AVFoundation

class CameraScanView: UIViewController {
    
    //props
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    
    var list: [PickupItem]!
    weak var delegate: ListScanView!
    
    //scan camera
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avCaptureSession = AVCaptureSession()
        qrCodeFrameView = UIView()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        let avVideoInput: AVCaptureDeviceInput
        
        do {
            avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
                qrCodeFrameView.center = view.center
            }
        } catch {
            failed()
            return
        }
        
        if (avCaptureSession.canAddInput(avVideoInput)) {
            avCaptureSession.addInput(avVideoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (avCaptureSession.canAddOutput(metadataOutput)) {
            avCaptureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
        } else {
            failed()
            return
        }
        
        avPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avPreviewLayer.frame = view.layer.bounds
        avPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(avPreviewLayer)
        //                    self.avCaptureSession.startRunning()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported".localiz(), message: "Please use a device with a camera. Because this device does not support scanning a code".localiz(), preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
}


extension CameraScanView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        
        let find = list.filter({ $0.qr_code_raw == code })
        if find.count == 0 {
            let action1 = UIAlertAction(title: "Try again", style: .default) {[weak self]  (_) in
                self?.avCaptureSession.startRunning()
            }
            Helpers().showAlert(view: self, message: "Something when wrong !, Item code not found.".localiz(), customAction1: action1)
        }else {
            delegate.updateList(code: code)
            navigationController?.popViewController(animated: true)
        }
        
    }
}
