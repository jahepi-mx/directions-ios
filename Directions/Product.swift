//
//  Product.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 17/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class Product {
    
    private var name: String = "" // Producto
    private var description: String = "" // desc
    private var quantity: Int = 0 // inv
    private var selection: Int = 0 // surtido
    private var qo: Int = 0 // QO
    private var remain: Int = 0 // saldo
    private var lots: String = "" // lotes
    private var barcode: String = "";
    
    init() {
        
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    func getDescription() -> String {
        return description
    }
    
    func setLots(lots: String) {
        self.lots = lots
    }
    
    func getLots() -> String {
        return lots
    }
    
    func setQuantity(qty: Int) {
        self.quantity = qty
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    func setSelection(sel: Int) {
        self.selection = sel
    }
    
    func getSelection() -> Int {
        return selection
    }
    
    func setQo(qo: Int) {
        self.qo = qo
    }
    
    func getQo() -> Int {
        return qo
    }
    
    func setBarcode(barcode: String) {
        self.barcode = barcode
    }
    
    func getBarcode() -> String {
        return barcode
    }
    
    func setRemain(remain: Int) {
        self.remain = remain
    }
    
    func getRemain() -> Int {
        return remain
    }
    
    func getSpelledName() -> String {
        let chars = name.characters.map { String($0) }
        let spelled = chars.joinWithSeparator(" ")
        return spelled
    }
}
