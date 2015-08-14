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

    dynamic var id = ""
    dynamic var text = ""

    convenience init(text: String) {
        self.init()

        id = NSUUID().UUIDString
        self.text = text
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
