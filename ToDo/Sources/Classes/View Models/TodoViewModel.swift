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
    }

    //MARK: Managing Todos

    func appendTodo(text: String, list: List) -> SignalProducer<Void, NoError> {
        return SignalProducer(value: store.appendTodo(text, list: list))
    }

    func removeTodo(todoID: String, list: List) {
        store.removeTodo(todoID, list: list)
    }

    func moveTodo(sourceIndex sourceIndex: Int, destinationIndex: Int, list: List) {
        store.moveTodo(sourceIndex: sourceIndex, destinationIndex: destinationIndex, list: list)
    }
}
