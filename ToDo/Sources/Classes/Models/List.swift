//
//  List.swift
//  ToDo
//
//  Created by Julian Grosshauser on 23/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class List: BaseObject, CustomStringConvertible {

    //MARK: Properties

    dynamic var name = ""
    dynamic var index = 0
    let todos = RealmSwift.List<Todo>()

    //MARK: Initialization

    convenience init(name: String) {
        self.init()

        self.name = name
    }

    //MARK: CustomStringConvertible

    override var description: String {
        return name
    }
}
