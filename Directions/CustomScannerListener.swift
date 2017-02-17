//
//  CustomScannerListener.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 18/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

protocol CustomScannerListener {
    func onCaptureCode(code: String)
}
