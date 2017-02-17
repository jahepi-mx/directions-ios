//
//  ViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class TransferMenuViewController: UIViewControllerPortrait {
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var queryBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 38/255, green: 108/255, blue: 166/255, alpha: 1)
        queryBtn.backgroundColor = UIColor.whiteColor()
        queryBtn.layer.cornerRadius = 20
        queryBtn.layer.borderWidth = 1
        queryBtn.layer.borderColor = UIColor.whiteColor().CGColor
        transferBtn.backgroundColor = UIColor.whiteColor()
        transferBtn.layer.cornerRadius = 20
        transferBtn.layer.borderWidth = 1
        transferBtn.layer.borderColor = UIColor.whiteColor().CGColor
        exitBtn.backgroundColor = UIColor.redColor()
        exitBtn.layer.cornerRadius = 20
        exitBtn.layer.borderWidth = 1
        exitBtn.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBAction func onClickTransfer1(sender: AnyObject) {
        Transfer.getInstance.section = "section1"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferViewController") as! TransferViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickTransfer2(sender: AnyObject) {
        Transfer.getInstance.section = "section2"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferViewController") as! TransferViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}