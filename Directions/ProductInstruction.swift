//
//  ProductInstruction.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 23/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class ProductInstruction {
    
    private var product: Product?
    private var lot: String = ""
    private var quantity: Int = 0
    private var consecutive: Int = 0
    private var line: Int = 0
    
    init() {
        
    }
    
    func setLot(lot: String) {
        self.lot = lot
    }
    
    func getLot() -> String {
        return lot
    }
    
    func setProduct(product: Product) {
        self.product = product
    }
    
    func getProduct() -> Product {
        return product!
    }
    
    func setQuantity(qty: Int) {
        self.quantity = qty
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    func setConsecutive(consecutive: Int) {
        self.consecutive = consecutive
    }
    
    func getConsecutive() -> Int {
        return consecutive
    }
    
    func setLine(line: Int) {
        self.line = line
    }
    
    func getLine() -> Int {
        return line
    }
    
    func getProductName() -> String? {
        return product?.getName()
    }
    
    func getProductDescription() -> String? {
        return product?.getDescription()
    }
    
    func getProductBarcode() -> String? {
        return product?.getBarcode()
    }
    
    func getProductSpelledName() -> String? {
        return product?.getSpelledName()
    }
    
    func subtractQuantity(qty: Int) -> Bool {
        var tmpQty: Int = self.quantity
        tmpQty = tmpQty - qty
        if (tmpQty < 0) {
            return false
        } else {
            quantity = tmpQty
            return true
        }
    }
    
    func checkForSubtractQuantity(qty: Int) -> Bool {
        if (qty == 0) {
            return false;
        }
        var tmpQty: Int = self.quantity
        tmpQty = tmpQty - qty
        if (tmpQty < 0) {
            return false
        } else {
            return true
        }
    }
    
    func isDone() -> Bool {
        return quantity <= 0
    }
}