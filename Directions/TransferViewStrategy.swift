//
//  TransferViewStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 06/01/17.
//  Copyright © 2017 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

class TransferViewStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferViewController") as! TransferViewController
        viewController.setCode(code)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransferViewController") as! TransferViewController
        return viewController
    }
}