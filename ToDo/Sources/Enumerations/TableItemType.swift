//
//  TableItemType.swift
//  ToDo
//
//  Created by Julian Grosshauser on 15/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

enum TableItemType: String, CustomStringConvertible {

    case List = "List"
    case Todo = "Todo"

    var description: String {
        return self.rawValue
    }
}
