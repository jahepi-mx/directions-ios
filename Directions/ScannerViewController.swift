//
//  ScannerViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ScannerViewController: UIViewController, CustomScannerListener {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var soundManager: SoundManager = SoundManager()
    var captured: Bool = false
    var scanner: CustomScanner!
    var strategy: ScannerStrategy!
    
    func setStrategy(strategy: ScannerStrategy) {
        self.strategy = strategy
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        scanner.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        scanner.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = CustomScanner(view: self.view, listener: self)
        scanner.load()
        
        messageLabel?.layer.masksToBounds = true
        messageLabel?.layer.cornerRadius = 5
        view.bringSubviewToFront(messageLabel)
        
        backBtn.backgroundColor = UIColor.init(red: 35/255, green: 129/255, blue: 226/255, alpha: 1)
        backBtn.layer.cornerRadius = 20
        backBtn.layer.borderWidth = 1
        backBtn.layer.borderColor = UIColor.whiteColor().CGColor
        view.bringSubviewToFront(backBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onCaptureCode(code: String) {
        if (captured == false) {
            captured = true;
            soundManager.playScanner()
            let viewController: UIViewController = strategy.go(code)
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickBackBtn(sender: AnyObject) {
        let viewController: UIViewController = strategy.back()
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanner.update()
    }
}