//
//  BaseViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 30/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import ReactiveCocoa
import RealmSwift

class BaseViewModel {

    //MARK: Properties

    let store = Store()

    let addEnabled = MutableProperty(true)
    let editEnabled = MutableProperty(true)

    //MARK: Get Objects

    func objects<T: BaseObject>(type: T.Type) -> Results<T> {
        return store.objects(type)
    }
}
