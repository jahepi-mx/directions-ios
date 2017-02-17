//
//  Transfer.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 06/01/17.
//  Copyright © 2017 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class Transfer {
    
    // Singleton pattern, to share this instance between view controllers
    static let getInstance = Transfer()
    
    var ubication: String = "";
    var product: String = "";
    var qty:Int = 0;
    var lots: String = "";
    var code: String = "";
    var type:TransferProductViewController.CODE_TYPE_TRANSFER = TransferProductViewController.CODE_TYPE_TRANSFER.NONE
    var section: String = "";

    func reset() {
        ubication = "";
        product = "";
        type = TransferProductViewController.CODE_TYPE_TRANSFER.NONE
        qty = 0
    }
}