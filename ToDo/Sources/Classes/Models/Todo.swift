//
//  Todo.swift
//  ToDo
//
//  Created by Julian Grosshauser on 22/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation

class Todo: BaseObject, CustomStringConvertible {

    //MARK: Properties

    dynamic var text = ""

    //MARK: Initialization

    convenience init(text: String) {
        self.init()

        self.text = text
    }

    //MARK: CustomStringConvertible

    override var description: String {
        return text
    }
}
