//
//  ArrayIterator.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 17/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

class ArrayIterator: Iterator {
    
    private var items: [AnyObject]
    private var index: Int
    
    init (items: [AnyObject]) {
        self.items = items
        index = 0
    }
    
    func next() -> AnyObject? {
        if (index < items.count) {
            let item: AnyObject = items[index]
            index = index + 1
            return item
        }
        return nil
    }
    
    func hasNext() -> Bool {
        return index < items.count
    }
    
    func reset() {
        index = 0
    }
}