//
//  Dialog.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 19/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Dialog {
    
    static func waitDialog() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Por favor espere ...", preferredStyle: .Alert)
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}