//
//  Store.swift
//  ToDo
//
//  Created by Julian Grosshauser on 12/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa

class Store {

    //MARK: Properties

    private let realm = try! Realm()

    //MARK: Get Objects

    func objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }

    //MARK: Add List

    func addList(name: String) -> SignalProducer<Void, NoError> {
        let list = List()
        list.name = name

        realm.write { [unowned self] in
            self.realm.add(list)
        }

        return SignalProducer(value: ())
    }

    //MARK: Append Todo To List

    func appendTodo(text: String, list: List) -> SignalProducer<Void, NoError> {
        let todo = Todo()
        todo.text = text

        realm.write {
            list.todos.append(todo)
        }

        return SignalProducer(value: ())
    }

    //MARK: Delete List

    func deleteList(listID: String) {
        guard let list = realm.objects(List).filter("id == %@", listID).first else { return }

        realm.write { [unowned self] in
            self.realm.delete(list)
        }
    }
    
    //MARK: Remove Todo From List
    
    func removeTodo(todoID: String, list: List) {
        guard let index = list.todos.indexOf("id == %@", todoID) else { return }
        let todo = list.todos[index]
        
        realm.write { [unowned self] in
            list.todos.removeAtIndex(index)
            self.realm.delete(todo)
        }
    }
}
