//
//  ProductInstructionPieceStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 05/09/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

class ProductInstructionPieceViewStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductInstructionViewController") as! ProductInstructionViewController
        viewController.setCode(code, type: ProductInstructionViewController.CODE_TYPE.PIECE)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductInstructionViewController") as! ProductInstructionViewController
        viewController.flushCode()
        return viewController
    }
}