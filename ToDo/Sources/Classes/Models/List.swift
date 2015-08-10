//
//  List.swift
//  ToDo
//
//  Created by Julian Grosshauser on 23/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class List: Object {

    dynamic var id = ""
    dynamic var name = ""
    let todos = RealmSwift.List<Todo>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
