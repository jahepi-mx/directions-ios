//
//  TransferViewBoxStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 06/01/17.
//  Copyright © 2017 Javier Hernández Pineda. All rights reserved.
//
import Foundation
import UIKit

class TransferViewBoxStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferProductViewController") as! TransferProductViewController
        viewController.setCode(code, type: TransferProductViewController.CODE_TYPE_TRANSFER.BOX)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferProductViewController") as! TransferProductViewController
        Transfer.getInstance.type = TransferProductViewController.CODE_TYPE_TRANSFER.NONE;
        return viewController
    }
}