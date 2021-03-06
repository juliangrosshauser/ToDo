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
    var toggleDoneOnTodo: Action<Int, Int, NoError>!

    //MARK: Initialization

    override init() {
        super.init()
        addEnabled <~ list.producer.map { $0 != nil ? true : false }
        itemCount <~ list.producer.map { $0?.todos.count ?? 0 }

        addItem = Action(enabledIf: addEnabled) { [unowned self] _ in
            self.appendTodo(self.itemDescription.value)
        }

        deleteItem = Action(enabledIf: editEnabled) { [unowned self] todoID in
            self.removeTodo(todoID)
        }

        moveItem = Action(enabledIf: editEnabled) { [unowned self] (sourceIndex, destinationIndex) in
            self.moveTodo(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
        }

        toggleDoneOnTodo = Action { [unowned self] index in
            self.toggleDone(index: index)
        }

        itemCount <~ addItem.values
        itemCount <~ deleteItem.values.map { (_, itemCount) in itemCount }
    }

    //MARK: Managing Todos

    func item(index: Int) -> Todo {
        return super.item(type: Todo.self, index: index)
    }

    func appendTodo(text: String) -> SignalProducer<Int, NoError> {
        return SignalProducer(value: store.appendTodo(text, list: list.value!))
    }

    func removeTodo(todoID: String) -> SignalProducer<(deletedIndex: Int, itemCount: Int), NoError> {
        return SignalProducer(value: store.removeTodo(todoID, list: list.value!))
    }

    func moveTodo(sourceIndex sourceIndex: Int, destinationIndex: Int) -> SignalProducer<Void, NoError> {
        return SignalProducer(value: store.moveTodo(sourceIndex: sourceIndex, destinationIndex: destinationIndex, list: list.value!))
    }

    func toggleDone(index index: Int) -> SignalProducer<Int, NoError> {
        return SignalProducer(value: store.toggleDone(index: index, list: list.value!))
    }
}
