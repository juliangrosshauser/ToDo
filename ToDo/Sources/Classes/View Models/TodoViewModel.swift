//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 30/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import ReactiveCocoa

class TodoViewModel: BaseViewModel {

    //MARK: Properties

    let list: MutableProperty<List?> = MutableProperty(nil)

    //MARK: Initialization

    override init() {
        super.init()
        addEnabled <~ list.producer.map { $0 != nil ? true : false }
        editEnabled <~ list.producer.map { $0?.todos.count ?? 0 > 0 }

        addItem = Action(enabledIf: addEnabled) { [unowned self] _ in
            self.appendTodo(self.itemDescription.value)
        }
    }

    //MARK: Managing Todos

    func appendTodo(text: String) -> SignalProducer<Int, NoError> {
        return SignalProducer(value: store.appendTodo(text, list: list.value!))
    }

    func removeTodo(todoID: String) {
        store.removeTodo(todoID, list: list.value!)
    }

    func moveTodo(sourceIndex sourceIndex: Int, destinationIndex: Int) {
        store.moveTodo(sourceIndex: sourceIndex, destinationIndex: destinationIndex, list: list.value!)
    }
}
