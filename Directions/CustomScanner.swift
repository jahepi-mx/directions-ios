//
//  CustomScanner.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 18/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class CustomScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var view: UIView!
    var listener: CustomScannerListener!
    
    init (view: UIView, listener: CustomScannerListener) {
        self.view = view
        self.listener = listener
    }
    
    func load() {
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        //error:NSError?
        var input: AnyObject!
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        }  catch let error as NSError {
            print(error)
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [
            AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        captureSession?.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No se reconoce código"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        //if metadataObj.type == AVMetadataObjectTypeQRCode {
        // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
        let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
        qrCodeFrameView?.frame = barCodeObject.bounds
        
        if metadataObj.stringValue != nil {
            let code: String = metadataObj.stringValue
            listener.onCaptureCode(code)
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }
    
    func update() {
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.currentDevice()
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if (previewLayerConnection.supportsVideoOrientation) {
                switch (orientation) {
                case .Portrait: updatePreviewLayer(previewLayerConnection, orientation: .Portrait); break
                case .LandscapeRight: updatePreviewLayer(previewLayerConnection, orientation: .LandscapeLeft); break
                case .LandscapeLeft: updatePreviewLayer(previewLayerConnection, orientation: .LandscapeRight); break
                case .PortraitUpsideDown: updatePreviewLayer(previewLayerConnection, orientation: .PortraitUpsideDown);break
                default: updatePreviewLayer(previewLayerConnection, orientation: .Portrait); break
                }
            }
        }
    }
    
    func start() {
        captureSession?.startRunning()
    }
    
    func stop() {
        captureSession?.stopRunning()
    }
}
