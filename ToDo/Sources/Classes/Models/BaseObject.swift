//
//  BaseObject.swift
//  ToDo
//
//  Created by Julian Grosshauser on 14/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class BaseObject: Object {

    //MARK: Properties

    dynamic var id = NSUUID().UUIDString

    //MARK: Object

    override static func primaryKey() -> String? {
        return "id"
    }
}
