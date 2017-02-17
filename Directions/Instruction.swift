//
//  Instruction.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 17/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class Instruction {
    
    private var order: Int = 0
    private var ubication: String = ""
    private var productsInstruction: [ProductInstruction] = Array()
    
    init() {
        
    }
    
    func setUbication(ubication: String) {
        self.ubication = ubication
    }
    
    func getUbication() -> String {
        return ubication
    }
    
    func setOrder(order: Int) {
        self.order = order
    }
    
    func getOrder() -> Int {
        return order
    }
    
    func addProductInstruction(productInstruction: ProductInstruction) {
        productsInstruction.append(productInstruction)
    }
    
    func getSpelledUbication() -> String {
        let chars = ubication.characters.map { String($0) }
        let spelled = chars.joinWithSeparator(" ")
        return spelled
    }
    
    func getCurrentProductInstruction() -> ProductInstruction? {
        let iterator: Iterator = ArrayIterator(items: productsInstruction)
        while (iterator.hasNext()) {
            let productInstruction: ProductInstruction = iterator.next() as! ProductInstruction
            if (productInstruction.isDone() == false) {
                return productInstruction
            }
        }
        return nil
    }
    
    func getNumberOfCollectedProducts() -> Int {
        var collected : Int = 0;
        let iterator: Iterator = ArrayIterator(items: productsInstruction)
        while (iterator.hasNext()) {
            let productInstruction: ProductInstruction = iterator.next() as! ProductInstruction
            collected = collected + productInstruction.getQuantity()
        }
        return collected
    }
    
    func isDone() -> Bool {
        let iterator: Iterator = ArrayIterator(items: productsInstruction)
        while (iterator.hasNext()) {
            let productInstruction: ProductInstruction = iterator.next() as! ProductInstruction
            if (productInstruction.isDone() == false) {
                return false
            }
        }
        return true
    }
}