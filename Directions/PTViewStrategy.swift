//
//  PTViewStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 02/12/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

class PTViewStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("PTViewController") as! PTViewController
        viewController.setCodeValue(code)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        return viewController
    }
}