//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 30/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import ReactiveCocoa

class TodoViewModel: BaseViewModel {

    //MARK: Managing Todos

    func appendTodo(text: String, list: List) -> SignalProducer<Void, NoError> {
        return SignalProducer(value: store.appendTodo(text, list: list))
    }

    func removeTodo(todoID: String, list: List) {
        store.removeTodo(todoID, list: list)
    }
}
