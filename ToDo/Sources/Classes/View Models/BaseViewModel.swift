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

    let editItems: Action<Bool, Bool, NoError>
    let newNumberOfItems: Action<Int, Int, NoError>

    //MARK: Initialization

    init() {
        editItems = Action(enabledIf: editEnabled) { SignalProducer(value: !$0) }
        newNumberOfItems = Action { SignalProducer(value: $0) }
        addEnabled <~ editItems.values.map { !$0 }
        editEnabled <~ newNumberOfItems.values.map {  $0 > 0 ? true : false }
    }

    //MARK: Get Objects

    func objects<T: BaseObject>(type: T.Type) -> Results<T> {
        return store.objects(type).sorted("index")
    }
}
