//
//  TransferViewController.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 06/01/17.
//  Copyright © 2017 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class TransferViewController: UIViewControllerPortrait {
    
    @IBOutlet weak var ubicationBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var ubicationLabel: UILabel!
    
    var alertErrorView: UIAlertController!
    var speech = Speech.getInstance
    
    func setCode(code: String) {
        Transfer.getInstance.ubication = code;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        ubicationBtn.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        instructionLabel.text = "Escanea la ubicación"
        ubicationLabel.text = "Ubicación"
        if (Transfer.getInstance.ubication != "") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferProductViewController") as! TransferProductViewController
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickUbicationBtn(sender: AnyObject) {
        Transfer.getInstance.ubication = "";
        let strategy: TransferViewStrategy = TransferViewStrategy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        viewController.setStrategy(strategy)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
}