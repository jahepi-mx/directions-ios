//
//  InstructionViewStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 19/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

class InstructionViewStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("InstructionViewController") as! InstructionViewController
        viewController.setCode(code)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("InstructionViewController") as! InstructionViewController
        return viewController
    }
}