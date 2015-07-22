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

    dynamic var id = 0
    dynamic var text = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
