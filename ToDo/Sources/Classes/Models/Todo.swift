//
//  Todo.swift
//  ToDo
//
//  Created by Julian Grosshauser on 22/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {

    //MARK: Properties

    dynamic var id = NSUUID().UUIDString
    dynamic var text = ""

    //MARK: Initialization

    convenience init(text: String) {
        self.init()

        self.text = text
    }

    //MARK: Object

    override static func primaryKey() -> String? {
        return "id"
    }
}
