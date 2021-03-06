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
    
    let editingMode = MutableProperty(false)

    var addItem: Action<Void, Int, NoError>!
    let editItems: Action<Bool, Bool, NoError>
    var deleteItem: Action<String, (deletedIndex: Int, itemCount: Int), NoError>!
    var moveItem: Action<(Int, Int), Void, NoError>!

    let itemDescription = MutableProperty("")
    let validItemDescription = MutableProperty(false)

    let itemCount: MutableProperty<Int> = MutableProperty(0)

    //MARK: Initialization

    init() {
        editItems = Action { SignalProducer(value: !$0) }
        editEnabled <~ itemCount.producer.map { $0 > 0 ? true : false }
        validItemDescription <~ itemDescription.producer.map { !$0.isEmpty }
        editingMode <~ editItems.values
        editingMode <~ editEnabled.producer.filter { !$0 }
        addEnabled <~ editingMode.producer.map { !$0 }
    }

    //MARK: Get Objects

    func objects<T: BaseObject>(type: T.Type) -> SignalProducer<Results<T>, NoError> {
        return SignalProducer(value: store.objects(type).sorted("index"))
    }

    func item<T: BaseObject>(type type: T.Type, index: Int) -> T {
        return store.objects(type)[index]
    }
}
