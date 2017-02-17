//
//  ScannerStrategy.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 18/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit

protocol ScannerStrategy {
    func go(code: String) -> UIViewController
    func back() -> UIViewController
}