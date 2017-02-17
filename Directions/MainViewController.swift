//
//  ViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class MainViewController: UIViewControllerPortrait {

    @IBOutlet weak var scannerBtn: UIButton!
    @IBOutlet weak var scanner2Btn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var transferBtn: UIButton!
    
    @IBAction func onClickScanner(sender: AnyObject) {
        let strategy: ProductViewStrategy = ProductViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickScanner2(sender: AnyObject) {
        let strategy: PTViewStrategy = PTViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)

    }
    
    @IBAction func onClickExit(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 38/255, green: 108/255, blue: 166/255, alpha: 1)
        scannerBtn.backgroundColor = UIColor.whiteColor()
        scannerBtn.layer.cornerRadius = 20
        scannerBtn.layer.borderWidth = 1
        scannerBtn.layer.borderColor = UIColor.whiteColor().CGColor
        scanner2Btn.backgroundColor = UIColor.whiteColor()
        scanner2Btn.layer.cornerRadius = 20
        scanner2Btn.layer.borderWidth = 1
        scanner2Btn.layer.borderColor = UIColor.whiteColor().CGColor
        transferBtn.backgroundColor = UIColor.whiteColor()
        transferBtn.layer.cornerRadius = 20
        transferBtn.layer.borderWidth = 1
        transferBtn.layer.borderColor = UIColor.whiteColor().CGColor
        exitBtn.backgroundColor = UIColor.redColor()
        exitBtn.layer.cornerRadius = 20
        exitBtn.layer.borderWidth = 1
        exitBtn.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

