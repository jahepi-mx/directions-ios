//
//  ProductViewStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 18/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

class ProductViewStrategy: ScannerStrategy {
    
    func go(code: String) -> UIViewController {
        ProductManager.getInstance.dispose()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
        viewController.setCodeValue(code)
        return viewController
    }
    
    func back() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        return viewController
    }
}