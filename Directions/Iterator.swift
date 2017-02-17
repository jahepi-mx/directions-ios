//
//  Iterator.swift
//  Directions
//
//  Created by Javier Hernández Pineda on 17/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

protocol Iterator {
    func next() -> AnyObject?
    func hasNext() -> Bool
    func reset()
}