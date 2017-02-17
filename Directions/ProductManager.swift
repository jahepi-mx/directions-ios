//
//  File.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 17/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class ProductManager {
    
    // Singleton pattern, to share this instance between view controllers
    static let getInstance = ProductManager()
    
    private var code: String = "";
    private var products: [Product] = Array()
    private var instructions: [Instruction] = Array()
    
    init () {
    }
    
    func setCode(code: String) {
        self.code = code
    }
    
    func getCode() -> String {
        return code
    }
    
    func addProduct(product: Product) {
        products.append(product)
    }
    
    func productSize() -> Int {
        return products.count
    }
    
    func productIterator() -> Iterator {
        return ArrayIterator(items: products)
    }
    
    func getProduct(index: Int) -> Product {
        return products[index]
    }
    
    func getInstructionsProgress() -> Float {
        var progress: Int = 0
        let total: Int = getProductsTotal()!
        let iterator: Iterator = instructionIterator();
        while (iterator.hasNext()) {
            let instruction: Instruction = iterator.next() as! Instruction
            progress = progress + instruction.getNumberOfCollectedProducts()
        }
        if (total != 0) {
            return Float(total - progress) / Float(total)
        }
        return 0
    }
    
    func getCurrentInstruction() -> Instruction? {
        let iterator: Iterator = instructionIterator();
        while (iterator.hasNext()) {
            let instruction: Instruction = iterator.next() as! Instruction
            if (instruction.isDone() == false) {
                return instruction
            }
        }
        return nil
    }
    
    func getCurrentProductInstruction() -> ProductInstruction? {
        let instruction: Instruction? = getCurrentInstruction()
        if (instruction != nil) {
            return instruction?.getCurrentProductInstruction()
        }
        return nil
    }
    
    func getProductByName(name: String) -> Product? {
        for product in products {
            if (product.getName() == name) {
                return product
            }
        }
        return nil
    }
    
    func getProductsTotal() -> Int? {
        var total: Int = 0
        for product in products {
            total = total + product.getRemain()
        }
        return total
    }
    
    func addInstruction(instruction: Instruction) {
        instructions.append(instruction)
    }
    
    func instructionSize() -> Int {
        return instructions.count
    }
    
    func instructionIterator() -> Iterator {
        return ArrayIterator(items: instructions)
    }
    
    func hasInstructions() -> Bool {
        return instructions.count > 0
    }
    
    func hasCode() -> Bool {
        return code != ""
    }
    
    func isDone() -> Bool {
        let iterator: Iterator = instructionIterator();
        while (iterator.hasNext()) {
            let instruction: Instruction = iterator.next() as! Instruction
            if (instruction.isDone() == false) {
                return false
            }
        }
        return true
    }
    
    func dispose() {
        code = ""
        products.removeAll()
        instructions.removeAll()
    }
}