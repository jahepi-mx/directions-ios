//
//  CustomCell.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 16/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var qo: UILabel!
    @IBOutlet weak var selection: UILabel!
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
