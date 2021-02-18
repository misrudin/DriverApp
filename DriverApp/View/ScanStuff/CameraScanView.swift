//
//  CameraScanView.swift
//  DriverApp
//
//  Created by Indo Office4 on 30/11/20.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class CameraScanView: UIViewController {
    
    //props
    var orderNo: String = ""
    var orderVm = OrderViewModel()
    
    var codeQr: String = ""
    var extra: Bool = false
    var allScans = [ScanFree]()
    weak var delegate: ListScanView!
    
    //scan camera
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avCaptureSession = AVCaptureSession()
        qrCodeFrameView = UIView()
        view.backgroundColor = UIColor(named: "whiteKasumi")
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        let avVideoInput: AVCaptureDeviceInput
        
        do {
            avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
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
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
            qrCodeFrameView.translatesAutoresizingMaskIntoConstraints = false
            qrCodeFrameView.centerX(toAnchor: view.centerXAnchor)
            qrCodeFrameView.centerY(toAnchor: view.centerYAnchor)
            qrCodeFrameView.height(200)
            qrCodeFrameView.width(200)
        }
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
        ac.addAction(UIAlertAction(title: "Back".localiz(), style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Input Manual", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
            self.delegate.useManualInput(orderNo: self.orderNo, codeQr: self.codeQr, extra: self.extra, scans: self.allScans)
        }))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    
}


@available(iOS 13.0, *)
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
        let find = allScans.filter({$0.qr_code_url == code})
        if extra {
            if find.count == 0 {
                let action1 = UIAlertAction(title: "Try again".localiz(), style: .default) {[weak self]  (_) in
                    self?.avCaptureSession.startRunning()
                }
                Helpers().showAlert(view: self, message: "Item code not found.".localiz(), customAction1: action1)
            }else {
                delegate.updateList(code: code, orderNo: find[0].order_number)
                navigationController?.popViewController(animated: true)
            }
        }else {
            if code != codeQr {
                let action1 = UIAlertAction(title: "Try again".localiz(), style: .default) {[weak self]  (_) in
                    self?.avCaptureSession.startRunning()
                }
                Helpers().showAlert(view: self, message: "Item code not found.".localiz(), customAction1: action1)
            }else {
                delegate.updateList(code: code, orderNo: orderNo)
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
