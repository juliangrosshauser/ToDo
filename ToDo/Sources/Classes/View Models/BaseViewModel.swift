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

    var addItem: Action<Void, Int, NoError>!
    let editItems: Action<Bool, Bool, NoError>
    var deleteItem: Action<String, (deletedIndex: Int, itemCount: Int), NoError>!
    var moveItem: Action<(Int, Int), Void, NoError>!

    let itemDescription = MutableProperty("")
    let validItemDescription = MutableProperty(false)

    //MARK: Initialization

    init() {
        editItems = Action(enabledIf: editEnabled) { SignalProducer(value: !$0) }
        addEnabled <~ editItems.values.map { !$0 }
        validItemDescription <~ itemDescription.producer.map { !$0.isEmpty }
    }

    //MARK: Get Objects

    func objects<T: BaseObject>(type: T.Type) -> Results<T> {
        return store.objects(type).sorted("index")
    }
}
