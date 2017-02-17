//
//  WebServiceListener.swift
//  PTScanner
//
//  Created by Javier Hernández Pineda on 05/08/16.
//  Copyright © 2016 Javier Hernández Pineda. All rights reserved.
//

import Foundation

protocol WebServiceListener {
    func success(response: String)
    func error()
}