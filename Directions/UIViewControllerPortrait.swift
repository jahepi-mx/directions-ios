//
//  UIViewControllerPortrait.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 19/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import UIKit

class UIViewControllerPortrait: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
}